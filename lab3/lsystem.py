import turtle

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

length = 5

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

final_string = apply_rules(plant_f)

t = turtle.Turtle()
wn = turtle.Screen()
t.speed(0)
t.left(90)
t.penup()
t.goto(0, -wn.window_height() // 2 + 20)
t.pendown()

draw_l_system(t, final_string, plant_f["angle"], length)

wn.mainloop()

