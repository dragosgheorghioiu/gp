import pygame
import random

width, height = 1800, 1200

def render_grid(color_grid):
    for x in range(width // length):
        for y in range(height // length):
            pygame.draw.rect(screen, color_grid[x][y], (x * length, y * length, length, length))

def init_color_grid():
    color_grid = [[(0, 0, 0)] * (height // length) for _ in range(width // length)]
    for x in range(width // length):
        for y in range(height // length):
            color_grid[x][y] = (random.randrange(255), random.randrange(255), random.randrange(255))

    return color_grid

def init_terrain_grid():
    terrain = [[""] * 20 for _ in range(20)]
    for x in range(20):
        for y in range(20):
            terrain_var = random.randrange(9)
            # 30% chances of getting ~
            if terrain_var <= 2:
                terrain[x][y] = "~"
                continue
            # 50% chances of getting .
            if terrain_var <= 7:
                terrain[x][y] = "."
                continue
            # 20% chances of getting #
            if terrain_var <= 9:
                terrain[x][y] = "#"
                continue
    return terrain

def print_terrain_grid(terrain):
    for x in range(20):
        print("".join(terrain[x]))


if __name__ == "__main__":
    print_terrain_grid(init_terrain_grid())

    pygame.init()

    screen = pygame.display.set_mode((width, height))
    pygame.display.set_caption('Color Grid')
    length = 50 

    color_grid = init_color_grid()

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        render_grid(color_grid)

        pygame.display.flip()
