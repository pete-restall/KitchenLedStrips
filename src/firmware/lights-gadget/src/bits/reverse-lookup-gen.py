for i in range(0, 128):
	backwards = f"{i:08b}"[::-1]
	print(f"\tretlw b'{backwards}'")
