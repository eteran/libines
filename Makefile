# avoids problems with non-gnu makes
SHELL = /bin/sh

# suffix Definitions
.SUFFIXES:            			# Delete the default suffixes
.SUFFIXES: .c .o .h  	# Define our suffix list

.c.o:
	@echo compiling $< ...
	@$(CC) $(CFLAGS) $(DEFINES) -c $< -o $@ 1>/dev/null


CC		= cc
RM		= rm -f
ED		= ed
MV		= mv
NM		= nm
SORT		= sort
RANLIB		= ranlib
AR		= ar rc


# build specific variables
LIBRARY = libines.a

DEFINES =	-DNDEBUG
INCLUDES =	
CFLAGS =      	-ansi -pedantic -W -Wall -g3 -O2 $(INCLUDES)
LDFLAGS =		


# search path for dependencies
VPATH = .

# source files
H_FILES = 	ines_crc32.h  lib_ines.h  load_ines.h ines_types.h 
C_FILES =	ines_crc32.c  lib_ines.c  load_ines.c
O_FILES =  $(C_FILES:.c=.o)
SOURCEFILES =	$(H_FILES) $(C_FILES)
.PRECIOUS:	$(SOURCEFILES)
.PHONY : clean

# main targets
all:	$(LIBRARY)

$(LIBRARY):	$(O_FILES)
	@echo "linking ..."
	@$(AR) $@ $(O_FILES) 1>/dev/null
	-@ ($(RANLIB) $@ || true) >/dev/null 2>&1

clean:
	$(RM) $(O_FILES) $(LIBRARY) core *~ 2> /dev/null

depend: $(C_FILES)
	@echo "Building Dependency Information..."
	@$(CC) $(DEFINES) -MM $? > makedep
	@echo '/^# DO NOT DELETE THIS LINE/+2,$$d' >eddep
	@echo '$$r makedep' >>eddep
	@echo 'w' >>eddep
	@$(ED) - Makefile < eddep
	@$(RM) eddep makedep 
	@echo '# DEPENDENCIES MUST END AT END OF FILE' >> Makefile
	@echo '# IF YOU PUT STUFF HERE IT WILL GO AWAY' >> Makefile
	@echo '# see make depend above' >> Makefile
	@echo "Done"
        
#-----------------------------------------------------------------
# DO NOT DELETE THIS LINE -- make depend uses it
#-----------------------------------------------------------------
ines_crc32.o: ines_crc32.c ines_crc32.h ines_types.h
lib_ines.o: lib_ines.c lib_ines.h ines_types.h
load_ines.o: load_ines.c load_ines.h lib_ines.h ines_types.h ines_crc32.h
# DEPENDENCIES MUST END AT END OF FILE
# IF YOU PUT STUFF HERE IT WILL GO AWAY
# see make depend above
