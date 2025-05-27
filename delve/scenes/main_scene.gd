extends Node2D

@onready var wander = %Wander
@onready var npcstats = %NPCStats
@onready var weaponstats = %WeaponStats
@onready var npcs = %Dunes.npcs
@onready var weapons = %Dunes.weapons

const character_details = "%s\nHealth: %d\nDamage: %d\nTrait: %s"
const weapon_details = "Type: %s\nDamage: %d\nDurability: %d\nRarity: %s\nEffects: %s"

var check_timer := 0.0
@export var check_interval := 0.25 

func _process(delta: float) -> void:
	check_timer -= delta
	if check_timer <= 0:
		check_timer = check_interval
		update_npc_stats()
		update_weapon_stats()

func update_npc_stats() -> void:
	if npcs.is_empty():
		npcstats.visible = false
		return

	var min_dist := INF
	var closest_npc = null
	var x = wander.position.x

	for npc in npcs:
		var dist = abs(npc.position.x - x)
		if dist < min_dist:
			min_dist = dist
			closest_npc = npc

	if closest_npc and min_dist < 200:
		var character = closest_npc.character
		if character:
			npcstats.text = character_details % [
				character.get("name", "Unknown"),
				character.get("health", 0),
				character.get("damage", 0),
				character.get("character_trait", "None")
			]
			npcstats.visible = true
	else:
		npcstats.visible = false

func update_weapon_stats() -> void:
	if weapons.is_empty():
		weaponstats.visible = false
		return

	var min_dist := INF
	var closest_weapon = null
	var x = wander.position.x

	for weapon in weapons:
		var dist = abs(weapon.position.x - x)
		if dist < min_dist:
			min_dist = dist
			closest_weapon = weapon

	if closest_weapon and min_dist < 200:
		var weapon_data = closest_weapon.weapon
		if weapon_data:
			weaponstats.text = weapon_details % [
				" ".join(weapon_data.get("class", "Unknown").split("_")),
				weapon_data.get("damage", 0),
				weapon_data.get("durability", 0),
				weapon_data.get("rarity", "Common"),
				" ".join(weapon_data.get("effects", "None")) if len(weapon_data.get("effects")) > 0 else "none"
			]
			weaponstats.visible = true
	else:
		weaponstats.visible = false
