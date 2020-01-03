import sys
import math
from PIL import Image


def main():
    im = Image.new('RGB', (640, 480))
    with open(sys.argv[1], 'r') as f:
        for y in range(0, 480):
            for x in range(0, 640):
                pixel = int(f.readline(), 2)
                im.putpixel(
                    (x, y), (tuple([math.floor((15 & pixel >> 4 * i)/15*255) for i in range(0, 3)])))

    im.show()


if __name__ == "__main__":
    main()
