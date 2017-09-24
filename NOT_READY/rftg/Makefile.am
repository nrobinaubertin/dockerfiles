bin_PROGRAMS = rftgserver ai_client
noinst_PROGRAMS = learner dumpnet
dist_bin_SCRIPTS = do_train

dumpnet_SOURCES = net.c dumpnet.c net.h
learner_SOURCES = engine.c init.c ai.c learner.c net.c net.h rftg.h
rftgserver_SOURCES = server.c engine.c init.c ai.c loadsave.c net.c net.h rftg.h comm.c comm.h
ai_client_SOURCES = ai_client.c engine.c init.c ai.c net.c net.h rftg.h comm.c comm.h

dist_pkgdata_DATA = cards.txt campaign.txt images.data

AM_CFLAGS = -Wall

rftgserver_CFLAGS = -Wall -DRFTGDIR=\"$(pkgdatadir)\" -DBINDIR=\"$(bindir)\"
rftgserver_LDADD = -lmysqlclient -lpthread

ai_client_CFLAGS = -Wall -DRFTGDIR=\"$(pkgdatadir)\"

SUBDIRS = network

ACLOCAL_AMFLAGS = -I m4

EXTRA_DIST = config.rpath m4/ChangeLog osx
