import random


def get_neighbors(row: int, col: int, grid_size: int) -> list[tuple[int, int]]:
    neigh_offsets = [
        (-1, -1),
        (-1, 0),
        (-1, 1),
        (0, -1),
        (0, 1),
        (1, -1),
        (1, 0),
        (1, 1),
    ]
    return [
        (row + row_offset, col + col_offset)
        for row_offset, col_offset in neigh_offsets
        if -1 < row + row_offset < grid_size and -1 < col + col_offset < grid_size
    ]


def kill_predicate(neighbors: list[tuple[int, int]]) -> int:
    alive_neigh = len([True for row, col in neighbors if grid[row][col] > 0])
    return 0 if alive_neigh < 2 or alive_neigh > 3 else 1


def revive_predicate(neighbors: list[tuple[int, int]]) -> int:
    alive_neigh = len([True for row, col in neighbors if grid[row][col] > 0])
    return 1 if alive_neigh == 3 else 0


def conway(grid: list[list[int]]) -> list[list[int]]:
    new_grid = [
        [
            (
                revive_predicate(get_neighbors(row, col, len(grid)))
                if grid[row][col] == 0
                else kill_predicate(get_neighbors(row, col, len(grid)))
            )
            for col in range(GRID_SIZE)
        ]
        for row in range(GRID_SIZE)
    ]
    return new_grid


if __name__ == "__main__":
    GRID_SIZE = 10
    grid: list[list[int]] = [
        [random.randint(0, 1) for _ in range(GRID_SIZE)] for _ in range(GRID_SIZE)
    ]

    for _ in range(5):
        for row in grid:
            print(row)
        grid = conway(grid)
        print()

    for row in grid:
        print(row)
