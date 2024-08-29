extends Control

enum options { PRE_SELECTION, ATTACK, DEFENSE, SHIFT, SUPPORT}
var active_option = 0

signal move_chosen(move_type: int, move_option: int)
signal flee_battle

@onready var button_1: Button = $Button1
@onready var button_2: Button = $Button2
@onready var button_3: Button = $Button3
@onready var button_4: Button = $Button4


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("back_out"):
		active_option = 0
		_update_buttons_text()

func _update_buttons_text():
	var p_attack_moves = get_parent().get_parent().player_attack_moves
	var p_defense_moves = get_parent().get_parent().player_defense_moves
	var p_shift_moves = get_parent().get_parent().player_shift_moves
	match active_option:
		0: # No choice selected
			button_1.text = "Attack"
			button_2.text = "Defense"
			button_3.text = "Shift"
			button_4.text = "Support"
		1: # Attack selected
			if p_attack_moves.size() < 1:
				button_1.text = "No Move"
			else:
				button_1.text = p_attack_moves[0].move_name
			if p_attack_moves.size() < 2:
				button_2.text = "No Move"
			else:
				button_2.text = p_attack_moves[1].move_name
			if p_attack_moves.size() < 3:
				button_3.text = "No Move"
			else:
				button_3.text = p_attack_moves[2].move_name
			if p_attack_moves.size() < 4:
				button_4.text = "No Move"
			else:
				button_4.text = p_attack_moves[3].move_name
		2: # Defense selected
			if p_defense_moves.size() < 1:
				button_1.text = "No Move"
			else:
				button_1.text = p_defense_moves[0].move_name
			if p_defense_moves.size() < 2:
				button_2.text = "No Move"
			else:
				button_2.text = p_defense_moves[1].move_name
			if p_defense_moves.size() < 3:
				button_3.text = "No Move"
			else:
				button_3.text = p_defense_moves[2].move_name
			if p_defense_moves.size() < 4:
				button_4.text = "No Move"
			else:
				button_4.text = p_defense_moves[3].move_name
		3: # Shift Selected
			if p_shift_moves.size() < 1:
				button_1.text = "No Shift"
			else:
				button_1.text = p_shift_moves[0].move_name
			if p_shift_moves.size() < 2:
				button_2.text = "No Shift"
			else:
				button_2.text = p_shift_moves[1].move_name
			if p_shift_moves.size() < 3:
				button_3.text = "No Shift"
			else:
				button_3.text = p_shift_moves[2].move_name
			if p_shift_moves.size() < 4:
				button_4.text = "No Shift"
			else:
				button_4.text = p_shift_moves[3].move_name
		4: # Support selected
			button_1.text = "Attempt Boarding"
			button_2.text = "Raise Surrender Flag"
			button_3.text = "Use Cargo"
			button_4.text = "Flee"


func _on_attack_button_pressed() -> void:
	match (active_option):
		options.PRE_SELECTION:
			print("Go into attack options")
			active_option = 1
		options.ATTACK:
			move_chosen.emit(active_option, 1)
			active_option = 0
		options.DEFENSE:
			move_chosen.emit(active_option, 1)
			active_option = 0
		options.SUPPORT:
			move_chosen.emit(active_option, 1)
			active_option = 0
		options.SHIFT:
			move_chosen.emit(active_option, 1)
			active_option = 0
	_update_buttons_text()


func _on_defense_button_pressed() -> void:
	match (active_option):
		options.PRE_SELECTION:
			print("Go into defense options")
			active_option = 2
		options.ATTACK:
			move_chosen.emit(active_option, 2)
			active_option = 0
		options.DEFENSE:
			move_chosen.emit(active_option, 2)
			active_option = 0
		options.SUPPORT:
			move_chosen.emit(active_option, 2)
			active_option = 0
		options.SHIFT:
			move_chosen.emit(active_option,2)
			active_option = 0
	_update_buttons_text()


func _on_support_button_pressed() -> void:
	match (active_option):
		options.PRE_SELECTION:
			print("Go into shift options")
			active_option = 3
		options.ATTACK:
			move_chosen.emit(active_option, 3)
			active_option = 0
		options.DEFENSE:
			move_chosen.emit(active_option, 3)
			active_option = 0
		options.SUPPORT:
			move_chosen.emit(active_option, 3)
			active_option = 0
		options.SHIFT:
			move_chosen.emit(active_option, 3)
			active_option = 0
	_update_buttons_text()

func _on_button_4_pressed() -> void:
	match (active_option):
		options.PRE_SELECTION:
			print("Go into support options")
			active_option = 4
		options.ATTACK:
			move_chosen.emit(active_option, 4)
			active_option = 0
		options.DEFENSE:
			move_chosen.emit(active_option, 4)
			active_option = 0
		options.SUPPORT:
			flee_battle.emit()
			move_chosen.emit(active_option, 4)
			active_option = 0
		options.SHIFT:
			move_chosen.emit(active_option, 4)
			active_option = 0
	_update_buttons_text()
