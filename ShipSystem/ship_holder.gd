extends Node2D
class_name ShipHolder

@export var ship_type: ShipData

@export var equipped_attack_moves: Array[AttackMoveData]
@export var equipped_defense_moves: Array[DefenseMoveData]

var cur_hull_health: int = 1
var cur_crew_members: float = 1
var cur_special_crew_members: int = 0
var cur_cargo_weight: float = 0

var physical_attack_stat: float
var magical_attack_stat: float
var physical_defense_stat: float
var magical_defense_stat: float

var physical_defense_base: float
var magical_defense_base: float

var crew_morale_stat: int # Value from 1 -> 100. 50 being average morale

var evasiveness_stat: float

# Active buffs on this ship
var active_buffs: Dictionary = {}

func apply_buff(buff_name: String, effect: float, turns: int) -> void:
	if not active_buffs.has(buff_name):
		active_buffs[buff_name] = {"effect": effect, "turns": turns}
		match buff_name:
			"Physical Defense Increase":
				physical_defense_stat += effect
				print("Adding Physical Defense Buff")
				print("New physical defense: " + str(physical_defense_stat))
			"Magic Defense Increase":
				magical_defense_stat += effect
				print("Adding Magic Defense Buff")
				print("New magic defense: " + str(magical_defense_stat))
	else: # If buff is already active, just refresh its duration
		active_buffs[buff_name]["turns"] = turns

func progress_turn() -> void:
	var buffs_to_remove = []

	# Iterate through all active buffs
	for buff_name in active_buffs.keys():
		active_buffs[buff_name]["turns"] -= 1
		print("Turn passed for me!")
		if active_buffs[buff_name]["turns"] <= 0:
			buffs_to_remove.append(buff_name)

	# Remove expired buffs
	for buff_name in buffs_to_remove:
		match buff_name:
			"Physical Defense Increase":
				physical_defense_stat -= active_buffs[buff_name]["effect"]
				active_buffs.erase(buff_name)
				print("Removing Physical Defense Buff")
			"Magic Defense Increase":
				magical_defense_stat -= active_buffs[buff_name]["effect"]
				active_buffs.erase(buff_name)
				print("Removing Magic Defense Buff")

	# Ensure the buff doesn't fall below the base value
	physical_defense_stat = max(physical_defense_stat, physical_defense_base)
	magical_defense_stat = max(magical_defense_stat, magical_defense_base)

func _increase_physical_resistance(percent, turns) -> void:
	var buff_effect: float = physical_defense_base * (percent * 0.01)
	
	apply_buff("Physical Defense Increase", roundi(buff_effect), turns)

func _increase_magical_resistance(percent, turns) -> void:
	var buff_effect: float = magical_defense_base * (percent * 0.01)
	
	apply_buff("Magic Defense Increase", roundi(buff_effect), turns)

func _combat_starting() -> void:
	_calculate_all_stats()
	
	physical_defense_base = physical_defense_stat
	magical_defense_base = magical_defense_stat

func _calculate_physical_stats() -> void:
	physical_attack_stat = roundi(cur_crew_members * 2 * (crew_morale_stat / 2) / 10)
	physical_defense_stat = roundi(cur_crew_members * 1.5 * (crew_morale_stat / 2) / 10)

func _calculate_magical_stats() -> void:
	magical_attack_stat = roundi((cur_special_crew_members * 5) * 2 * (crew_morale_stat / 2) / 10)
	magical_defense_stat = roundi((cur_special_crew_members * 5) * 1.5 * (crew_morale_stat / 2) / 10)

func _calculate_crew_morale() -> void:
	crew_morale_stat = 50 # 50 is default
	# Increased by food system

func _calculate_evasiveness() -> void:
	evasiveness_stat = 1 + 5.69 * 0.5 * (cur_crew_members / ship_type.crew_member_max) * ship_type.max_speed * (1 - (cur_cargo_weight / ship_type.cargo_weight_max)) 

func _calculate_all_stats() -> void:
	_calculate_crew_morale()
	_calculate_evasiveness()
	_calculate_magical_stats()
	_calculate_physical_stats()

func _test_stats() -> void:
	cur_hull_health = ship_type.base_hull_health_max
	cur_crew_members = ship_type.crew_member_max
	cur_special_crew_members = ship_type.special_crew_member_max
	cur_cargo_weight = ship_type.cargo_weight_max / 2
	crew_morale_stat = 50 
	
	
	_calculate_all_stats()
