INCLUDES = -I$(VARNISHSRC)/include -I$(VARNISHSRC)

vmoddir = $(VMODDIR)
vmod_LTLIBRARIES = libvmod_crashhandler.la

libvmod_crashhandler_la_LDFLAGS = -module -export-dynamic -avoid-version

libvmod_crashhandler_la_SOURCES = \
	vcc_if.c \
	vcc_if.h \
	vmod_crashhandler.c

vcc_if.c vcc_if.h: $(VARNISHSRC)/lib/libvmod_std/vmod.py $(top_srcdir)/src/vmod_crashhandler.vcc
	@PYTHON@ $(VARNISHSRC)/lib/libvmod_std/vmod.py $(top_srcdir)/src/vmod_crashhandler.vcc

VMOD_TESTS = tests/*.vtc
.PHONY: $(VMOD_TESTS)

tests/*.vtc:
	varnishtest -Dvarnishd=$(VARNISHSRC)/bin/varnishd/varnishd -Dvmod_topbuild=$(abs_top_builddir) $@

check: $(VMOD_TESTS)

EXTRA_DIST = \
	vmod_crashhandler.vcc \
	$(VMOD_TESTS)

CLEANFILES = $(builddir)/vcc_if.c $(builddir)/vcc_if.h
