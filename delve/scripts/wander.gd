extends CharacterBody2D

# -- Constants --
@export var SPEED := 1200
@export var JUMP_FORCE := -1000
@export var GRAVITY := 1000
@export var ACCELERATION := 1000
@export var FRICTION := 400

# -- Nodes --=
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var dunes: Node2D = %Dunes

var is_braking: bool = false
var is_braking_end: bool = true
var is_moving: bool = false

# -- Functions --
func _ready():
	animation_player.connect("animation_finished", _on_animation_finished)
	
func _physics_process(delta: float) -> void:
	var input_direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var target_speed := input_direction * SPEED

	# Accelerate or decelerate toward the target speed
	if input_direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, ACCELERATION * delta)
	else:
		# Apply friction when there's no input
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	var ground_y = dunes.get_ground_y_at(global_position.x)  # You need to create this function
	var vertical_distance = abs(global_position.y - ground_y)
	var slope_angle = get_slope_angle_at(global_position.x)
	
	if vertical_distance < 100:  # threshold distance, adjust as needed
		rotation = lerp_angle(rotation, slope_angle, 0.2)  # smooth blend
	else:
		rotation = lerp_angle(rotation, 0, 0.2)  # rotate back to horizontal
	
	# Flip sprite based on movement direction
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false

	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# Jump
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_FORCE

	is_braking = (input_direction == 0 and abs(velocity.x) > 0) or (input_direction != 0 and sign(input_direction) != sign(velocity.x) and abs(velocity.x) > 0)
	is_moving = abs(velocity.x) > 0.1
	
	
	move_and_slide()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "brake":
		animation_player.play("brake_end")
	elif anim_name == "brake_end":
		is_braking_end = true

func get_slope_angle_at(x: float) -> float:
	if x > dunes.dune_points.size() - 2:
		return 0
	var idx = clamp(int(x), 1, dunes.dune_points.size() - 2)
	var p1 = dunes.dune_points[idx - 1]
	var p2 = dunes.dune_points[idx + 1]
	
	var delta = p2 - p1
	
	return atan2(delta.y, delta.x)  # This gives you the angle in radians
