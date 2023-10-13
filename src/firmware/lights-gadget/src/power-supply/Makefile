LIB_FILENAME=../power-supply.a

OBJ_FILES=\
	adc-as-voltage-monitor.o \
	disable.o \
	enable.o \
	fvr-as-adc-vref.o \
	initialise.o \
	is-enabled.o \
	nco1-as-adc-conversion-trigger.o \
	poll.o \
	udata.o

all: $(LIB_FILENAME)

clean:
	$(RM) -f $(BUILD_ARTEFACT_PATTERN)

$(LIB_FILENAME): $(OBJ_FILES)
	$(GPLIB_MERGE) $(LIB_FILENAME) $(OBJ_FILES)

include $(MAKEFILE_RULES)
