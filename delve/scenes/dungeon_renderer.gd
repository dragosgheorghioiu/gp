extends Node2D

class_name DungeonRenderer

# Tile scenes to instantiate
@export var wall_tile_scene: PackedScene
@export var floor_tile_scene: PackedScene
@export var enemy_tile_scene: PackedScene
@export var treasure_tile_scene: PackedScene

# Tile size in pixels
@export var tile_size: int = 32

# References
var dungeon_generator: DungeonGenerator
var tile_container: Node2D

func _init():
	tile_container = Node2D.new()
	add_child(tile_container)

func render_dungeon(generator: DungeonGenerator) -> void:
	dungeon_generator = generator
	var dungeon_map = generator.get_dungeon_map()
	
	# Clear any existing tiles
	for child in tile_container.get_children():
		child.queue_free()
	
	# Create tiles for each cell in the map
	for x in range(dungeon_map.size()):
		for y in range(dungeon_map[x].size()):
			var tile_type = dungeon_map[x][y]
			var tile_instance = _create_tile(tile_type)
			
			if tile_instance:
				tile_instance.position = Vector2(x * tile_size, y * tile_size)
				tile_container.add_child(tile_instance)

func _create_tile(tile_type: int) -> Node2D:
	var tile_scene: PackedScene
	var tile_instance: Node2D
	
	match tile_type:
		DungeonGenerator.TileType.WALL:
			tile_scene = wall_tile_scene
		DungeonGenerator.TileType.FLOOR:
			tile_scene = floor_tile_scene
		DungeonGenerator.TileType.ENEMY:
			tile_scene = enemy_tile_scene
		DungeonGenerator.TileType.TREASURE:
			tile_scene = treasure_tile_scene
		_:
			return null
	
	if tile_scene:
		tile_instance = tile_scene.instantiate()
		return tile_instance
	
	return null

# Helper function to get world position from grid coordinates
func grid_to_world(grid_pos: Vector2) -> Vector2:
	return grid_pos * tile_size

# Helper function to get grid coordinates from world position
func world_to_grid(world_pos: Vector2) -> Vector2:
	return Vector2(
		floor(world_pos.x / tile_size),
		floor(world_pos.y / tile_size)
	) 
