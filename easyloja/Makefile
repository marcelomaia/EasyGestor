VERSION=$(shell BUILD=1 python -c "import stoq; print stoq.version")
PACKAGE=stoq
DEBPACKAGE=python-kiwi
WEBDOC_DIR=/mondo/htdocs/stoq.com.br/doc/devel
SCHEMADIR=/mondo/htdocs/stoq.com.br/devel/schema/

stoqlib.pickle:
	pydoctor --project-name="Stoqlib" \
		 --add-package=stoqlib \
		 -o stoqlib.pickle stoqlib

apidocs: stoqlib.pickle
	make -C ../stoqdrivers stoqdrivers.pickle
	pydoctor --project-name="Stoqlib" \
		 --make-html \
		 --extra-system=../stoqdrivers/stoqdrivers.pickle:../stoqdrivers \
		 -p stoqlib.pickle

schemadocs:
	schemaspy -t pgsql -host anthem -db $(USER) -u $(USER) -s public -o $(SCHEMADIR)

manual:
	mkdir html
	yelp-build html -o html help/pt_BR

web: apidocs
	scp -r apidocs async.com.br:$(WEBDOC_DIR)/stoqlib-tmp
	ssh async.com.br rm -fr $(WEBDOC_DIR)/stoqlib
	ssh async.com.br mv $(WEBDOC_DIR)/stoqlib-tmp $(WEBDOC_DIR)/stoqlib
	scp stoqlib.pickle async.com.br:$(WEBDOC_DIR)/stoqlib

pep8:
	trial stoqlib.test.test_pep8

pyflakes:
	trial stoqlib.test.test_pyflakes

pylint:
	pylint --load-plugins tools/pylint_stoq -E \
	    stoqlib/domain/*.py \
	    stoqlib/domain/payment/*.py

check:
	LC_ALL=C trial stoq stoqlib

DEBVERSION=$(shell dpkg-parsechangelog -ldebian/changelog|egrep ^Version|cut -d\  -f2)
TARBALL=$(PACKAGE)-$(VERSION).tar.gz
BUILDDIR=tmp
DOWNLOADWEBDIR=/mondo/htdocs/stoq.com.br/download
TARBALL_DIR=$(DOWNLOADWEBDIR)/sources
TESTDLDIR=$(DOWNLOADWEBDIR)/test
UPDATEAPTDIR=/mondo/local/bin/update-apt-directory

deb: sdist
	rm -fr $(BUILDDIR)
	mkdir $(BUILDDIR)
	cd $(BUILDDIR) && tar xfz ../dist/$(TARBALL)
	cd $(BUILDDIR) && ln -s ../dist/$(TARBALL) $(PACKAGE)_$(VERSION).orig.tar.gz
	cd $(BUILDDIR)/$(PACKAGE)-$(VERSION) && debuild
	rm -fr $(BUILDDIR)/$(PACKAGE)-$(VERSION)
	mv $(BUILDDIR)/* dist
	rm -fr $(BUILDDIR)

sdist:
	kiwi-i18n -p $(PACKAGE) -c
	python setup.py -q sdist

rpm: sdist
	rpmbuild -ta --sign dist/$(TARBALL)

upload:
	scp dist/$(TARBALL) async.com.br:$(TARBALL_DIR)
	for suffix in "gz" "dsc" "build" "changes" "deb"; do \
	  scp dist/$(PACKAGE)_$(VERSION)*."$$suffix" async.com.br:$(DOWNLOADWEBDIR)/ubuntu; \
	done
	ssh async.com.br $(UPDATEAPTDIR) $(DOWNLOADWEBDIR)/ubuntu

test-upload:
	cp dist/$(PACKAGE)*_$(DEBVERSION)*.deb $(TESTDLDIR)/ubuntu
	cp dist/$(PACKAGE)-$(VERSION)*.rpm $(TESTDLDIR)/fedora
	for suffix in "gz" "dsc" "build" "changes"; do \
	  cp dist/$(PACKAGE)_$(DEBVERSION)*."$$suffix" $(TESTDLDIR)/ubuntu; \
	done
	$(UPDATEAPTDIR) $(TESTDLDIR)/ubuntu

release: clean sdist

release-deb:
	debchange -v $(VERSION)-1 "New release"

release-tag:
	bzr tag $(VERSION)

ubuntu-package: deb
	cp /mondo/pbuilder/edgy/result/$(PACKAGE)_$(DEBVERSION)_all.deb $(DOWNLOADWEBDIR)/ubuntu
	$(UPDATEAPTDIR) $(DOWNLOADWEBDIR)/ubuntu

tags:
	find -name \*.py|xargs ctags

TAGS:
	find -name \*.py|xargs etags

nightly:
	/mondo/local/bin/build-svn-deb

ChangeLog:
	svn2cl --reparagraph -i --authors common/authors.xml

.PHONY: sdist deb upload tags TAGS nightly ChangeLog

.PHONY: stoqlib.pickle TAGS
