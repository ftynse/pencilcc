# AX_CHECK_OPENCL
#
# Check for OpenCL implementation.  If OpenCL is found, HAS_OPENCL is defined
# as "yes", the required compiler and linker headers are put in OPENCL_CFLAGS
# and OPENCL_LIBS, respectively.  Otherwise, HAS_OPENCL is defined as "no".
#
# HAVE_CL_OPENCL_H and HAVE_OPENCL_OPENCL_H are defined depending on the
# presence of system headers CL/opencl.h and OpenCL/opencl.h, respectively.
# These may be used as an alternative to the usual
# #ifdef __APPLE__
# #include <OpenCL/opencl.h>
# #else
# #include <CL/opencl.h>
# #endif
#
# Copyright (c) Inria, 2016
# This software is distributed on the terms of 3-clause BSD license.
#
# Author: Oleksandr Zinenko <oleksandr.zinenko@inria.fr>

AC_DEFUN([AX_CHECK_OPENCL], [
    AC_SUBST(HAS_OPENCL)
    HAS_OPENCL=no

    m4_define([AX_CHECK_OPENCL_PROGRAM],
              [AC_LANG_PROGRAM([[
# if defined(HAVE_CL_OPENCL_H)
#  include <CL/opencl.h>
# elif defined(HAVE_OPENCL_OPENCL_H)
#  include <OpenCL/opencl.h>
# else
#  error no opencl.h
# endif]],
               [[clFinish(0);]])])

    AC_CHECK_HEADERS([CL/opencl.h],[
      OLD_LIBS=$LIBS
      LIBS="-lOpenCL $LIBS"
      AC_MSG_CHECKING([how to link OpenCL])
      AC_LINK_IFELSE([AX_CHECK_OPENCL_PROGRAM],
                     [HAS_OPENCL=yes
                      AX_OPENCL_LIBS="-lOpenCL"],
                     [LIBS="-lCL $OLD_LIBS"
                      AC_LINK_IFELSE([AX_CHECK_OPENCL_PROGRAM],
                                     [HAS_OPENCL=yes
                                      AX_OPENCL_LIBS="-lCL"])])
      AC_MSG_RESULT($AX_OPENCL_LIBS)
      LIBS=$OLD_LIBS
    ])

    AC_CHECK_HEADERS([OpenCL/opencl.h],[
      OLD_LIBS=$LIBS
      LIBS="-framework OpenCl $LIBS"
      AC_MSG_CHECKING([how to link OpenCL])
      AC_LINK_IFELSE([AX_CHECK_OPENCL_PROGRAM],
                     [HAS_OPENCL=yes
                      AX_OPENCL_LIBS="-framework OpenCl"])
      AC_MSG_RESULT($AX_OPENCL_LIBS)
      LIBS=$OLD_LIBS
    ])
    AS_IF([test "X$HAS_OPENCL" = Xno],
          [OPENCL_LIBS=""],
          [OPENCL_LIBS=$AX_OPENCL_LIBS])
    OPENCL_CFLAGS=""

    AC_SUBST(OPENCL_LIBS)
    AC_SUBST(OPENCL_CLAGS)
])

