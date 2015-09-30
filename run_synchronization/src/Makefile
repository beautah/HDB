# run_synchronization makefile
# $Id: Makefile,v 1.2 2005/05/11 20:11:13 uchdba Exp $

include ../../Environ

OBJDIR = $(HDB_ENV)/run_synchronization/obj
INCLUDES = -I$(HDB_APP_INCLUDE) -I$(TK_INCLUDES) 
LIBS = $(HDB_LIBS) -ldl -lm 
CFLAGS = -ansi -Wall -g -DANSIPROTO $(INCLUDES)

TARGET = $(HDB_APP_BIN)/SYNC

OBJS = $(OBJDIR)/syncModelRuns.o

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET) $(LIBS)

clean:
	rm -f $(OBJS)	
	rm -f $(TARGET)

#        TARGET DEFINITIONS

$(OBJDIR)/syncModelRuns.o: syncModelRuns.c\
	$(HDB_APP_INCLUDE)/defines.h \
	$(HDB_APP_INCLUDE)/dbutils.h 
	$(CC) $(CFLAGS) -c syncModelRuns.c -o $@
