LIB_FILENAME=../rgb-leds.a

OBJ_FILES=\
	enable-disable-blitting.o \
	frame-buffer.a \
	initialise.o \
	next-pixel.o \
	poll.o \
	public-udata.o \
	sm16703p-modulator.a \
	tmr0-frame-sync.o \
	try-put-next-pixel-into-tx.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)
	$(MAKE) -C frame-buffer clean
	$(MAKE) -C sm16703p-modulator clean

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
