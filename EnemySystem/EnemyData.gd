extends Resource
class_name EnemyData

@export var enemy_name: String
@export_enum("Navy", "Krakeneers", "Vanguards", "Helions", "Pirates", "Spookies") var enemy_faction: int
@export_enum("N/A","Physical", "Magic - Ocean", "Magic - Storm", "Magic - Fire", "Magic - Resonance", "Magic - Spectral", "Magic - Ancient", "Magic - Arcane") var type_1: String
@export_enum("N/A","Physical", "Magic - Ocean", "Magic - Storm", "Magic - Fire", "Magic - Resonance", "Magic - Spectral", "Magic - Ancient", "Magic - Arcane") var type_2: String

@export var ship_type: ShipData

@export var attack_moves: Array[AttackMoveData]
@export var defense_moves: Array[DefenseMoveData]
