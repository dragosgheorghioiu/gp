extends CharacterBody2D

@export var GRAVITY := 1000
@export var skins: Array[Texture] = []
@onready var sprite = $Sprite2D

var names = ["Aric", "Thalindra", "Borin", "Elyndra", "Drake", "Alara", "Faelan", "Morwen", "Galadriel", "Dorian", "Qyburn"]
var classes = ["cleric", "mage", "duelist"]
var health_range = [50, 150]
var damage_range = [50, 150]
var character_traits = ["Intelligent", "Cunning", "Absent-minded", "Insightful", "Superstitious", "Charismatic", "Blunt", "Charming", "Awkward", "Manipulative"]

var character = null

func _ready():
	character = generate_character()
	sprite.texture = skins[classes.find(character.class)]

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	move_and_slide()

func generate_character() -> Dictionary:
	var character = {
		"name": names[randi() % names.size()],
		"class": classes[randi() % classes.size()],
		"health": randi() % (health_range[1] - health_range[0] + 1) + health_range[0],
		"damage": randi() % (damage_range[1] - damage_range[0] + 1) + damage_range[0],
		"character_trait": character_traits[randi() % character_traits.size()]
	}
	return character
