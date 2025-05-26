extends CharacterBody2D

@export var GRAVITY := 1000

func _process(delta: float) -> void:
	#label.rotation = -rotation
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	move_and_slide()
