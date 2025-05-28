import turtle
from PIL import Image
import os

def apply_rules(plant):
    axiom = plant["axiom"]
    for _ in range(plant["iterations"]):
        axiom = "".join([plant["rules"].get(char, char) for char in axiom])
    return axiom

def draw_l_system(t, instructions, angle, length):
    stack = []
    for command in instructions:
        if command == 'F':
            t.forward(length)
        elif command == '+':
            t.left(angle)
        elif command == '-':
            t.right(angle)
        elif command == '[':
            stack.append((t.position(), t.heading()))
        elif command == ']':
            position, heading = stack.pop()
            t.penup()
            t.goto(position)
            t.setheading(heading)
            t.pendown()

def render_and_save(plant, filename, length):
    final_string = apply_rules(plant)

    screen = turtle.Screen()
    screen.setup(width=800, height=800)
    t = turtle.Turtle()
    t.speed(0)
    t.hideturtle()

    t.left(90)
    t.penup()
    t.goto(0, -screen.window_height() // 2 + 20)
    t.pendown()

    draw_l_system(t, final_string, plant["angle"], length)

    canvas = turtle.getcanvas()
    canvas.postscript(file=filename + ".eps")

    # Convert EPS to PNG
    img = Image.open(filename + ".eps")
    img.save(filename + ".png")
    os.remove(filename + ".eps")  # Clean up EPS file

    screen.bye()

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

render_and_save(plant_f, "plant_f", length=5)
render_and_save(plant_c, "plant_c", length=5)
