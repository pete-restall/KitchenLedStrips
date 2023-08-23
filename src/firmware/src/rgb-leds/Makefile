LIB_FILENAME=../rgb-leds.a

OBJ_FILES=\
	initialise.o \
	sm16703p-modulator.a \
	start-frame.o \
	try-put-next-pixel.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)
	$(MAKE) -C sm16703p-modulator clean

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
