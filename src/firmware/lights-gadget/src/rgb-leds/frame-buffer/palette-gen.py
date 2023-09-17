from math import pow

def palette(name):
	return f"""
{name}:
	andlw b'00011111'
	brw
"""

def add_palette_entry(hue):
	global red_palette
	red_palette += retlw(hue[0])

	global green_palette
	green_palette += retlw(hue[1])

	global blue_palette
	blue_palette += retlw(hue[2])

def retlw(component):
	global max_pwm
	component = max(0, min(max_pwm, round(component)))
	backwards = f"{component:08b}"[::-1]
	return f"\tretlw b'{backwards}'\n"

natural_white = [0xff, 0xf7, 0x9c]
yellow = [0xff, 0xff, 0x00]
orange = [0xff, 0x40, 0x00]
blue = [0x00, 0x00, 0xff]
light_blue = [0x00, 0x80, 0xff]
green = [0x00, 0xff, 0x00]
neon_pink = [0xff, 0x00, 0x7f]

hues_with_brightness = [natural_white, yellow, orange, blue, light_blue, green, neon_pink]
hues_without_brightness = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]

red_palette = palette("_frameBufferDefaultRedPalette")
green_palette = palette("_frameBufferDefaultGreenPalette")
blue_palette = palette("_frameBufferDefaultBluePalette")

gamma = 2.1
max_pwm = 255
num_brightness_levels = 4
max_gamma = pow(num_brightness_levels, gamma)
gamma_lookup = [(pow(i, gamma) / max_gamma) for i in range(1, num_brightness_levels + 1)]

for hue in hues_without_brightness:
	add_palette_entry(hue)

for hue in hues_with_brightness:
	for g in gamma_lookup:
		add_palette_entry([x * g for x in hue])

print(f"{red_palette}\n{green_palette}\n{blue_palette}\n")
