extends Control

@onready var enemy_label: Label = $EnemyStatusPanel/MarginContainer/enemy_label
@onready var player_label: Label = $PlayerStatusPanel/MarginContainer/player_label
@onready var move_log_label: Label = $PlayerStatusPanel2/MarginContainer/move_log_label

var core

func _ready() -> void:
	core = get_parent()

func _update_labels(enemy: Enemy, player: Player, enemy_max_hull_hp, enemy_cur_hull_hp, player_max_hull_hp, player_cur_hull_hp, player_crew_max, player_crew_cur) -> void:
	enemy_label.text = "%s\nHull HP: %s/%s\nCrew: %s/%s\nSpecial Crew: %s/%s\nTypes: %s \n		%s." % [enemy.enemy_data.enemy_name, enemy_cur_hull_hp, enemy_max_hull_hp, enemy.ship_holder.cur_crew_members, enemy.ship_holder.ship_type.crew_member_max, enemy.ship_holder.cur_special_crew_members, enemy.ship_holder.ship_type.special_crew_member_max, enemy.enemy_data.type_1, enemy.enemy_data.type_2]
	player_label.text = "Player Ship\nHull HP: %s/%s\nCrew: %s/%s\nSpecial Crew: %s/%s\nTypes: %s \n	%s." % [player_cur_hull_hp, player_max_hull_hp, player_crew_cur, player_crew_max, player.ship_holder.cur_special_crew_members, player.ship_holder.ship_type.special_crew_member_max, player.type_1, player.type_2]

func _update_move_log(player_move, enemy_move, enemy_damage_dealt, player_damage_dealt):
	move_log_label.text = ""
	if player_move:
		move_log_label.text += "Player used: %s" % [player_move.move_name]
		if player_move is DefenseMoveData:
			move_log_label.text += "\nIt healed %s Hull Health." % [player_move.hull_repair_amount]
		elif player_move is AttackMoveData:
			if player_damage_dealt == 0 or not player_damage_dealt:
				move_log_label.text += "\nIt missed."
			else:
				move_log_label.text += "\nIt did %s damage." % [player_damage_dealt]
	else:
		move_log_label.text += "Support moves are not implemented yet.\nOr you failed at fleeing. Pussy."
	
	if enemy_move:
		move_log_label.text += "\n\nEnemy used: %s" % [enemy_move.move_name]
		if enemy_move is DefenseMoveData:
			move_log_label.text += "\nIt healed %s Hull Health." % [enemy_move.hull_repair_amount]
		elif enemy_move is AttackMoveData:
			if enemy_damage_dealt == 0 or not enemy_damage_dealt:
				move_log_label.text += "\nIt missed."
			else:
				move_log_label.text += "\nIt did %s damage." % [enemy_damage_dealt]
