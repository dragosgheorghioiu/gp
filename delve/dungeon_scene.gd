extends Node2D

@onready var dungeon_generator = DungeonGenerator.new()
@onready var dungeon_renderer = $DungeonRenderer

# Dungeon size
const DUNGEON_WIDTH = 50
const DUNGEON_HEIGHT = 50

func _ready():
	# Generate and render the dungeon
	generate_new_dungeon()

func generate_new_dungeon() -> void:
	# Generate the dungeon
	dungeon_generator.generate_dungeon(DUNGEON_WIDTH, DUNGEON_HEIGHT)
	
	# Render the dungeon
	dungeon_renderer.render_dungeon(dungeon_generator)
	
	# Optional: Print some debug information
	print("Generated dungeon with ", dungeon_generator.get_rooms().size(), " rooms")
	for room in dungeon_generator.get_rooms():
		print("Room at ", room.rect.position, " with ", room.enemies.size(), " enemies and ", room.treasures.size(), " treasures") 
