export DATE_YYYYMMDD=`date +"%Y%m%d"`
export FIRMWARE_VERSION=v0.1.0 ($(DATE_YYYYMMDD))

HEX_FILENAME=kitchen-led-strips.hex

OBJ_FILES=\
	bits.a \
	boot.o \
	config.pp.o \
	config-words.o \
	initialise.o \
	ir-transceiver.a \
	isr.o \
	led-patterns.a \
	main.o \
	pins.o \
	power-management.o \
	rgb-leds.a \
	working-registers.o

all: $(HEX_FILENAME)

install: all
	$(PICKIT3_IPE) -P16F15356 -L -OL -M -Y -F$(HEX_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)
	$(MAKE) -C bits clean
	$(MAKE) -C ir-transceiver clean
	$(MAKE) -C led-patterns clean
	$(MAKE) -C rgb-leds clean

$(HEX_FILENAME): $(OBJ_FILES)
	$(LD) $(LDARGS) -o $(HEX_FILENAME) $(OBJ_FILES)

config.pp.o: config.inc config.pp.asm

include $(MAKEFILE_RULES)
