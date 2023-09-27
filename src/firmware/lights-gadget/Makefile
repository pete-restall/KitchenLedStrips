export BASE_DIR=$(CURDIR)
export FIRMWARE_DIR=$(BASE_DIR)/src
export UTILITIES_DIR=$(BASE_DIR)/utilities
export LKR_FILENAME=$(FIRMWARE_DIR)/kitchen-led-strips.lkr
export MAKEFILE_RULES=$(BASE_DIR)/Makefile.rules
export MAKE=make
export AS=gpasm
export ASARGS=-c -p p16f15355 -I $(FIRMWARE_DIR)
export AR=gplib
export ARARGS=-c
export LD=gplink
export LDARGS=-O 2 -s $(LKR_FILENAME) -m -c
export BUILD_ARTEFACT_PATTERN=*.hex *.cod *.cof *.map *.lst *.o *.a *.log
export GPLIB_MERGE=$(UTILITIES_DIR)/gplib-merge.sh
export MPLABX_DIR=/opt/microchip/mplabx/v4.10
export PICKIT3_IPE=$(MPLABX_DIR)/mplab_ipe/ipecmd.sh -TPPK3

all:
	$(MAKE) -C $(FIRMWARE_DIR) all

install:
	$(MAKE) -C $(FIRMWARE_DIR) install

clean:
	$(MAKE) -C $(FIRMWARE_DIR) clean
