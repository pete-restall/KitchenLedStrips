LIB_FILENAME=../sm16703p-modulator.a

OBJ_FILES=\
	clc1-modulated-output.o \
	clc4-byte-sync-reset.o \
	initialise.o \
	is-busy.o \
	pwm3-long-duty-cycle-1.o \
	pwm4-short-duty-cycle-0.o \
	tmr2-pwm-timebase.o \
	try-start-frame.o \
	uart1.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
