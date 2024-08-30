extends StateMachine

func _ready() -> void:
	add_state("OutOfCombat")
	add_state("CombatEntry")
	add_state("PlayerChoice")
	add_state("EnemyChoice")
	add_state("ProcessActions")
	add_state("EndCombat")
	call_deferred("set_state", states.OutOfCombat)

func _state_logic(delta):
	if state == states.OutOfCombat:
		pass

func _get_transition(delta):
	match state:
		states.OutOfCombat:
			if parent._should_enter_combat():
				return states.CombatEntry
		states.CombatEntry:
			if parent._entry_finished():
				return states.PlayerChoice
		states.PlayerChoice:
			if parent._player_has_chosen():
				return states.EnemyChoice
		states.EnemyChoice:
			if parent._enemy_has_chosen():
				return states.ProcessActions
		states.ProcessActions:
			if parent._actions_processed() && parent._combat_finished():
				return states.EndCombat
			elif parent._actions_processed():
				return states.PlayerChoice
		states.EndCombat:
			if parent._combat_rewards_given():
				return states.OutOfCombat
	
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.OutOfCombat:
			#print(states)
			if old_state == states.EndCombat:
				parent.battle_ended.emit(parent.battle_end_state)
			parent._reset_combat_system()
			print("Out of Combat State")
		states.CombatEntry:
			# Play entry animations
			parent._enter_combat()
			print("Entering Combat State")
		states.PlayerChoice:
			# Bring up Choice UI
			parent._toggle_player_choice()
			print("Player Choice State")
		states.EnemyChoice:
			parent._enter_enemy_choice()
			print("Enemy Choice State")
		states.ProcessActions:
			parent._process_combat()
			print("Processing Moves State")
		states.EndCombat:
			parent._end_combat()
			print("End of Combat State")

func _exit_state(old_state, new_state):
	pass
