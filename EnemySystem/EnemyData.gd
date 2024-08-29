extends Resource
class_name EnemyData

@export var enemy_name: String
@export_enum("Navy", "Krakeneers", "Vanguards", "Helions", "Pirates", "Spookies") var enemy_faction: int

@export var ship_type: ShipData

@export var attack_moves: Array[AttackMoveData]
@export var defense_moves: Array[DefenseMoveData]
