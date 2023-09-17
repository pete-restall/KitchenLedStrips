from math import pow

gamma = 2.2
max_pwm = 255
num_brightness_levels = 32

max_gamma = pow(num_brightness_levels - 1, gamma)
for i in range(0, num_brightness_levels):
	corrected = min(max_pwm, round(max_pwm * pow(i, gamma) / max_gamma))
	backwards = f"{corrected:08b}"[::-1]
	print(f"\tretlw b'{backwards}'")
