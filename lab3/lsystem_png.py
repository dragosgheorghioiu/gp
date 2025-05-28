import matplotlib.pyplot as plt
import math
import os

def apply_rules(plant):
    axiom = plant["axiom"]
    for _ in range(plant["iterations"]):
        axiom = "".join([plant["rules"].get(char, char) for char in axiom])
    return axiom

def draw_l_system(instructions, angle_deg, length):
    x, y = 0, 0
    angle = 90  # start pointing "up"
    stack = []
    lines = []

    for command in instructions:
        if command == 'F':
            rad = math.radians(angle)
            new_x = x + length * math.cos(rad)
            new_y = y + length * math.sin(rad)
            lines.append(((x, y), (new_x, new_y)))
            x, y = new_x, new_y
        elif command == '+':
            angle += angle_deg
        elif command == '-':
            angle -= angle_deg
        elif command == '[':
            stack.append((x, y, angle))
        elif command == ']':
            x, y, angle = stack.pop()
    return lines

def render_and_save(plant, filename, length):
    instructions = apply_rules(plant)
    lines = draw_l_system(instructions, plant["angle"], length)

    fig, ax = plt.subplots()
    fig.patch.set_alpha(0.0)  # Transparent figure background
    ax.set_facecolor('none')  # Transparent axes background

    for (start, end) in lines:
        ax.plot([start[0], end[0]], [start[1], end[1]], color='#8B4513', linewidth=0.5)

    ax.set_aspect('equal')
    ax.axis('off')
    plt.tight_layout()
    plt.savefig(filename + ".png", dpi=300, bbox_inches='tight', pad_inches=0, transparent=True)
    plt.close()

# Define L-system plants
plant_f = {
    "axiom": "X",
    "rules": {
        "X": "F-[[X]+X]+F[+FX]-X",
        "F": "FF"
    },
    "angle": 22.5,
    "iterations": 5,
}

plant_c = {
    "axiom": "F",
    "rules": {
        "F": "FF-[-F+F+F]+[+F-F-F]"
    },
    "angle": 22.5,
    "iterations": 4,
}

plant_d = {
    "axiom": "X",
    "rules": {
        "X": "F[+X]F[-X]+X",
        "F": "FF"
    },
    "angle": 20,
    "iterations": 7,
}

plant_e = {
    "axiom": "X",
    "rules": {
        "X": "F[+X][-X]FX",
        "F": "FF"
    },
    "angle": 25.7,
    "iterations": 7,
}

# Render to PNG
render_and_save(plant_f, "plant_f", length=2)
render_and_save(plant_c, "plant_c", length=3)
render_and_save(plant_d, "plant_d", length=3)
render_and_save(plant_e, "plant_e", length=3)

