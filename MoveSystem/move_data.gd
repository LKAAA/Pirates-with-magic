extends Resource
class_name MoveData

@export var move_name: String
@export_multiline var move_description: String
@export_enum("Physical", "Magic - Ocean", "Magic - Storm", "Magic - Fire", "Magic - Resonance", "Magic - Spectral", "Magic - Ancient", "Magic - Arcane") var move_type: String
@export var effect_chance: int = 0 # In percent
@export var effect_duration: int = 0 # In turns (0 for instant)
@export var max_uses: int = 30
@export var hasACooldown: bool = false
@export var cooldownLength: int = 0



func _activate_move() -> void:
	pass
