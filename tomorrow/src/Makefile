# tomorrow makefile
# $Id: Makefile,v 1.2 2005/05/11 20:11:13 uchdba Exp $

include ../../Environ

OBJDIR = $(HDB_ENV)/tomorrow/obj
INCLUDES = -I$(HDB_APP_INCLUDE)
LIBS = $(HDB_LIBS) -ldl -lm 
CFLAGS = -ansi -Wall -g -DANSIPROTO $(INCLUDES)

TARGET = $(HDB_APP_BIN)/tomorrow

OBJS = $(OBJDIR)/tomorrow.o

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET) $(LIBS)

clean:
	rm -f $(OBJS)	
	rm -f $(TARGET)

#        TARGET DEFINITIONS

$(OBJDIR)/tomorrow.o: tomorrow.c\
	$(HDB_APP_INCLUDE)/defines.h \
	$(HDB_APP_INCLUDE)/dbutils.h 
	$(CC) $(CFLAGS) -c tomorrow.c -o $@
