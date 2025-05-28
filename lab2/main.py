import pygame
import random
from math import floor, cos, sin
from PIL import Image
import sys

add_octave = True if len(sys.argv) >= 2 else False
width, height = 400, 400

permutation = [i for i in range(256)]
random.shuffle(permutation)
permutation += permutation

def generate_texture(width, height, frequency, time=0.0):
    pixels = [(0, 0, 0)] * height * width
    for y in range(height):
        for x in range(width):
            r = perlin(x * frequency, y * frequency, time)
            # g = perlin(x * frequency + 100, y * frequency + 100, time)
            # b = perlin(x * frequency + 200, y * frequency + 200, time)

            if add_octave:
                r += 0.5 * perlin(x * frequency * 2, y * frequency * 2, time)
                # g += 0.5 * perlin(x * frequency * 2 + 100, y * frequency * 2 + 100, time)
                # b += 0.5 * perlin(x * frequency * 2 + 200, y * frequency * 2 + 200, time)

            r = round(255 * ((r + 0.5) / 1))
            # g = round(255 * ((g + 0.5) / 1))
            # b = round(255 * ((b + 0.5) / 1))

            pixels[x + y * width] = (r, r, r)

    return pixels

def perlin(x, y, time=0.0, phase_shift=0.0):
    X = floor(x) & 255
    Y = floor(y) & 255
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

    dotTopRight = topRight.dot(getConstantVector(valueTopRight, time, phase_shift))
    dotTopLeft = topLeft.dot(getConstantVector(valueTopLeft, time, phase_shift))
    dotBottomRight = bottomRight.dot(getConstantVector(valueBottomRight, time, phase_shift))
    dotBottomLeft = bottomLeft.dot(getConstantVector(valueBottomLeft, time, phase_shift))

    u = fade(xf)
    v = fade(yf)

    return lerp(v,
                lerp(u, dotBottomLeft, dotBottomRight),
                lerp(u, dotTopLeft, dotTopRight))


def getConstantVector(v, time=0.0, phase_shift=0.0):
    angle = (v + (time + phase_shift) * 10) * 0.392699  # ~π/8
    return pygame.Vector2(cos(angle), sin(angle))

def lerp(t, a1, a2):
    return a1 + t * (a2 - a1)

def fade(t):
    return ((6 * t - 15) * t + 10) * t * t * t

if __name__ == "__main__":
    for frame in range(60):
        t = frame / 60.0
        texture = generate_texture(width, height, 0.01, time=t)
        img = Image.new('RGB', (width, height))
        img.putdata(texture)
        img.save(f'frame_{frame:03d}.png')
