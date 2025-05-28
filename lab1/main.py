import pygame
import random

width, height = 1280, 720
length = 20 

terrain_symbols = {
    "~": pygame.colordict.THECOLORS['blue'],
    ".": pygame.colordict.THECOLORS['green'],
    "#": pygame.colordict.THECOLORS['brown']
}

def render_terrain_to_surface(terrain):
    surface = pygame.Surface((20 * length, 20 * length))
    for x in range(20):
        for y in range(20):
            color = terrain_symbols[terrain[x][y]]
            pygame.draw.rect(surface, color, (y * length, x * length, length, length))
    return surface

def save_terrain_image():
    pygame.init()
    terrain = init_terrain_grid()
    print_terrain_grid(terrain)
    surface = render_terrain_to_surface(terrain)
    pygame.image.save(surface, "terrain.png")
    pygame.quit()

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
    save_terrain_image()

    pygame.init()

    screen = pygame.display.set_mode((width, height))
    pygame.display.set_caption('Color Grid')

    color_grid = init_color_grid()

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_a:
                    color_grid = init_color_grid()

        render_grid(color_grid)

        pygame.display.flip()
