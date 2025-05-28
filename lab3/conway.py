import random
import matplotlib.pyplot as plt
import matplotlib.animation as animation

GRID_SIZE = 100
FPS = 30

# Initialize random grid
grid = [[random.randint(0, 1) for _ in range(GRID_SIZE)] for _ in range(GRID_SIZE)]

def get_neighbors(row: int, col: int, grid_size: int) -> list[tuple[int, int]]:
    neigh_offsets = [(-1, -1), (-1, 0), (-1, 1),
                     (0, -1),           (0, 1),
                     (1, -1), (1, 0), (1, 1)]
    return [
        (row + dr, col + dc)
        for dr, dc in neigh_offsets
        if 0 <= row + dr < grid_size and 0 <= col + dc < grid_size
    ]

def kill_predicate(neighbors: list[tuple[int, int]], grid: list[list[int]]) -> int:
    alive = sum(1 for r, c in neighbors if grid[r][c] > 0)
    return 1 if 2 <= alive <= 3 else 0

def revive_predicate(neighbors: list[tuple[int, int]], grid: list[list[int]]) -> int:
    alive = sum(1 for r, c in neighbors if grid[r][c] > 0)
    return 1 if alive == 3 else 0

def conway(grid: list[list[int]]) -> list[list[int]]:
    size = len(grid)
    return [
        [
            (revive_predicate(get_neighbors(r, c, size), grid)
             if grid[r][c] == 0
             else kill_predicate(get_neighbors(r, c, size), grid))
            for c in range(size)
        ]
        for r in range(size)
    ]

# Setup plot
fig, ax = plt.subplots()
mat = ax.matshow(grid, cmap='binary')
ax.set_title("Conway's Game of Life")

def update(frame):
    global grid
    grid = conway(grid)
    mat.set_data(grid)
    return [mat]

ani = animation.FuncAnimation(fig, update, frames=50, interval=1000 // FPS, blit=True)
plt.show()

