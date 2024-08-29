extends MoveData
class_name DefenseMoveData

@export_range(1, 500) var heal_strength: int = 0
@export_range(1, 100) var damage_reduction: int = 0
@export_range(1, 500) var hull_repair_amount: int = 0

@export_category("Toggles")
@export var canRepairHull: bool = false
@export var canIncreasePhysicalResistance: bool = false
@export var canIncreaseMagicalResistance: bool = false
@export var canIncreaseEvasion: bool = false
@export var canReflectDamage: bool = false
@export_range(1, 100) var returnDamagePercent: int = 0
@export var canRestoreCrewHealth: bool = false
@export var canBoostCrewEffectiveness: bool = false
@export var canIncreaseMovementSpeed: bool = false
@export var canSummonAdditionalCrew: bool = false
@export var summonedCrewAmount: int = 0
@export var canAbsorbDamage: bool = false
@export_range(1, 500) var absorbDamageStrength: int = 0
@export var grantsImmunityToStatusEffects: bool = false
@export var canStabalizeShip: bool = false
@export var canReduceEnemyAccuracy: bool = false
