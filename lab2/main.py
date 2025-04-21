import pygame
import random
from math import floor
from PIL import Image

width, height = 400, 400

permutation = [i for i in range(256)]
random.shuffle(permutation)
permutation += permutation

def generate_texture(width, height, frequency):
    pixels = [(0, 0, 0)] * height * width
    for y in range(height):
        for x in range(width):
            n = perlin(x * frequency, y * frequency)

            n += 1.0
            n /= 2.0
            c = round(255 * n)
            pixels[x * width + y] = (c, c, c)

    return pixels

def perlin(x, y):
    # get current cell coordinates
    X = floor(x) & 255
    Y = floor(y) & 255

    # get coordinates inside the current cell
    xf = x - floor(x)
    yf = y - floor(y)

    topRight = pygame.Vector2(xf - 1.0, yf - 1.0)
    topLeft = pygame.Vector2(xf, yf - 1.0)
    bottomRight = pygame.Vector2(xf - 1.0, yf)
    bottomLeft = pygame.Vector2(xf, yf)

    valueTopRight = permutation[permutation[X+1]+Y+1]
    valueTopLeft = permutation[permutation[X]+Y+1]
    valueBottomRight = permutation[permutation[X+1]+Y]
    valueBottomLeft = permutation[permutation[X]+Y]

    dotTopRight = topRight.dot(getConstantVector(valueTopRight))
    dotTopLeft = topLeft.dot(getConstantVector(valueTopLeft))
    dotBottomRight = bottomRight.dot(getConstantVector(valueBottomRight))
    dotBottomLeft = bottomLeft.dot(getConstantVector(valueBottomLeft))

    u = fade(xf)
    v = fade(yf)

    return lerp(v,
                lerp(u, dotBottomLeft, dotBottomRight),
                lerp(u, dotTopLeft, dotTopRight))

def getConstantVector(v):
    h = v % 4
    if h == 0:
        return pygame.Vector2(1.0, 1.0)
    elif h == 1:
        return pygame.Vector2(-1.0, 1.0)
    elif h == 2:
        return pygame.Vector2(-1.0, -1.0)
    else:
        return pygame.Vector2(1.0, -1.0)

def lerp(t, a1, a2):
    return a1 + t * (a2 - a1)

def fade(t):
    return ((6 * t - 15) * t + 10) * t * t * t

if __name__ == "__main__":
    texture = generate_texture(width, height, 0.01)
    img = Image.new('RGB', (width, height))
    img.putdata(texture)
    img.save('perlin.jpg')
