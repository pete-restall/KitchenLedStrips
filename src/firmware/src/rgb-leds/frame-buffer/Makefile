LIB_FILENAME=../frame-buffer.a

OBJ_FILES=\
	clear.o \
	initialise.o \
	try-blit.o \
	udata-buffers.o \
	udata-state.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
