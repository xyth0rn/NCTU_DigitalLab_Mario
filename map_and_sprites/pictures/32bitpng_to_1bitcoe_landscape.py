# converts 32-bit PNG background to 1-bit COE landscape
# 0 = can walk through
# 1 = cannot walk through (wall/block/etc)
import os, sys
from PIL import Image

in_filename = input("Input file name: ")
img = Image.open(in_filename)

width, height = img.size
print("width = " + str(width) )
print("height = " + str(height) )

out_filename = in_filename[0: -4] + "_landscape.coe"
print("out_filename = " + str(out_filename) )

out = open(out_filename, 'w')
out.write("memory_initialization_radix = 2;\nmemory_initialization_vector =\n")


# RGBA (A = opacity)
# if A == 0, is transparent
# each color is 0~255 -> 8 bits
# convert to 1-bit (0 or 1)

for y in range(0, height):
	for x in range(0, width):
		r, g, b, a = img.getpixel( (x, y) ) 	# are integers now
		# print( r, g, b, a )
		# print( bin(r), bin(g), bin(b), bin(a) )

		if( a == 0 ):
			# if transparent, set to 0  ->  can walk through
			bit = "0"
		else:
			# if not transparent, set to 1  ->  cannot walk through
			bit = "1"
		
		out.write(bit)

		if( x == width-1 ) and ( y == height-1):
			out.write(';')	# end of file
		else:
			out.write(",\n")


