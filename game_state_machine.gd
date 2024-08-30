extends StateMachine

func _ready() -> void:
	add_state("PortMode")
	add_state("VoyageMode")
	add_state("BattleMode")
	add_state("DefeatState")
	call_deferred("set_state", states.PortMode)

func _state_logic(delta):
	if state == states.PortMode:
		pass

func _get_transition(delta):
	match state:
		states.PortMode:
			if parent._should_enter_voyage():
				return states.VoyageMode
		states.VoyageMode:
			if parent._should_enter_battle():
				return states.BattleMode
			if parent._should_return_to_port():
				return states.PortMode
		states.BattleMode:
			if parent._should_leave_battle():
				return states.VoyageMode
			if parent._player_lost_battle():
				return states.DefeatState
		states.DefeatState:
			if parent._reset_from_defeat():
				return states.PortMode
	
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.PortMode:
			parent.leave_battle = false
			parent.reset_defeat = false
			print("Port Mode State")
		states.VoyageMode:
			parent.leave_battle = false
			parent.enter_voyage = false
			print("Voyage Mode State")
		states.BattleMode:
			parent.enter_battle = false
			parent.cur_battle_scene._enter_battle(parent.cur_enemy)
			print("Battle Mode State")
		states.DefeatState:
			parent.lost_battle = false
			print("Defeat State")

func _exit_state(old_state, new_state):
	pass
