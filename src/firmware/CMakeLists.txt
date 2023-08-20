cmake_minimum_required(VERSION 3.26.3)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/thirdparty/cmake-microchip/toolchain.cmake)
set(CMAKE_C_COMPILER /opt/microchip/xc8/v2.32/bin/xc8-cc)

set(MICROCHIP_MCU PIC16F15356)
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=${MICROCHIP_MCU} -Wa,-a")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -gdwarf-3 -Wl,-AID=0x8006-0x8007 -Wl,-PID=ID --fill=0x3fff -mserial=0000@8005 -mserial=ae30@8006")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -Wl,-Map=\"${CMAKE_CURRENT_BINARY_DIR}/kitchen-led-strips.map\"")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -Wl,-Map=\"${CMAKE_CURRENT_BINARY_DIR}/kitchen-led-strips.map\"")

project(KitchenLedStrips VERSION 0.1.0 LANGUAGES C)

add_executable(kitchen-led-strips)
configure_file(src/config.h.in src/config.h)
target_link_options(
	kitchen-led-strips
	PRIVATE
		-xassembler-with-cpp
		${CMAKE_CURRENT_SOURCE_DIR}/src/bits.asm)

target_sources(
	kitchen-led-strips
	PUBLIC
		src/main.c
		src/circular-buffer.c
		src/config-words.c
		src/event.c
		src/initialise.c
		src/isr.c
		src/poll.c
		src/pwm-timer.c
		src/power-management.c
		src/rgb-leds.c
		src/sm16703p-modulator.c)
