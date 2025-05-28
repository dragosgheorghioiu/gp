import random
import matplotlib.pyplot as plt

n = 10
GRID_SIZE = 2 ** n + 1
grid = [[0] * GRID_SIZE for _ in range(GRID_SIZE)]

def diamond_square():
    step_size = GRID_SIZE - 1
    random_range = n * 4
    r = random.randint(-random_range, random_range)

    grid[0][0] = random.randint(0, 100)
    grid[0][step_size] = random.randint(0, 100)
    grid[step_size][0] = random.randint(0, 100)
    grid[step_size][step_size] = random.randint(0, 100)
    
    while step_size > 1:
        half_step = step_size // 2

        for x in range(0, GRID_SIZE - 1, step_size):
            for y in range(0, GRID_SIZE - 1, step_size):
                square_step(x, y, step_size, r)

        for x in range(0, GRID_SIZE, half_step):
            for y in range((x + half_step) % step_size, GRID_SIZE, step_size):
                diamond_step(x, y, half_step, r)

        step_size = half_step
        random_range = max(1, random_range // 2)
        r = random.randint(-random_range, random_range)
    

def square_step(x: int, y: int, size: int, r: int):
    top_left = grid[x][y]
    top_right = grid[x + size][y]
    bottom_left = grid[x][y + size]
    bottom_right = grid[x + size][y + size]

    grid[x + size // 2][y + size // 2] = (top_left + top_right + bottom_left + bottom_right) // 4 + r

def diamond_step(x: int, y: int, size: int, r: int):
    top = grid[x + size][y] if x + size < GRID_SIZE else None
    bottom = grid[x - size][y] if x - size >= 0 else None 
    right = grid[x][y + size] if y + size < GRID_SIZE else None
    left = grid[x][y - size] if y - size >= 0 else None
    valid_corners = [val for val in (top, bottom, right, left) if val is not None]

    grid[x][y] = sum(valid_corners) // len(valid_corners) + r

if __name__ == "__main__":
    diamond_square()

    for row in grid:
        print(["{:>2}".format(val) for val in row])

    plt.imshow(grid, cmap='terrain')
    plt.colorbar(label='Height')
    plt.title('Diamond-Square Height Map')
    plt.axis('off')
    plt.show()
