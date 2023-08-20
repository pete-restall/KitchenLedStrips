export DATE_YYYYMMDD=`date +"%Y%m%d"`
export FIRMWARE_VERSION="v0.1.0 ($(DATE_YYYYMMDD))"

HEX_FILENAME=kitchen-led-strips.hex

OBJ_FILES=\
	boot.o \
	config-words.o \
	isr.o \
	main.o \
	rgb-leds.a

all: $(HEX_FILENAME)

install: all
	$(PICKIT3_IPE) -P16F15356 -L -OL -M -Y -F$(HEX_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)
	$(MAKE) -C rgb-leds clean

$(HEX_FILENAME): $(OBJ_FILES)
	$(LD) $(LDARGS) -o $(HEX_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
