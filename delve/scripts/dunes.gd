extends Node2D

var noise : FastNoiseLite
var dune_points : PackedVector2Array = PackedVector2Array()
var static_body : StaticBody2D
var collision_polygon : CollisionPolygon2D

@export var width := 5000
@export var height := 2000
@export var wave_scale := 0.0015
@export var amplitude := 100.0     
@export var offset := 100.0
@export var plant_scene_c : PackedScene
@export var plant_scene_f : PackedScene
@export var random_character : PackedScene
@export var plant_spawn_count := 50
@export var character_spawn_count := 10

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

	static_body = StaticBody2D.new()
	add_child(static_body)
	collision_polygon = CollisionPolygon2D.new()
	static_body.add_child(collision_polygon)

	var polygon_points := PackedVector2Array(dune_points)
	polygon_points.append(Vector2(width - 1, height))
	polygon_points.append(Vector2(0, height))

	collision_polygon.polygon = polygon_points
	collision_polygon.build_mode = CollisionPolygon2D.BUILD_SOLIDS
	spawn_plants()
	spawn_characters()

func _draw():
	if dune_points.size() < 2:
		return

	var polygon_points := PackedVector2Array(dune_points)
	polygon_points.append(Vector2(width - 1, height))
	polygon_points.append(Vector2(0, height))

	draw_polygon(polygon_points, [Color(255.0 / 256, 236.0 / 256, 86.0 / 256)])

	for i in range(1, dune_points.size()):
		draw_line(dune_points[i - 1], dune_points[i], Color(0.8, 0.7, 0.5), 2.0)

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

	var used_positions = []
	var min_distance = 200  # Adjust this value to set desired spacing

	var attempts = 0
	var max_attempts = character_spawn_count * 5

	while used_positions.size() < character_spawn_count and attempts < max_attempts:
		attempts += 1

		var x_index = rng.randi_range(0, dune_points.size() - 1)
		var position = dune_points[x_index]

		var too_close = false
		for used_pos in used_positions:
			if position.distance_to(used_pos) < min_distance:
				too_close = true
				break

		if too_close:
			continue

		var character_instance = random_character.instantiate()
		character_instance.position = Vector2(position.x, position.y - 100)
		character_instance.rotation = get_slope_angle_at(position.x)
		
		add_child(character_instance)

		used_positions.append(position)


func get_ground_y_at(x: float) -> float:
	if x <= dune_points[0].x:
		return dune_points[0].y
	if x >= dune_points[dune_points.size() - 1].x:
		return dune_points[dune_points.size() - 1].y
	
	for i in range(dune_points.size() - 1):
		var p1 = dune_points[i]
		var p2 = dune_points[i + 1]
		if x >= p1.x and x <= p2.x:
			# Linear interpolation between p1.y and p2.y based on x
			var t = (x - p1.x) / (p2.x - p1.x)
			return lerp(p1.y, p2.y, t)
	
	return 0
	
func get_slope_angle_at(x: float) -> float:
	if x > dune_points.size() - 2:
		return 0
	var idx = clamp(int(x), 1, dune_points.size() - 2)
	var p1 = dune_points[idx - 1]
	var p2 = dune_points[idx + 1]
	
	var delta = p2 - p1
	
	return atan2(delta.y, delta.x)  # This gives you the angle in radians
