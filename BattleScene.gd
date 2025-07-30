extends Node2D

@onready var out_of_combat_ui: Control = $CanvasLayer/OutOfCombatUI

@onready var combat_core: Node2D = %CombatCore
@onready var enemy_1: Enemy = $Enemy1
@onready var enemy_2: Enemy = $Enemy2
@onready var player: Player = $Player

@onready var ship_type_1_select: ItemList = $"CanvasLayer/OutOfCombatUI/PlayerInfoEditorUI/VBoxContainer/HBoxContainer/Ship Type/ShipType1Select"
@onready var ship_type_2_select: ItemList = $"CanvasLayer/OutOfCombatUI/PlayerInfoEditorUI/VBoxContainer/HBoxContainer/Ship Type/ShipType2Select"
@onready var player_info_editor_ui: Control = $CanvasLayer/OutOfCombatUI/PlayerInfoEditorUI
@onready var buttons: Control = $CanvasLayer/OutOfCombatUI/Buttons

signal battle_ended

func _ready() -> void:
	combat_core.battle_ended.connect(_battle_ended)
	player_info_editor_ui.visible = false

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


func _on_edit_player_info_pressed() -> void:
	buttons.visible = false
	player_info_editor_ui.visible = true

func _on_return_pressed() -> void:
	buttons.visible = true
	player_info_editor_ui.visible = false

func _on_ship_type_1_select_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	player.type_1 = ship_type_1_select.get_item_text(index)


func _on_ship_type_2_select_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	player.type_2 = ship_type_2_select.get_item_text(index)
