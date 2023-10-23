number_of_pixels = 65
centre_pixel_indices = [(number_of_pixels - 1) >> 1, number_of_pixels >> 1]
pixels = [0] * number_of_pixels

frame_period = 1 / 50
step_delay = 1
step_size_pixels = 1
number_of_shades = 4

if step_size_pixels > centre_pixel_indices[0]:
	step_size_pixels = centre_pixel_indices[0]

def do_swipe(shade_increment, pixel_done_index, pixel_done_value):
	global number_of_pixels
	global centre_pixel_indices
	global pixels
	global frame_period
	global step_delay
	global step_size_pixels
	global number_of_shades

	time = 0
	frame_index = 0
	delay_index = 0

	if shade_increment > 0:
		left_index = centre_pixel_indices[0]
		right_index = centre_pixel_indices[1]
	elif shade_increment < 0:
		left_index = step_size_pixels - 1 #################### TODO: THESE TWO VALUES CAN BE COMPUTED VIA MODULO, WHICH CAN BE DONE AT ASSEMBLY-TIME (NO NEED FOR DIV ROUTINES)
		right_index = number_of_pixels - step_size_pixels

	while frame_index < 100:
		if delay_index == 0:
			print(f"t={time:2.4f}    {''.join([str(ch) for ch in pixels])}")
			if pixels[pixel_done_index] == pixel_done_value:
				break

			if shade_increment > 0:
				for i in range(0, number_of_pixels):
					current_pixel = pixels[i]
					if i >= left_index and i <= right_index:
						if (i < left_index + step_size_pixels) or (i > right_index - step_size_pixels):
							pixels[i] = 1
						elif current_pixel != number_of_shades:
							pixels[i] = current_pixel + 1
					else:
						pixels[i] = current_pixel

				left_index -= step_size_pixels
				right_index += step_size_pixels

			elif shade_increment < 0:
				for i in range(0, number_of_pixels):
					current_pixel = pixels[i]
					if i <= left_index or i >= right_index:
						if current_pixel != 0:
							pixels[i] = current_pixel - 1
					else:
						pixels[i] = number_of_shades

				left_index += step_size_pixels
				right_index -= step_size_pixels

		delay_index += 1
		if delay_index > step_delay:
			delay_index = 0

		frame_index += 1
		time += frame_period

	print(f"\nTotal elapsed frames for the animation was {frame_index + 1}, or {time:.4f} seconds\n")


print(f"Number of pixels: {number_of_pixels} (centred at indices {centre_pixel_indices})")

print("Swipe Out:\n==========")
do_swipe(shade_increment=1, pixel_done_index=0, pixel_done_value=number_of_shades)

print("Swipe In:\n==========")
do_swipe(shade_increment=-1, pixel_done_index=centre_pixel_indices[0], pixel_done_value=0)
