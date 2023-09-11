LIB_FILENAME=../ir-transceiver.a

OBJ_FILES=\
	ccp1-carrier-timebase.o \
	clc2-modulated-output.o \
	initialise.o \
	poll.o \
	tmr1-carrier-timebase.o \
	uart2.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
