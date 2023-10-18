## The Test Fixture
The test fixture is 18x LEDs (6x pixels) split into two partitions of 3x
pixels, ie. there are two strips of LEDs each with their own data wire but
shared +12V$_{dc}$ and 0V rails.

The first strip has its data line (D0) just connected to the cable's wire #3.

The second strip has its data line (D1) connected to the cable's wire #2 and
to the strip's ground via a 470pF 0805 MLCC.  This arrangement lets us compare
the effects of terminating the transmission line wth a moderate capacitance.

The test fixture is connected to the board via 1m of shielded 1mm$^{2}$ CY4
instrumentation cable (PELB0900).  The shielding is connected to the board's
enclosure but stripped back 4cm from the fixture and left unconnected.

## The Board
The board is fully assembled with all internal wiring and external connectors
and is placed inside the extruded aluminium enclosure, ie. a complete unit.

Only one pixel (3x LEDs) of each partition (strip) is addressed by the
firmware for these measurements.

## The Power Supply
The unit is powered by +12V$_{dc}$ supplied by a Rigol DP831 over 50cm of
shielded 1mm$^{2}$ CY4 instrumentation cable (PELB0900).  The shield is
connected to mains earth via the DP831 internally, which in turn connects to
the DUT's enclosure.

## The Oscilloscope
The oscilloscope is a 4-channel 2GHz Siglent SDS6054A.

The oscilloscope CH3 is probing the pad of the LED strip (ie. far-end from
the DUT, after the cable) that corresponds to the first partition (D0).

CH4 is probing the pad of the LED strip (ie. far-end from the DUT, after the
cable) that corresponds to the second partition (D1).

Both probes for D0 and D1 are PCBite 200MHz SP200 10:1.

CH1 is probing the pad corresponding to the +12V$_{dc}$ rail of the first LED
strip of the test fixture, using a Siglent 500MHz SP3050A 10:1 probe.

## The Measurement Results
The results of the measurements can be seen in the PNG screenshots and the
actual samples for channels CH1, CH3 and CH4 have been saved as CSV and are
in the `measurements-as-csv.tar.gz` tarball.
