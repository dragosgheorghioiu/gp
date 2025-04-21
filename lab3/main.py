import turtle
# Initialize turtle
t = turtle.Turtle()
wn = turtle.Screen()
t.speed(0)
t.left(90)
t.penup()
t.goto(0, -wn.window_height() // 2 + 20)
t.pendown()


# Wait for user to close window
wn.mainloop()
