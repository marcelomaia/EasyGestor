# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

""" Splash screen helper """

import gobject
import gtk
import pangocairo
import time

import pango
from kiwi.component import get_utility
from kiwi.environ import environ
from stoqlib.lib.interfaces import IAppInfo
from stoqlib.lib.translation import stoqlib_gettext

WIDTH = 400
HEIGHT = 260
BORDER = 8  # This includes shadow out border from GtkFrame
_ = stoqlib_gettext


class SplashScreen(gtk.Window):

    def __init__(self):
        gtk.Window.__init__(self)
        self.set_type_hint(gtk.gdk.WINDOW_TYPE_HINT_SPLASHSCREEN)
        self.resize(WIDTH, HEIGHT)
        # Ubuntu has backported the 3.0 has-resize-grip property,
        # disable it as it doesn't make sense for splash screens
        if hasattr(self.props, 'has_resize_grip'):
            self.props.has_resize_grip = False
        frame = gtk.Frame()
        frame.set_shadow_type(gtk.SHADOW_ETCHED_IN)
        self.add(frame)

        darea = gtk.DrawingArea()
        darea.connect("expose-event", self.expose)
        frame.add(darea)

        self.show_all()
        filename = environ.find_resource("pixmaps", "splash.png")
        self._pixbuf = gtk.gdk.pixbuf_new_from_file(filename)

    def _get_label(self):
        info = get_utility(IAppInfo, None)
        if not info:
            return "Stoq"
        version = info.get("version")
        if ' ' in version:
            ver, rev = version.split(' ')
            version = ver
        return _("Version: %s") % (version,)

    def expose(self, widget, event):
        cr = widget.window.cairo_create()
        # Draw splash
        cr.set_source_pixbuf(self._pixbuf, 0, 0)
        cr.paint()

        # Draw version
        cr.set_source_rgb(.1, .1, .1)
        pcr = pangocairo.CairoContext(cr)
        layout = pcr.create_layout()
        layout.set_font_description(pango.FontDescription("Sans Bold 14"))
        layout.set_markup(self._get_label())
        pcr.update_layout(layout)
        w, h = layout.get_pixel_size()
        cr.move_to(0 + BORDER, HEIGHT - h - BORDER)
        pcr.show_layout(layout)

    def show(self):
        gtk.Window.show(self)

        time.sleep(0.01)
        while gtk.events_pending():
            time.sleep(0.01)
            gtk.main_iteration()


_splash = None


def show_splash():
    global _splash
    _splash = SplashScreen()
    _splash.show()


def hide_splash():
    global _splash
    if _splash:
        gobject.idle_add(_splash.destroy)
        _splash = None
