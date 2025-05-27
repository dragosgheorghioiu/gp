extends Node2D

var noise : FastNoiseLite
var dune_points : PackedVector2Array = PackedVector2Array()
var flat_points : PackedVector2Array = PackedVector2Array()
var static_body : StaticBody2D
var collision_polygon : CollisionPolygon2D
var npcs = []
var weapons = []
var polygon_points := PackedVector2Array()

@export var width := 5000
@export var height := 2000
@export var wave_scale := 0.0015
@export var amplitude := 100.0
@export var offset := 100.0
@export var flat_width := 1000
@export var plant_scene_c : PackedScene
@export var plant_scene_f : PackedScene
@export var random_character : PackedScene
@export var random_weapon : PackedScene
@export var portal_scene : PackedScene
@export var plant_spawn_count := 50
@export var character_spawn_count := 10
@export var weapon_spawn_count := 10

func _ready():
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = wave_scale
	noise.fractal_octaves = 2
	noise.fractal_gain = 0.5

	# Generate dune points
	for x in range(width):
		var y = noise.get_noise_2d(x + offset, 0.0) * amplitude + height / 2
		dune_points.append(Vector2(x, y))

	# Generate flat platform at the end (separate from dune_points)
	var flat_y := dune_points[dune_points.size() - 1].y
	flat_points.append(Vector2(width - 1, flat_y))
	flat_points.append(Vector2(width - 1 + flat_width + 1, flat_y))

	static_body = StaticBody2D.new()
	add_child(static_body)
	collision_polygon = CollisionPolygon2D.new()
	static_body.add_child(collision_polygon)

	polygon_points.append_array(dune_points)
	polygon_points.append_array(flat_points)
	var last_x = flat_points[flat_points.size() - 1].x
	polygon_points.append(Vector2(last_x, height))
	polygon_points.append(Vector2(0, height))

	collision_polygon.polygon = polygon_points
	collision_polygon.build_mode = CollisionPolygon2D.BUILD_SOLIDS

	spawn_plants()
	spawn_characters()
	spawn_weapons()
	spawn_portal()

func _draw():
	if dune_points.size() < 2:
		return

	draw_polygon(polygon_points, [Color(255.0 / 256, 236.0 / 256, 86.0 / 256)])

func spawn_plants():
	if not plant_scene_c or not plant_scene_f:
		print("Plant scene not assigned!")
		return

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in range(plant_spawn_count):
		var x_index = rng.randi_range(0, dune_points.size() - 1)
		var position = dune_points[x_index]
		var plant_type = randi() % 2

		var plant_instance
		if plant_type == 0:
			plant_instance = plant_scene_c.instantiate()
		else:
			plant_instance = plant_scene_f.instantiate()
		plant_instance.position = position
		add_child(plant_instance)

func spawn_characters():
	if not random_character:
		print("Character scene not assigned!")
		return

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in range(character_spawn_count):
		var x_index = rng.randi_range(0, dune_points.size() - 1)
		var x_offset = rng.randi_range(-50, 50)
		
		var position = Vector2(dune_points[x_index].x + x_offset, dune_points[x_index].y)

		var character_instance = random_character.instantiate()
		character_instance.position = Vector2(position.x, position.y - 100)
		character_instance.rotation = get_slope_angle_at(position.x)

		add_child(character_instance)
		npcs.append(character_instance)

func spawn_weapons():
	if not random_weapon:
		print("Weapon scene not assigned!")
		return

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in range(weapon_spawn_count):
		var x_index = rng.randi_range(0, dune_points.size() - 1)
		var x_offset = rng.randi_range(-50, 50)
		
		var position = Vector2(dune_points[x_index].x + x_offset, dune_points[x_index].y)

		var weapon_instance = random_weapon.instantiate()
		weapon_instance.position = Vector2(position.x, position.y - 100)
		weapon_instance.rotation = get_slope_angle_at(position.x)

		add_child(weapon_instance)
		weapons.append(weapon_instance)

func spawn_portal():
	if not portal_scene:
		print("Portal scene not assigned!")
		return

	if flat_points.size() == 0:
		print("Flat platform not found!")
		return

	var first_flat = flat_points[0]
	var last_flat = flat_points[flat_points.size() - 1]
	var flat_center_x = first_flat.x + ((last_flat.x - first_flat.x) / 8 * 7)
	var flat_y = first_flat.y

	var portal_instance = portal_scene.instantiate()
	portal_instance.position = Vector2(flat_center_x, flat_y - 50)
	var portal_area: Area2D = portal_instance.get_node("Area2D")
	portal_area.body_entered.connect(_on_portal_body_entered)
	add_child(portal_instance)
	
func _on_portal_body_entered(body: Node) -> void:
	print(body.name)
	if body.name == "Wander":
		print("Player entered the portal area!")

func get_ground_y_at(x: float) -> float:
	if x <= dune_points[0].x:
		return dune_points[0].y
	if x >= flat_points[flat_points.size() - 1].x:
		return flat_points[flat_points.size() - 1].y

	for i in range(dune_points.size() - 1):
		var p1 = dune_points[i]
		var p2 = dune_points[i + 1]
		if x >= p1.x and x <= p2.x:
			var t = (x - p1.x) / (p2.x - p1.x)
			return lerp(p1.y, p2.y, t)

	for i in range(flat_points.size() - 1):
		var p1 = flat_points[i]
		var p2 = flat_points[i + 1]
		if x >= p1.x and x <= p2.x:
			return p1.y  # Flat section is constant y

	return 0

func get_slope_angle_at(x: float) -> float:
	if dune_points.size() < 2:
		return 0

	# If outside the terrain range
	if x <= dune_points[0].x or x >= flat_points[0].x:
		return 0

	# Find the segment that x lies within
	for i in range(dune_points.size() - 1):
		var p1 = dune_points[i]
		var p2 = dune_points[i + 1]
		if x >= p1.x and x <= p2.x:
			var delta = p2 - p1
			return atan2(delta.y, delta.x)

	return 0  # Default fallback
