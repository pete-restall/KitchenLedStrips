#=============================================================================
# Copyright 2018 Sam Hanes
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake-Microchip,
#  substitute the full License text for the above reference.)

# this module is called by `Platform/MicrochipMCU-C`
# to provide information specific to the XC8 compiler

include(MicrochipPathSearch)
MICROCHIP_PATH_SEARCH(MICROCHIP_XC8_PATH xc8
    CACHE "the path to a Microchip XC8 installation"
)

option(MICROCHIP_XC8_FORCE_NON_CC "force the use of 'xc8' over 'xc8-cc'" OFF)
mark_as_advanced(MICROCHIP_XC8_FORCE_NON_CC)

if(NOT MICROCHIP_XC8_PATH)
    message(FATAL_ERROR
        "No Microchip XC8 compiler was found. Please provide the path"
        " to an XC8 installation on the command line, for example:\n"
        "    cmake -DMICROCHIP_XC8_PATH=/opt/microchip/xc8/v2.00 .."
    )
endif()

set(CMAKE_FIND_ROOT_PATH "${MICROCHIP_XC8_PATH}")

if(NOT MICROCHIP_XC8_FORCE_NON_CC)
    # skip compiler search and just use XC8
    find_program(CMAKE_C_COMPILER "xc8-cc"
        PATHS "${MICROCHIP_XC8_PATH}"
        PATH_SUFFIXES "bin"
    )
endif()

if(NOT CMAKE_C_COMPILER)
    find_program(CMAKE_C_COMPILER "xc8"
        PATHS "${MICROCHIP_XC8_PATH}"
        PATH_SUFFIXES "bin"
    )
    if(NOT CMAKE_C_COMPILER)
        message(FATAL_ERROR
            "The XC8 compiler executable was not found, but what looks"
            " like an XC8 installation was found at:\n"
            "    ${MICROCHIP_XC8_PATH}\n"
            "Please provide the path to a working XC8 installation on the"
            " command line, for example:\n"
            "    cmake -DMICROCHIP_XC8_PATH=/opt/microchip/xc8/v2.00 .."
        )
    else()
        if(NOT MICROCHIP_XC8_FORCE_NON_CC)
            message(WARNING
                "xc8-cc compiler not found, but found xc8.exe, please"
                " consider upgrading to xc8 2.0 or higher as it uses"
                " much more standard clang frontend"
            )
        endif()

        # skip compiler ID since XC8 isn't supported by CMake's test file
        set(CMAKE_C_COMPILER_ID_RUN 1)
        set(CMAKE_C_COMPILER_ID "XC8")
        set(XC8_GET_VERSION_OPTION "--ver")

        if (MICROCHIP_XC8_FORCE_NON_CC)
            # If we're forcing xc8, assume we can find xc8-ar alongside it
            find_program(CMAKE_AR "xc8-ar"
                PATHS "${MICROCHIP_XC8_PATH}"
                PATH_SUFFIXES "bin"
            )
            if(NOT CMAKE_AR)
                message(FATAL_ERROR
                    "You requested to use 'xc8' over 'xc8-cc', but 'xc8-ar' "
                    "was not found. Please check your xc8 installation in "
                    "${MICROCHIP_XC8_PATH}."
                )
            endif()
        endif()
    endif()
else()
    # skip compiler ID since XC8 isn't supported by CMake's test file
    set(CMAKE_C_COMPILER_ID_RUN 1)
    set(CMAKE_C_COMPILER_ID "XC8-CC")
    set(XC8_GET_VERSION_OPTION "--version")

    # Since xc8-cc was found that means that xc8-ar is alongside
    find_program(CMAKE_AR "xc8-ar"
        PATHS "${MICROCHIP_XC8_PATH}"
        PATH_SUFFIXES "bin"
    )
endif()

# call the compiler to check its version
function(_xc8_get_version)
    execute_process(
        COMMAND "${CMAKE_C_COMPILER}" ${XC8_GET_VERSION_OPTION}
        OUTPUT_VARIABLE output
        ERROR_VARIABLE  output
        RESULT_VARIABLE result
    )

    if(result)
        message(FATAL_ERROR
            "Calling '${CMAKE_C_COMPILER} ${XC8_GET_VERSION_OPTION}' failed."
        )
    endif()

    if(output MATCHES "XC8 C Compiler V([0-9]+\.[0-9]+)")
        set(CMAKE_C_COMPILER_VERSION ${CMAKE_MATCH_1} PARENT_SCOPE)
    else()
        message(FATAL_ERROR
            "Failed to parse output of '${CMAKE_C_COMPILER} ${XC8_GET_VERSION_OPTION}'."
        )
    endif()
endfunction()
_xc8_get_version()
