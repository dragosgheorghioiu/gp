extends CharacterBody2D

@export var GRAVITY := 1000
@export var skins: Array[Texture] = []
@onready var sprite = $Sprite2D

var types = [
	"battle_axe",
	"dagger",
	"spear"
]

var damage_range = Vector2(100, 300)
var durability_range = Vector2(100, 300)

var rarity_chances = [
	{"level": "common", "weight": 40},
	{"level": "uncommon", "weight": 30},
	{"level": "rare", "weight": 15},
	{"level": "epic", "weight": 10},
	{"level": "legendary", "weight": 5}
]

var effects = [
	"poison",
	"lifesteal",
	"fire damage",
	"ice slow"
]

var weapon = null

func get_random_rarity() -> String:
	var total_weight = 0
	for r in rarity_chances:
		total_weight += r.weight

	var random = randf() * total_weight
	for r in rarity_chances:
		if random < r.weight:
			return r.level
		random -= r.weight

	return "common" # fallback


func weapon_generator() -> Dictionary:
	var weapon_class = types[randi() % types.size()]
	var damage = randi() % int(damage_range.y - damage_range.x + 1) + int(damage_range.x)
	var durability = randi() % int(durability_range.y - durability_range.x + 1) + int(durability_range.x)
	var rarity_level = get_random_rarity()

	var effects_count = 0
	match rarity_level:
		"common":
			effects_count = 0
		"uncommon":
			effects_count = 1
		"rare":
			effects_count = 2
		"epic":
			effects_count = 3
		"legendary":
			effects_count = 4

	var selected_effects = []
	while selected_effects.size() < effects_count:
		var random_effect = effects[randi() % effects.size()]
		if random_effect not in selected_effects:
			selected_effects.append(random_effect)

	return {
		"class": weapon_class,
		"damage": damage,
		"durability": durability,
		"rarity": rarity_level,
		"effects": selected_effects
	}


func _ready():
	weapon = weapon_generator()
	sprite.texture = skins[types.find(weapon.class)]

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()
