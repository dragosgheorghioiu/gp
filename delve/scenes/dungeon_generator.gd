extends Node2D

class_name DungeonGenerator

# Constants for dungeon generation
const MIN_ROOM_SIZE = 6
const MAX_ROOM_SIZE = 12
const MIN_PARTITION_SIZE = 15
const ROOM_PADDING = 1
const ENEMY_CHANCE = 0.3  # 30% chance for a room to have enemies
const TREASURE_CHANCE = 0.2  # 20% chance for a room to have treasure
const MAX_ENEMIES_PER_ROOM = 3
const MAX_TREASURES_PER_ROOM = 2

# Tile types
enum TileType {
	EMPTY = 0,
	WALL = 1,
	FLOOR = 2,
	DOOR = 3,
	ENEMY = 4,
	TREASURE = 5
}

# Room class to store room information
class Room:
	var rect: Rect2
	var center: Vector2
	var enemies: Array[Vector2] = []
	var treasures: Array[Vector2] = []
	
	func _init(r: Rect2):
		rect = r
		center = rect.position + rect.size / 2

# Partition class for BSP tree
class Partition:
	var rect: Rect2
	var left: Partition = null
	var right: Partition = null
	var room: Room = null
	
	func _init(r: Rect2):
		rect = r

var rng = RandomNumberGenerator.new()
var dungeon_map: Array = []
var rooms: Array[Room] = []
var root_partition: Partition

func _init():
	rng.randomize()

func generate_dungeon(width: int, height: int) -> Array:
	# Initialize empty map
	dungeon_map = []
	for x in range(width):
		var column = []
		for y in range(height):
			column.append(TileType.WALL)
		dungeon_map.append(column)
	
	# Create root partition
	root_partition = Partition.new(Rect2(1, 1, width - 2, height - 2))
	
	# Split partitions
	_split_partition(root_partition)
	
	# Generate rooms
	_generate_rooms(root_partition)
	
	# Connect rooms
	_connect_rooms()
	
	# Place enemies and treasures
	_place_enemies_and_treasures()
	
	return dungeon_map

func _split_partition(partition: Partition) -> void:
	var width = partition.rect.size.x
	var height = partition.rect.size.y
	
	# Stop splitting if partition is too small
	if width < MIN_PARTITION_SIZE or height < MIN_PARTITION_SIZE:
		return
	
	# Randomly choose split direction
	var split_horizontal = rng.randf() > 0.5
	
	if split_horizontal:
		# Split horizontally
		var split_point = rng.randi_range(MIN_PARTITION_SIZE, int(width - MIN_PARTITION_SIZE))
		partition.left = Partition.new(Rect2(
			partition.rect.position.x,
			partition.rect.position.y,
			split_point,
			height
		))
		partition.right = Partition.new(Rect2(
			partition.rect.position.x + split_point,
			partition.rect.position.y,
			width - split_point,
			height
		))
	else:
		# Split vertically
		var split_point = rng.randi_range(MIN_PARTITION_SIZE, int(height - MIN_PARTITION_SIZE))
		partition.left = Partition.new(Rect2(
			partition.rect.position.x,
			partition.rect.position.y,
			width,
			split_point
		))
		partition.right = Partition.new(Rect2(
			partition.rect.position.x,
			partition.rect.position.y + split_point,
			width,
			height - split_point
		))
	
	# Recursively split child partitions
	_split_partition(partition.left)
	_split_partition(partition.right)

func _generate_rooms(partition: Partition) -> void:
	if partition.left == null and partition.right == null:
		# Create room in leaf partition
		var room_width = rng.randi_range(MIN_ROOM_SIZE, min(MAX_ROOM_SIZE, int(partition.rect.size.x - 2)))
		var room_height = rng.randi_range(MIN_ROOM_SIZE, min(MAX_ROOM_SIZE, int(partition.rect.size.y - 2)))
		
		var room_x = rng.randi_range(
			int(partition.rect.position.x + ROOM_PADDING),
			int(partition.rect.position.x + partition.rect.size.x - room_width - ROOM_PADDING)
		)
		var room_y = rng.randi_range(
			int(partition.rect.position.y + ROOM_PADDING),
			int(partition.rect.position.y + partition.rect.size.y - room_height - ROOM_PADDING)
		)
		
		var room_rect = Rect2(room_x, room_y, room_width, room_height)
		partition.room = Room.new(room_rect)
		rooms.append(partition.room)
		
		# Fill room with floor tiles
		for x in range(room_x, room_x + room_width):
			for y in range(room_y, room_y + room_height):
				dungeon_map[x][y] = TileType.FLOOR
	else:
		# Recursively generate rooms in child partitions
		if partition.left:
			_generate_rooms(partition.left)
		if partition.right:
			_generate_rooms(partition.right)

func _connect_rooms() -> void:
	# Connect rooms in the same partition
	_connect_partition_rooms(root_partition)
	
	# Connect rooms between different partitions
	for i in range(rooms.size() - 1):
		_create_corridor(rooms[i].center, rooms[i + 1].center)

func _connect_partition_rooms(partition: Partition) -> void:
	if partition.left and partition.right:
		if partition.left.room and partition.right.room:
			_create_corridor(partition.left.room.center, partition.right.room.center)
		
		_connect_partition_rooms(partition.left)
		_connect_partition_rooms(partition.right)

func _create_corridor(start: Vector2, end: Vector2) -> void:
	var current = start
	
	# Create L-shaped corridor
	while current.x != end.x:
		current.x += sign(end.x - current.x)
		dungeon_map[int(current.x)][int(current.y)] = TileType.FLOOR
	
	while current.y != end.y:
		current.y += sign(end.y - current.y)
		dungeon_map[int(current.x)][int(current.y)] = TileType.FLOOR

func _place_enemies_and_treasures() -> void:
	for room in rooms:
		# Place enemies
		if rng.randf() < ENEMY_CHANCE:
			var num_enemies = rng.randi_range(1, MAX_ENEMIES_PER_ROOM)
			for i in range(num_enemies):
				var enemy_pos = _get_random_floor_position(room)
				if enemy_pos != null:
					dungeon_map[int(enemy_pos.x)][int(enemy_pos.y)] = TileType.ENEMY
					room.enemies.append(enemy_pos)
		
		# Place treasures
		if rng.randf() < TREASURE_CHANCE:
			var num_treasures = rng.randi_range(1, MAX_TREASURES_PER_ROOM)
			for i in range(num_treasures):
				var treasure_pos = _get_random_floor_position(room)
				if treasure_pos != null:
					dungeon_map[int(treasure_pos.x)][int(treasure_pos.y)] = TileType.TREASURE
					room.treasures.append(treasure_pos)

func _get_random_floor_position(room: Room) -> Vector2:
	var attempts = 0
	var max_attempts = 10
	
	while attempts < max_attempts:
		var x = rng.randi_range(int(room.rect.position.x + 1), int(room.rect.position.x + room.rect.size.x - 2))
		var y = rng.randi_range(int(room.rect.position.y + 1), int(room.rect.position.y + room.rect.size.y - 2))
		
		# Check if the position is a floor tile and not already occupied
		if dungeon_map[x][y] == TileType.FLOOR:
			return Vector2(x, y)
		
		attempts += 1
	
	return Vector2.ZERO  # Return null if no valid position found

# Function to get the generated dungeon map
func get_dungeon_map() -> Array:
	return dungeon_map

# Function to get the list of generated rooms
func get_rooms() -> Array[Room]:
	return rooms
