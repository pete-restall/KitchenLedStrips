LIB_FILENAME=../led-patterns.a

OBJ_FILES=\
	bicolour-interlaced.o \
	initialise.o \
	poll.o \
	udata.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
