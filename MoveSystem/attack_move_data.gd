extends MoveData
class_name AttackMoveData

@export_range(1, 500) var hull_damage: float = 0
@export_range(1, 100) var accuracy: int = 100
@export_range(1, 100) var ability_strength_percent: float = 0 
@export_enum("Physical", "Magic")var damage_type: int

@export_category("Toggles")
@export var canDisableCannons: bool = false
@export var canStunCrew: bool = false
@export var ignorePhysicalDefense: bool = false
@export var ignoreMagicalDefense: bool = false
@export var canLowerEnemyMoral: bool = false
@export var canIgnite: bool = false
@export var canKillCrew: bool = false
@export var canReduceEnemySpeed: bool = false
@export var canLifeDrain: bool = false
@export_range(1, 100) var lifeDrainAmount: int = 0
@export var canReduceEnemyAccuracy: bool = false
