number_of_pixels = 64
centre_pixel_indices = [(number_of_pixels - 1) >> 1, number_of_pixels >> 1]
pixels = [0] * number_of_pixels

frame_period = 1 / 50
step_delay = 1
step_size_pixels = 1
number_of_shades = 4

if step_size_pixels > centre_pixel_indices[0]:
	step_size_pixels = centre_pixel_indices[0]

time = 0
frame_index = 0
delay_index = 0
left_index = centre_pixel_indices[0] + step_size_pixels // 2 - (1 if centre_pixel_indices[0] == centre_pixel_indices[1] else 0)
right_index = centre_pixel_indices[1] - step_size_pixels // 2 + (1 if centre_pixel_indices[0] == centre_pixel_indices[1] else 0)

print(f"Number of pixels: {number_of_pixels} (centred at indices {centre_pixel_indices})")

print("Swipe Out:\n==========")
while frame_index < 100:
	if delay_index == 0:
		print(f"t={time:2.4f}    {''.join([str(ch) for ch in pixels])}")
		if pixels[0] == number_of_shades:
			break

		step_size_index = 0
		for i in range(0, step_size_pixels * number_of_shades):
			if (left_index - i < right_index) and (left_index - i >= 0):
				pixels[left_index - i] += 1

			if right_index + i <= number_of_pixels - 1:
				pixels[right_index + i] += 1
			else:
				break

			if (pixels[right_index + i] == 1) and (step_size_index == step_size_pixels - 1):
				break

			step_size_index += 1
			if step_size_index >= step_size_pixels:
				step_size_index = 0

		if pixels[right_index] == number_of_shades:
			left_index -= step_size_pixels
			right_index += step_size_pixels

	delay_index += 1
	if delay_index > step_delay:
		delay_index = 0

	frame_index += 1
	time += frame_period

print(f"\nTotal elapsed frames for the animation was {frame_index + 1}, or {time:.4f} seconds\n")

time = 0
frame_index = 0
delay_index = 0
left_index = step_size_pixels - 1
right_index = number_of_pixels - step_size_pixels
print("Swipe In:\n==========")
while frame_index < 100:
	if delay_index == 0:
		print(f"t={time:2.4f}    {''.join([str(ch) for ch in pixels])}")
		if pixels[centre_pixel_indices[0]] == 0:
			break

		step_size_index = 0
		for i in range(0, step_size_pixels * number_of_shades):
			if (left_index - i < right_index) and (left_index - i >= 0):
				pixels[left_index - i] -= 1

			if (right_index + i <= number_of_pixels - 1):
				pixels[right_index + i] -= 1
			else:
				break

			if (right_index + i + 1 < number_of_pixels) and (pixels[right_index + i + 1] == 0):
				break

			step_size_index += 1
			if step_size_index >= step_size_pixels:
				step_size_index = 0

		if pixels[right_index] == number_of_shades - 1:
			left_index += step_size_pixels
			right_index -= step_size_pixels

			if left_index > right_index:
				left_index = centre_pixel_indices[0]
				right_index = centre_pixel_indices[1]

	delay_index += 1
	if delay_index > step_delay:
		delay_index = 0

	frame_index += 1
	time += frame_period

print(f"\nTotal elapsed frames for the animation was {frame_index + 1}, or {time:.4f} seconds\n")
