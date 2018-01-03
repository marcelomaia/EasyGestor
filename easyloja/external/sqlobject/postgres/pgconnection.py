from sqlobject.dbconnection import DBAPI
import re
from sqlobject import col
from sqlobject import sqlbuilder
from sqlobject.converters import registerConverter
from sqlobject.dberrors import *

class ErrorMessage(str):
    def __new__(cls, e):
        obj = str.__new__(cls, e[0])
        obj.code = None
        obj.module = e.__module__
        obj.exception = e.__class__.__name__
        return obj

class PostgresConnection(DBAPI):

    supportTransactions = True
    dbName = 'postgres'
    schemes = [dbName, 'postgresql']

    def __init__(self, dsn=None, host=None, port=None, db=None,
                 user=None, password=None, **kw):
        drivers = kw.pop('driver', None) or 'psycopg'
        for driver in drivers.split(','):
            driver = driver.strip()
            if not driver:
                continue
            try:
                if driver == 'psycopg2':
                    import psycopg2 as psycopg
                elif driver == 'psycopg1':
                    import psycopg
                elif driver == 'psycopg':
                    try:
                        import psycopg2 as psycopg
                    except ImportError:
                        import psycopg
                elif driver == 'pygresql':
                    import pgdb
                    self.module = pgdb
                else:
                    raise ValueError('Unknown PostgreSQL driver "%s", expected psycopg2, psycopg1 or pygresql' % driver)
            except ImportError:
                pass
            else:
                break
        else:
            raise ImportError('Cannot find a PostgreSQL driver, tried %s' % drivers)
        if driver.startswith('psycopg'):
            self.module = psycopg
            # Register a converter for psycopg Binary type.
            registerConverter(type(psycopg.Binary('')),
                              PsycoBinaryConverter)

        self.user = user
        self.host = host
        self.port = port
        self.db = db
        self.password = password
        self.dsn_dict = dsn_dict = {}
        if host:
            dsn_dict["host"] = host
        if port:
            if driver == 'pygresql':
                dsn_dict["host"] = "%s:%d" % (host, port)
            else:
                if psycopg.__version__.split('.')[0] == '1':
                    dsn_dict["port"] = str(port)
                else:
                    dsn_dict["port"] = port
        if db:
            dsn_dict["database"] = db
        if user:
            dsn_dict["user"] = user
        if password:
            dsn_dict["password"] = password
        sslmode = kw.pop("sslmode", None)
        if sslmode:
            dsn_dict["sslmode"] = sslmode
        self.use_dsn = dsn is not None
        if dsn is None:
            if driver == 'pygresql':
                dsn = ''
                if host:
                    dsn += host
                dsn += ':'
                if db:
                    dsn += db
                dsn += ':'
                if user:
                    dsn += user
                dsn += ':'
                if password:
                    dsn += password
            else:
                dsn = []
                if db:
                    dsn.append('dbname=%s' % db)
                if user:
                    dsn.append('user=%s' % user)
                if password:
                    dsn.append('password=%s' % password)
                if host:
                    dsn.append('host=%s' % host)
                if port:
                    dsn.append('port=%d' % port)
                if sslmode:
                    dsn.append('sslmode=%s' % sslmode)
                dsn = ' '.join(dsn)
        self.driver = driver
        self.dsn = dsn
        self.unicodeCols = kw.pop('unicodeCols', False)
        self.schema = kw.pop('schema', None)
        self.dbEncoding = kw.pop("charset", None)
        DBAPI.__init__(self, **kw)

    @classmethod
    def _connectionFromParams(cls, user, password, host, port, path, args):
        path = path.strip('/')
        if (host is None) and path.count('/'): # Non-default unix socket
            path_parts = path.split('/')
            host = '/' + '/'.join(path_parts[:-1])
            path = path_parts[-1]
        return cls(host=host, port=port, db=path, user=user, password=password, **args)

    def _setAutoCommit(self, conn, auto):
        # psycopg2 does not have an autocommit method.
        if hasattr(conn, 'autocommit'):
            try:
                conn.autocommit(auto)
            except TypeError:
                conn.autocommit = auto

    def makeConnection(self):
        try:
            if self.use_dsn:
                conn = self.module.connect(self.dsn)
            else:
                conn = self.module.connect(**self.dsn_dict)
        except self.module.OperationalError, e:
            raise OperationalError("%s; used connection string %r" % (e, self.dsn))

        # For printDebug in _executeRetry
        self._connectionNumbers[id(conn)] = self._connectionCount

        if self.autoCommit: self._setAutoCommit(conn, 1)
        c = conn.cursor()
        if self.schema:
            self._executeRetry(conn, c, "SET search_path TO " + self.schema)
        dbEncoding = self.dbEncoding
        if dbEncoding:
            self._executeRetry(conn, c, "SET client_encoding TO '%s'" % dbEncoding)
        return conn

    def _executeRetry(self, conn, cursor, query):
        try:
            return cursor.execute(query)
        except self.module.OperationalError, e:
            raise OperationalError(ErrorMessage(e))
        except self.module.IntegrityError, e:
            msg = ErrorMessage(e)
            if e.pgcode == '23505':
                raise DuplicateEntryError(msg)
            else:
                raise IntegrityError(msg)
        except self.module.InternalError, e:
            raise InternalError(ErrorMessage(e))
        except self.module.ProgrammingError, e:
            raise ProgrammingError(ErrorMessage(e))
        except self.module.DataError, e:
            raise DataError(ErrorMessage(e))
        except self.module.NotSupportedError, e:
            raise NotSupportedError(ErrorMessage(e))
        except self.module.DatabaseError, e:
            raise DatabaseError(ErrorMessage(e))
        except self.module.InterfaceError, e:
            raise InterfaceError(ErrorMessage(e))
        except self.module.Warning, e:
            raise Warning(ErrorMessage(e))
        except self.module.Error, e:
            raise Error(ErrorMessage(e))

    def _queryInsertID(self, conn, soInstance, id, names, values):
        table = soInstance.sqlmeta.table
        idName = soInstance.sqlmeta.idName
        sequenceName = soInstance.sqlmeta.idSequence or \
                               '%s_%s_seq' % (table, idName)
        c = conn.cursor()
        if id is None:
            self._executeRetry(conn, c, "SELECT NEXTVAL('%s')" % sequenceName)
            id = c.fetchone()[0]
        names = [idName] + names
        values = [id] + values
        q = self._insertSQL(table, names, values)
        if self.debug:
            self.printDebug(conn, q, 'QueryIns')
        self._executeRetry(conn, c, q)
        if self.debugOutput:
            self.printDebug(conn, id, 'QueryIns', 'result')
        return id

    @classmethod
    def _queryAddLimitOffset(cls, query, start, end):
        if not start:
            return "%s LIMIT %i" % (query, end)
        if not end:
            return "%s OFFSET %i" % (query, start)
        return "%s LIMIT %i OFFSET %i" % (query, end-start, start)

    def createColumn(self, soClass, col):
        return col.postgresCreateSQL()

    def createReferenceConstraint(self, soClass, col):
        return col.postgresCreateReferenceConstraint()

    def createIndexSQL(self, soClass, index):
        return index.postgresCreateIndexSQL(soClass)

    def createIDColumn(self, soClass):
        # Johan 2006-09-25: use BIGSERIAL for 64-bit ids
        key_type = {int: "BIGSERIAL", str: "TEXT"}[soClass.sqlmeta.idType]
        return '%s %s PRIMARY KEY' % (soClass.sqlmeta.idName, key_type)

    def dropTable(self, tableName, cascade=False):
        self.query("DROP TABLE %s %s" % (tableName,
                                         cascade and 'CASCADE' or ''))

    def joinSQLType(self, join):
        return 'INT NOT NULL'

    def tableExists(self, tableName):
        result = self.queryOne("SELECT COUNT(relname) FROM pg_class WHERE relname = %s"
                               % self.sqlrepr(tableName))
        return result[0]

    def addColumn(self, tableName, column):
        self.query('ALTER TABLE %s ADD COLUMN %s' %
                   (tableName,
                    column.postgresCreateSQL()))

    def delColumn(self, sqlmeta, column):
        self.query('ALTER TABLE %s DROP COLUMN %s' % (sqlmeta.table, column.dbName))

    def columnsFromSchema(self, tableName, soClass):

        keyQuery = """
        SELECT pg_catalog.pg_get_constraintdef(oid) as condef
        FROM pg_catalog.pg_constraint r
        WHERE r.conrelid = %s::regclass AND r.contype = 'f'"""

        colQuery = """
        SELECT a.attname,
        pg_catalog.format_type(a.atttypid, a.atttypmod), a.attnotnull,
        (SELECT substring(d.adsrc for 128) FROM pg_catalog.pg_attrdef d
        WHERE d.adrelid=a.attrelid AND d.adnum = a.attnum)
        FROM pg_catalog.pg_attribute a
        WHERE a.attrelid =%s::regclass
        AND a.attnum > 0 AND NOT a.attisdropped
        ORDER BY a.attnum"""

        primaryKeyQuery = """
        SELECT pg_index.indisprimary,
            pg_catalog.pg_get_indexdef(pg_index.indexrelid)
        FROM pg_catalog.pg_class c, pg_catalog.pg_class c2,
            pg_catalog.pg_index AS pg_index
        WHERE c.relname = %s
            AND c.oid = pg_index.indrelid
            AND pg_index.indexrelid = c2.oid
            AND pg_index.indisprimary
        """

        keyData = self.queryAll(keyQuery % self.sqlrepr(tableName))
        keyRE = re.compile(r"\((.+)\) REFERENCES (.+)\(")
        keymap = {}

        for (condef,) in keyData:
            match = keyRE.search(condef)
            if match:
                field, reftable = match.groups()
                keymap[field] = reftable.capitalize()

        primaryData = self.queryAll(primaryKeyQuery % self.sqlrepr(tableName))
        primaryRE = re.compile(r'CREATE .*? USING .* \((.+?)\)')
        primaryKey = None
        for isPrimary, indexDef in primaryData:
            match = primaryRE.search(indexDef)
            assert match, "Unparseable contraint definition: %r" % indexDef
            assert primaryKey is None, "Already found primary key (%r), then found: %r" % (primaryKey, indexDef)
            primaryKey = match.group(1)
        assert primaryKey, "No primary key found in table %r" % tableName
        if primaryKey.startswith('"'):
            assert primaryKey.endswith('"')
            primaryKey = primaryKey[1:-1]

        colData = self.queryAll(colQuery % self.sqlrepr(tableName))
        results = []
        if self.unicodeCols:
            client_encoding = self.queryOne("SHOW client_encoding")[0]
        for field, t, notnull, defaultstr in colData:
            if field == primaryKey:
                continue
            if field in keymap:
                colClass = col.ForeignKey
                kw = {'foreignKey': soClass.sqlmeta.style.dbTableToPythonClass(keymap[field])}
                name = soClass.sqlmeta.style.dbColumnToPythonAttr(field)
                if name.endswith('ID'):
                    name = name[:-2]
                kw['name'] = name
            else:
                colClass, kw = self.guessClass(t)
                if self.unicodeCols and colClass is col.StringCol:
                    colClass = col.UnicodeCol
                    kw['dbEncoding'] = client_encoding
                kw['name'] = soClass.sqlmeta.style.dbColumnToPythonAttr(field)
            kw['dbName'] = field
            kw['notNone'] = notnull
            if defaultstr is not None:
                kw['default'] = self.defaultFromSchema(colClass, defaultstr)
            elif not notnull:
                kw['default'] = None
            results.append(colClass(**kw))
        return results

    def guessClass(self, t):
        if t.count('point'): # poINT before INT
            return col.StringCol, {}
        elif t.count('int'):
            return col.IntCol, {}
        elif t.count('varying') or t.count('varchar'):
            if '(' in t:
                return col.StringCol, {'length': int(t[t.index('(')+1:-1])}
            else: # varchar without length in Postgres means any length
                return col.StringCol, {}
        elif t.startswith('character('):
            return col.StringCol, {'length': int(t[t.index('(')+1:-1]),
                                   'varchar': False}
        elif t.count('float') or t.count('real') or t.count('double'):
            return col.FloatCol, {}
        elif t == 'text':
            return col.StringCol, {}
        elif t.startswith('timestamp'):
            return col.DateTimeCol, {}
        elif t.startswith('datetime'):
            return col.DateTimeCol, {}
        elif t.startswith('date'):
            return col.DateCol, {}
        elif t.startswith('bool'):
            return col.BoolCol, {}
        elif t.startswith('bytea'):
            return col.BLOBCol, {}
        else:
            return col.Col, {}

    def defaultFromSchema(self, colClass, defaultstr):
        """
        If the default can be converted to a python constant, convert it.
        Otherwise return is as a sqlbuilder constant.
        """
        if colClass == col.BoolCol:
            if defaultstr == 'false':
                return False
            elif defaultstr == 'true':
                return True
        return getattr(sqlbuilder.const, defaultstr)

    def _createOrDropDatabase(self, op="CREATE", dbname=None):
        # We have to connect to *some* database, so we'll connect to
        # template1, which is a common open database.
        # @@: This doesn't use self.use_dsn or self.dsn_dict
        if self.driver == 'pygresql':
            dsn = '%s:template1:%s:%s' % (
                self.host or '', self.user or '', self.password or '')
        else:
            dsn = 'dbname=template1'
            if self.user:
                dsn += ' user=%s' % self.user
            if self.password:
                dsn += ' password=%s' % self.password
            if self.host:
                dsn += ' host=%s' % self.host
        conn = self.module.connect(dsn)
        cur = conn.cursor()
        # We must close the transaction with a commit so that
        # the CREATE DATABASE can work (which can't be in a transaction):
        self._executeRetry(conn, cur, 'COMMIT')
        dbname = dbname or self.db
        self._executeRetry(conn, cur, '%s DATABASE %s' % (op, dbname))
        cur.close()
        conn.close()

    def createEmptyDatabase(self, dbname=None):
        self._createOrDropDatabase(dbname=dbname)

    def dropDatabase(self, dbname=None):
        self._createOrDropDatabase(op="DROP", dbname=dbname)

    def databaseExists(self, dbname):
        res = self.queryOne(
            "SELECT COUNT(*) FROM pg_database WHERE datname='%s'" % dbname)
        return res[0] == 1

    def renameDatabase(self, src, dest):
        conn = self.getConnection()
        cur = conn.cursor()
        cur.execute('COMMIT')
        cur.execute('ALTER DATABASE %s RENAME TO %s' % (src, dest))
        cur.close()

        return True

    def dbVersion(self):
        # PostgreSQL 8.4.8 on i686-pc-linux-gnu,
        # PostgreSQL 8.4.8, compiled by Visual C++
        version_string = self.queryOne('SELECT VERSION();')[0]
        version = version_string.split(' ', 2)[1]
        if version.endswith(','):
            version = version[:-1]
        return tuple(map(int, version.split('.')))

    # Johan 2006-09-24: Add Sequence methods
    def sequenceExists(self, sequence):
        return self.tableExists(sequence)

    def createSequence(self, sequence):
        self.query('CREATE SEQUENCE "%s"' % sequence)

    def dropSequence(self, sequence):
        self.query('DROP SEQUENCE "%s"' % sequence)

    def bumpSequence(self, sequence, start, minvalue, maxvalue):
        self.query('ALTER SEQUENCE "%s" START %d MINVALUE %d MAXVALUE %d' % (
            sequence, start, minvalue, maxvalue))



# Converter for psycopg Binary type.
def PsycoBinaryConverter(value, db):
    assert db == 'postgres'
    return str(value)
