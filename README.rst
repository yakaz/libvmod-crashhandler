=================
vmod_crashhandler
=================

---------------------
Varnish Crash Handler
---------------------

:Author: Kristian Lyngstøl
:Date: 2011-12-19
:Version: 1.0
:Manual section: 3

SYNOPSIS
========

import crashhandler;

DESCRIPTION
===========

Varnish Module that catches segfaults (SIGSEGV) and issues the regular
panic code to get a back trace.

Also includes a function to trigger a segfault forcibly. Use at your own
peril.

FUNCTIONS
=========

crash
-----

Prototype
        ::

                crash()
Return value
	VOID
Description
	Raises a SIGSEGV which in turn is caught.
Example
        ::

                crashhandler.crash();

INSTALLATION
============

The source tree is based on autotools to configure the building, and
does also have the necessary bits in place to do functional unit tests
using the varnishtest tool.

Usage::

 ./configure VARNISHSRC=DIR [VMODDIR=DIR]

`VARNISHSRC` is the directory of the Varnish source tree for which to
compile your vmod. Both the `VARNISHSRC` and `VARNISHSRC/include`
will be added to the include search paths for your module.

Optionally you can also set the vmod install directory by adding
`VMODDIR=DIR` (defaults to the pkg-config discovered directory from your
Varnish installation).

Make targets:

* make - builds the vmod
* make install - installs your vmod in `VMODDIR`
* make check - runs the unit tests in ``src/tests/*.vtc``

Note that some of the test cases /will/ and should fail at the time being.

In your VCL you could then use this vmod along the following lines::
        
        import crashhandler;

        sub vcl_recv {
                if (req.http.x-crash) {
                        crashhandler.crash();
                }
        }

HISTORY
=======

1.0: Initial version with segfault handler and crash()

BUGS
====

The test case test01 will fail. This is because it issues crash(); which
does indeed crash. The test case should be designed to detect lack of
crashing, but alas, it does not accomplish this yet.

COPYRIGHT
=========

This document is licensed under the same license as the
libvmod-crashhandler project. See LICENSE for details.

* Copyright (c) 2011 Varnish Software
