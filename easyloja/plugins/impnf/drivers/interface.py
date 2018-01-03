class GenericPrinter(object):
    def _load_methods(self):
        raise NotImplementedError

    #
    # Setup methods
    #

    def set_baud_rate(self, br):
        raise NotImplementedError

    #
    # Common methods
    #

    def close_port(self):
        raise NotImplementedError

    def open_drawer(self):
        raise NotImplementedError

    def write_text(self, txt):
        raise NotImplementedError

    def write_formated_text(self, txt, bold=False, italic=False, underline=False, expand=False):
        """
        <b>bold</b><i>italic</i><s>underline</s><e>expanded</e><c>condensed</c>
        replaces tags according to the driver
        """
        raise NotImplementedError

    def cut_paper(self):
        raise NotImplementedError

    def qr_code(self, txt):
        raise NotImplementedError

    def ean13(self, txt):
        raise NotImplementedError

    def test_printer(self):
        raise NotImplementedError

    def replace_all(self, text, dic):
        """
        from http://stackoverflow.com/questions/6116978/python-replace-multiple-strings
        d = {"cat": "dog", "dog": "pig"}
        replace_all('i like cat but dog i love more', d)
        'i like dog but pig i love more'
        """

        for i, j in dic.iteritems():
            text = text.replace(i, j)
        return text
