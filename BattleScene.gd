extends Node2D

@onready var out_of_combat_ui: Control = $CanvasLayer/OutOfCombatUI

@onready var combat_core: Node2D = %CombatCore
@onready var enemy_1: Enemy = $Enemy1
@onready var enemy_2: Enemy = $Enemy2

signal battle_ended

func _ready() -> void:
	combat_core.battle_ended.connect(_battle_ended)

func _battle_ended(battle_end_state) -> void:
	out_of_combat_ui.visible = true
	battle_ended.emit(battle_end_state)

func _enter_battle(enemy: Enemy) -> void:
	out_of_combat_ui.visible = false
	combat_core._initiate_combat(enemy)

func _on_begin_combat_button_pressed() -> void:
	print("Initiating combat with enemy 1")
	_enter_battle(enemy_1)

func _on_begin_combat_button_2_pressed() -> void:
	print("Initiating combat with enemy 1")
	_enter_battle(enemy_2)
