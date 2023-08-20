	radix decimal

	extern main

.boot code 0x0000

boot:
	pagesel main
	goto main

	end
