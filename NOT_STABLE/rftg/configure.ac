AC_PREREQ(2.61)
AC_INIT([rftg], [0.9.5], [keldon@keldon.net])
AC_CONFIG_SRCDIR([engine.c])
AC_CONFIG_HEADER(config.h)

AC_CANONICAL_HOST

# Compiler flags, etc for certain platforms
# case $host_os in
# 	darwin* )
# 		LIBS="$LIBS -framework CoreFoundation"
# 		;;
# 	mingw* )
# 		CFLAGS="$CFLAGS -mwindows"
# 		LDFLAGS="$LDFLAGS -mwindows"
# 		LIBS="$LIBS -lws2_32"
# 		;;
# esac

AM_INIT_AUTOMAKE([1.9])

AC_PROG_CC

AC_CHECK_LIB([m], [exp])

AC_HEADER_STDC
AC_CHECK_HEADERS([stdio.h])

# AM_PATH_GTK_2_0(2.16.0)

### Check to see if GDK uses the quartz backend and if we can use MacOSX
### integration
# _gdk_tgt=`$PKG_CONFIG --variable=target gdk-2.0`
# AM_CONDITIONAL([GDK_TARGET_QUARTZ], [test x$_gdk_tgt = xquartz])
# if test "x$_gdk_tgt" = xquartz; then
# 	PKG_CHECK_MODULES(GTK_MAC, gtk-mac-integration)
# 	AC_SUBST(GTK_MAC_LIBS)
# 	AC_SUBST(GTK_MAC_CFLAGS)
# fi

AC_ARG_ENABLE([server], [AS_HELP_STRING([--enable-server],
		[enable multiplayer server])], [], [enable_server=no])

AS_IF([test "x$enable_server" != xno],
	[AC_CHECK_LIB([mysqlclient], [mysql_init], true,
	[AC_MSG_FAILURE(
	 [--enable-server was given, but test for mysqlclient failed])])])

AM_CONDITIONAL(BUILD_SERVER, test "x$enable_server" != xno)

#AC_FUNC_MALLOC
AC_FUNC_MEMCMP
AC_CHECK_FUNCS([memset])

AC_CONFIG_FILES([Makefile network/Makefile])
AC_OUTPUT
