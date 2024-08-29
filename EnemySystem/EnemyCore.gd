extends Node2D
class_name Enemy

@export var enemy_data: EnemyData

@onready var ship_holder: ShipHolder = %ShipHolder

func _ready() -> void:
	ship_holder.ship_type = enemy_data.ship_type
	ship_holder.equipped_attack_moves = enemy_data.attack_moves
	ship_holder.equipped_defense_moves = enemy_data.defense_moves
	
	
	ship_holder._test_stats()
