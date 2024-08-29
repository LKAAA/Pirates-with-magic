extends Node2D

@onready var in_combat: Control = $"UI Canvas Layer/InCombat"
@onready var player_choice_ui: Control = $"UI Canvas Layer/PlayerChoiceUI"

var enter_combat: bool = false
var entry_finished: bool = false
var has_player_chosen: bool = false
var has_enemy_chosen: bool = false
var finished_processing: bool = false
var combat_rewards_given: bool = false
var is_combat_over: bool = false
var is_fleeing: bool = false

var player_attack_moves: Array[AttackMoveData]
var player_defense_moves: Array[DefenseMoveData]
var player_max_hull_hp: int = 0
var player_cur_hull_hp: int = 0
var player_cur_crew_members: int = 0
var player_max_crew_members: int = 0
var player_cur_special_crew: int = 0
var player_max_special_crew: int = 0
var player_speed: int
var chosen_player_move
var player: Player

var current_enemy: Enemy
var enemy_max_hull_hp: int = 0
var enemy_cur_hull_hp: int = 0
var enemy_speed: int
var chosen_enemy_move
var prev_enemy_move

var enemy_damage_dealt
var player_damage_dealt

signal battle_ended


func _ready() -> void:
	player_choice_ui.flee_battle.connect(_flee_battle)
	player_choice_ui.move_chosen.connect(_decide_move)
	

func _reset_combat_system():
	combat_rewards_given = false
	enter_combat = false
	entry_finished = false
	has_player_chosen = false
	has_enemy_chosen = false
	finished_processing = false
	is_combat_over = false
	is_fleeing = false
	in_combat.visible = false
	player_choice_ui.visible = false
	player_attack_moves.clear()
	player_defense_moves.clear()

func _initiate_combat(enemy) -> void:
	current_enemy = enemy
	enter_combat = true

func _enter_combat():
	_toggle_passive_combat_ui()
	# LOADING STUFF / INTRO ANIMATIONS
	
	_load_player()
	_load_enemy()
	in_combat._update_labels(current_enemy, player, enemy_max_hull_hp, enemy_cur_hull_hp, player_max_hull_hp, 
								player_cur_hull_hp, player_max_crew_members, player_cur_crew_members)
	
	print("Player speed  = " + str(player_speed))
	print("Enemy speed = " + str(enemy_speed))
	print("Finished Loading")
	entry_finished = true

func _toggle_passive_combat_ui():
	player_choice_ui.visible = false
	in_combat.visible = true

func _load_player() -> void:
	player = get_tree().get_first_node_in_group("player")
	for i in player.ship_holder.equipped_attack_moves.size():
		player_attack_moves.append(player.ship_holder.equipped_attack_moves[i])
	
	for i in player.ship_holder.equipped_defense_moves.size():
		player_defense_moves.append(player.ship_holder.equipped_defense_moves[i])
	
	player_max_hull_hp = player.ship_holder.ship_type.base_hull_health_max
	player_cur_hull_hp = player.ship_holder.cur_hull_health
	player_max_crew_members = player.ship_holder.ship_type.crew_member_max
	player_cur_crew_members = player.ship_holder.cur_crew_members
	player_cur_special_crew = player.ship_holder.cur_special_crew_members
	player_max_special_crew = player.ship_holder.ship_type.special_crew_member_max
	player_speed = player.ship_holder.evasiveness_stat
	
	player.ship_holder._combat_starting()

func _load_enemy() -> void:
	enemy_cur_hull_hp = current_enemy.ship_holder.cur_hull_health
	enemy_max_hull_hp = current_enemy.ship_holder.ship_type.base_hull_health_max
	enemy_speed = current_enemy.ship_holder.evasiveness_stat
	
	current_enemy.ship_holder._combat_starting()

func _toggle_player_choice():
	in_combat.visible = true
	player_choice_ui.visible = true

func _enter_enemy_choice():
	_toggle_passive_combat_ui()
	
	_randomly_decide_enemy_move()
	
	has_enemy_chosen = true

func _process_combat():
	print("processing")
	var attack_order
	attack_order = _determine_attack_order()
	print(attack_order)
	var player_died = false
	var enemy_died = false
	
	if is_fleeing:
		is_combat_over = true
		finished_processing = true
		return
	
	if attack_order == 1: # Player goes first
		print("Player moves first")
		execute_player_move()
		
		if enemy_cur_hull_hp <= 0: # Determine if either the player or the enemy died
			enemy_died = true
		elif player_cur_hull_hp <= 0:
			player_died = true
		else:                      # If neither the player nor the enemy died, use the next persons attack
			execute_enemy_move()
			if enemy_cur_hull_hp <= 0:
				enemy_died = true
			elif player_cur_hull_hp <= 0:
				player_died = true
		
	elif attack_order == 2: # Enemy goes first
		print("Enemy moves first")
		execute_enemy_move()
		
		if enemy_cur_hull_hp <= 0: # Determine if either the player or the enemy died
			enemy_died = true
		elif player_cur_hull_hp <= 0:
			player_died = true
		else:                      # If neither the player nor the enemy died, use the next persons attack
			execute_player_move()
			if enemy_cur_hull_hp <= 0:
				enemy_died = true
			elif player_cur_hull_hp <= 0:
				player_died = true
	
	print("Player speed  = " + str(player_speed))
	print("Enemy speed = " + str(enemy_speed))
	
	in_combat._update_labels(current_enemy, player, enemy_max_hull_hp, enemy_cur_hull_hp, player_max_hull_hp, 
								player_cur_hull_hp, player_max_crew_members, player_cur_crew_members)
	in_combat._update_move_log(chosen_player_move, chosen_enemy_move, enemy_damage_dealt, player_damage_dealt)
	
	chosen_player_move = null
	chosen_enemy_move = null
	
	print("PLAYER DEAD = " + str(player_died))
	
	if player_died:
		is_combat_over = true
	elif enemy_died:
		is_combat_over = true
	else:
		has_player_chosen = false
		has_enemy_chosen = false
		is_combat_over = false
		player.ship_holder.progress_turn()
		current_enemy.ship_holder.progress_turn()
		print("Not dead yet")
	
	finished_processing = true

func _determine_attack_order() -> int:
	var attack_order_num: int # 1 = player , 2 = enemy
	
	if player_speed > enemy_speed: # Player faster
		attack_order_num = 1
	elif player_speed < enemy_speed: # Enemy faster
		attack_order_num = 2
	else: # SPEED TIE
		var rng = RandomNumberGenerator.new()
		var speedTieNum = rng.randi_range(1, 2)
		attack_order_num = speedTieNum
	
	return attack_order_num

func execute_player_move() -> void:
	if chosen_player_move:
		print("Executing move")
		if chosen_player_move is DefenseMoveData:
			var dmove: DefenseMoveData = chosen_player_move
			if dmove.canRepairHull:
				if player_cur_hull_hp < player_max_hull_hp:
					player_cur_hull_hp += dmove.hull_repair_amount
					if player_cur_hull_hp > player_max_hull_hp:
						player_cur_hull_hp = player_max_hull_hp
				else:
					print("At max HP")
			if dmove.canIncreasePhysicalResistance:
				player.ship_holder._increase_physical_resistance(dmove.damage_reduction, dmove.effect_duration)
				print("Increase Phys Res")
			if dmove.canIncreaseMagicalResistance: 
				player.ship_holder._increase_magical_resistance(dmove.damage_reduction, dmove.effect_duration)
				print("Increase Magic Res")
		else:
			var amove: AttackMoveData = chosen_player_move
			var hit: bool = _determine_if_move_hits(amove, current_enemy)
			if hit:
				if amove.hull_damage > 0:
					var hull_damage_calculated = _calculate_hull_damage(amove, player, current_enemy)
					enemy_cur_hull_hp -= hull_damage_calculated
					player_damage_dealt = hull_damage_calculated
			else:
				player_damage_dealt = 0
	else:
		print("Chose support move")

func execute_enemy_move() -> void:
	print("Executing move")
	if chosen_enemy_move is DefenseMoveData:
		var dmove: DefenseMoveData = chosen_enemy_move
		if dmove.canRepairHull:
			if enemy_cur_hull_hp < enemy_max_hull_hp:
				enemy_cur_hull_hp += dmove.hull_repair_amount
				if enemy_cur_hull_hp > enemy_max_hull_hp:
					enemy_cur_hull_hp = enemy_max_hull_hp
			else:
				print("At max HP")
		if dmove.canIncreasePhysicalResistance:
			current_enemy.ship_holder._increase_physical_resistance(dmove.damage_reduction, dmove.effect_duration)
			print("Increase Phys Res")
		if dmove.canIncreaseMagicalResistance: 
			current_enemy.ship_holder._increase_magical_resistance(dmove.damage_reduction, dmove.effect_duration)
			print("Increase Magic Res")
	else:
		var amove: AttackMoveData = chosen_enemy_move
		var hit: bool = _determine_if_move_hits(amove, player)
		if hit:
			if amove.hull_damage > 0:
				var hull_damage_calculated = _calculate_hull_damage(amove, current_enemy, player)
				player_cur_hull_hp -= hull_damage_calculated
				enemy_damage_dealt = hull_damage_calculated
		else:
			enemy_damage_dealt = 0

func _determine_if_move_hits(move: AttackMoveData, defender) -> bool:
	var hit: bool
	var rng = RandomNumberGenerator.new()
	var attackordefense = rng.randi_range(1, 2)
	var random = randi_range(1, 100)
	
	var effective_accuracy = move.accuracy - (defender.ship_holder.evasiveness_stat / 10)
	print("Base Accuracy: " + str(move.accuracy))
	print("Effective Accuracy: " + str(effective_accuracy))
	print("Defender Evasiveness: " + str(defender.ship_holder.evasiveness_stat))
	
	if random >=  effective_accuracy:
		hit = false
	else:
		hit = true
	
	return hit

func _calculate_hull_damage(chosen_move: AttackMoveData, attacker, defender) -> int:
	var damage_calculated: float
	var defender_magic_defense: float = defender.ship_holder.magical_defense_stat
	var defender_physical_defense: float = defender.ship_holder.physical_defense_stat
	
	var defender_morale = _calculate_morale(defender)
	var attacker_morale = _calculate_morale(attacker)
	
	if chosen_move.ignoreMagicalDefense:
		var modifier: float = (100 - chosen_move.ability_strength_percent) * 0.01
		print("Modifier: " + str(modifier))
		print("Defender stat before: " + str(defender.ship_holder.magical_defense_stat))
		defender_magic_defense *= modifier
		print("Defender stat after: " + str(defender_magic_defense))
	
	if chosen_move.ignorePhysicalDefense:
		var modifier: float = (100 - chosen_move.ability_strength_percent) * 0.01
		print("Defender stat before: " + str(defender.ship_holder.physical_defense_stat))
		defender_physical_defense *= modifier
		print("Defender stat after: " + str(defender_physical_defense))
	
	# BASE CALCULATIONS
	if chosen_move.damage_type == 0: # Physical Damage
		if defender.ship_holder.physical_defense_stat > 0:
			damage_calculated = chosen_move.hull_damage * ((attacker.ship_holder.physical_attack_stat * attacker_morale) / (defender_physical_defense * defender_morale))
			print("Attacker stat: " + str(attacker.ship_holder.physical_attack_stat))
			print("Defender stat: " + str(defender.ship_holder.physical_defense_stat))
	elif chosen_move.damage_type == 1: # Magical Damage
		if defender.ship_holder.magical_defense_stat > 0:
			damage_calculated = chosen_move.hull_damage * ((attacker.ship_holder.magical_attack_stat * attacker_morale) / (defender_magic_defense * defender_morale))
			print("Attacker stat: " + str(attacker.ship_holder.magical_attack_stat))
			print("Defender stat: " + str(defender.ship_holder.magical_defense_stat))
	
	return roundi(damage_calculated)

func _calculate_morale(user) -> float:
	var moral_float: float
	var moral_num = user.ship_holder.crew_morale_stat
	
	moral_float = ((moral_num - 1) / 49) + 1
	
	return moral_float

func _update_enemy_data() -> void:
	current_enemy.ship_holder.cur_hull_health = enemy_cur_hull_hp
	
	if current_enemy.ship_holder.cur_hull_health <= 0: # Temp full heal when dead 
		current_enemy.ship_holder.cur_hull_health = current_enemy.ship_holder.ship_type.base_hull_health_max

func _update_player_data() -> void:
	player.ship_holder.cur_hull_health = player_cur_hull_hp
	player.ship_holder.cur_crew_members = player_cur_crew_members 
	
	if player.ship_holder.cur_hull_health <= 0:
		player.ship_holder.cur_hull_health = player.ship_holder.ship_type.base_hull_health_max

func _end_combat():
	_update_enemy_data()
	_update_player_data()
	if is_fleeing:
		print("Fled combat (Pussy)")
		combat_rewards_given = true
	else:
		_give_rewards()

func _give_rewards():
	print("Player earned XP and GOLD YIPPIE")
	#player.ship_holder.cur_cargo_weight += 1
	combat_rewards_given = true

func _flee_battle() -> void:
	print("Flee battle")
	is_fleeing = true
	has_player_chosen = true

func _decide_move(move_type: int, move_option: int) -> void:
	match move_type:
		1: # Attack Type
			print("Attack move")
			print("Move Option #" + str(move_option))
			
			if player_attack_moves.size() < move_option:
				print("This option does not have a move equipped")
			else:
				match move_option:
					1:
						chosen_player_move = player_attack_moves[0]
						print(player_attack_moves[0].move_name)
					2:
						chosen_player_move = player_attack_moves[1]
						print(player_attack_moves[1].move_name)
					3:
						chosen_player_move = player_attack_moves[2]
						print(player_attack_moves[2].move_name)
					4:
						chosen_player_move = player_attack_moves[3]
						print(player_attack_moves[3].move_name)
				has_player_chosen = true
			
		2: # Defense Type
			print("Defense move")
			print("Move Option #" + str(move_option))
			
			if player_defense_moves.size() < move_option:
				print("This option does not have a move equipped")
			else:
				match move_option:
					1:
						chosen_player_move = player_defense_moves[0]
						print(player_defense_moves[0].move_name)
					2:
						chosen_player_move = player_defense_moves[1]
						print(player_defense_moves[1].move_name)
					3:
						chosen_player_move = player_defense_moves[2]
						print(player_defense_moves[2].move_name)
					4:
						chosen_player_move = player_defense_moves[3]
						print(player_defense_moves[3].move_name)
				
				has_player_chosen = true
		3: # Support Type
			print("Support move")
			print("Move Option #" + str(move_option))
			match move_option:
				1: # Attempt boarding
					print("Attempt Boarding")
				2: # Raise Surrender Flag
					print("Raise Surrender Flag")
				3: # Release Cargo
					print("Release Cargo")
				4: # Use Cargo
					print("Use Cargo")
			has_player_chosen = true

func _randomly_decide_enemy_move() -> void:
	var enemy: EnemyData = current_enemy.enemy_data
	var rng = RandomNumberGenerator.new()
	var attackordefense = rng.randi_range(1, 2)
	var moveNumber
	
	if attackordefense == 1: # Attack move
		if enemy.attack_moves.size() > 0:
			moveNumber = rng.randi_range(0, enemy.attack_moves.size()-1)
			chosen_enemy_move = enemy.attack_moves[moveNumber]
	elif attackordefense == 2: # Defense move
		if enemy.defense_moves.size() > 0:
			moveNumber = rng.randi_range(0, enemy.defense_moves.size()-1)
			chosen_enemy_move = enemy.defense_moves[moveNumber]
	
	if prev_enemy_move != null:
		if prev_enemy_move == chosen_enemy_move:
			if enemy.attack_moves.size() > 1 or enemy.defense_moves.size() > 1:
				print("Same move as previously chosen, choosing again.")
				_randomly_decide_enemy_move()
				return
	
	if chosen_enemy_move == null:
		_randomly_decide_enemy_move()
		return
	
	prev_enemy_move = chosen_enemy_move
	print("Enemy chooses: " + chosen_enemy_move.move_name)



#region State Machine Checks

func _should_enter_combat() -> bool:
	if enter_combat:
		return true
	else: 
		return false

func _entry_finished() -> bool:
	if entry_finished:
		return true
	else: 
		return false

func _player_has_chosen() -> bool:
	if has_player_chosen:
		return true
	else: 
		return false

func _enemy_has_chosen() -> bool:
	if has_enemy_chosen:
		return true
	else: 
		return false

func _actions_processed() -> bool:
	if finished_processing:
		return true
	else: 
		return false

func _combat_finished() -> bool:
	if is_combat_over:
		return true
	else: 
		return false

func _combat_rewards_given() -> bool:
	if combat_rewards_given:
		return true
	else: 
		return false
#endregion

func _on_finish_entry_button_pressed() -> void:
	entry_finished = true
