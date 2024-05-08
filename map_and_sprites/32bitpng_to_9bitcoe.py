import os, sys
from PIL import Image

in_filename = input("Input file name: ")
img = Image.open(in_filename)

width, height = img.size
print("width = " + str(width) )
print("height = " + str(height) )

out_filename = in_filename[0: -4] + "_9bit.coe"
print("out_filename = " + str(out_filename) )

out = open(out_filename, 'w')
out.write("memory_initialization_radix = 2;\nmemory_initialization_vector =\n")


# RGBA (A = opacity)
# if A == 0, is transparent
# each color is 0~255 -> 8 bits
# convert '0b01234567' to '012' -> take [2:4]

for y in range(0, height):
	for x in range(0, width):
		r, g, b, a = img.getpixel( (x, y) ) 	# are integers now
		# print( r, g, b, a )
		# print( bin(r), bin(g), bin(b), bin(a) )

		if( a == 0 ):
			# if transparent, set color to black
			r3 = "000"
			g3 = "000"
			b3 = "000"
		else:
			# extent all binary strings to 8-bits and then cut to 3-bits
			r3 = ( bin(r)[2:].ljust(8, '0') )[:3]
			g3 = ( bin(g)[2:].ljust(8, '0') )[:3]
			b3 = ( bin(b)[2:].ljust(8, '0') )[:3]
		
		# print( r3, g3, b3)
		
		out.write(r3 + g3 + b3)

		if( x == width-1 ) and ( y == height-1):
			out.write(';')	# end of file
		else:
			out.write(",\n")


