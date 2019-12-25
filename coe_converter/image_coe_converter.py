import math
from sys import argv
from PIL import Image
from coe_writer import write_coe


def main():
    im = Image.open(argv[1])
    write_coe(argv[2], 16, rgb12_pixel_generator(im))


def rgb12_pixel_generator(im):
    for x in range(0, im.width):
        for y in range(0, im.height):
            pixel = im.getpixel((x, y))
            rgb12_pixel = 0
            for i in range(0, 3):
                rgb12_pixel = rgb12_pixel | math.floor(
                    pixel[i] / 255 * 15) << 4 * i
            yield rgb12_pixel


if __name__ == "__main__":
    main()
