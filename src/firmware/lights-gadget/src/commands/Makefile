LIB_FILENAME=../commands.a

OBJ_FILES=\
	initialise.o \
	ir-transceiver.a \
	ir-transceiver-event-handlers.o \
	poll.o \
	udata.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)
	$(MAKE) -C ir-transceiver clean

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
