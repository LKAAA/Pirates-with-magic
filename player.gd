extends Node2D
class_name Player

@onready var ship_holder: ShipHolder = %ShipHolder

@export_enum("N/A","Physical", "Magic - Ocean", "Magic - Storm", "Magic - Fire", "Magic - Resonance", "Magic - Spectral", "Magic - Ancient", "Magic - Arcane") var type_1: String
@export_enum("N/A","Physical", "Magic - Ocean", "Magic - Storm", "Magic - Fire", "Magic - Resonance", "Magic - Spectral", "Magic - Ancient", "Magic - Arcane") var type_2: String


func _ready() -> void:
	ship_holder._test_stats()
	print("Crew Members : " + str(ship_holder.cur_crew_members))
	print("Weight : " + str(ship_holder.cur_cargo_weight))
	print("P Attack : " + str(ship_holder.physical_attack_stat))
	print("P Defense : " + str(ship_holder.physical_defense_stat))
	print("M Attack : " + str(ship_holder.magical_attack_stat))
	print("M Defense : " + str(ship_holder.magical_defense_stat))
	print("Evasion : " + str(ship_holder.evasiveness_stat))
