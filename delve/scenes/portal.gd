extends Node2D

func _ready():
	$AnimatedSprite2D.play("default")
	$Area2D.connect("area_entered", _go_to_dungeon)

func _go_to_dungeon():
	print('sal')
