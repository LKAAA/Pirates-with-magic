extends Node2D

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

const BATTLE_SCENE = preload("res://BattleScene.tscn")
const PORT_SCENE = preload("res://PortSystem/port_scene.tscn")
const VOYAGE_SCENE = preload("res://VoyageSystem/voyage_scene.tscn")

var cur_battle_scene
var cur_port_scene
var cur_voyage_scene

var enter_voyage: bool
var enter_battle: bool
var leave_battle: bool
var return_to_port: bool
var lost_battle: bool
var reset_defeat: bool

var voyage_position: Vector2
var cur_enemy: Enemy

func _ready() -> void:
	_instantiate_port_scene()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("begin_battle"):
		_set_out_on_voyage()

func _instantiate_port_scene() -> void:
	cur_port_scene = PORT_SCENE.instantiate()
	add_child(cur_port_scene)
	cur_port_scene.reparent(sub_viewport)
	get_tree().get_first_node_in_group("voyage_interaction").begin_voyage.connect(_set_out_on_voyage)

func _instantiate_voyage_scene() -> void:
	cur_voyage_scene = VOYAGE_SCENE.instantiate()
	add_child(cur_voyage_scene)
	cur_voyage_scene.reparent(sub_viewport)
	cur_voyage_scene.begin_battle.connect(_begin_battle)
	cur_voyage_scene.return_to_port.connect(_enter_port)

func _set_out_on_voyage() -> void:
	print("Setting out on voyage")
	cur_port_scene.queue_free()
	_instantiate_voyage_scene()
	enter_voyage = true

func _begin_battle(enemy: Enemy) ->  void:
	cur_enemy = enemy
	cur_enemy.reparent(self)
	var vplayer = get_tree().get_first_node_in_group("voyage_player")
	voyage_position = vplayer.position
	cur_voyage_scene.queue_free()
	cur_battle_scene = BATTLE_SCENE.instantiate()
	add_child(cur_battle_scene)
	cur_battle_scene.battle_ended.connect(_leave_battle)
	
	enter_battle = true

func _enter_port() -> void:
	cur_voyage_scene.queue_free()
	_instantiate_port_scene()
	return_to_port = true

func _leave_battle(battle_end_state: int) -> void:
	cur_battle_scene.queue_free()
	_instantiate_voyage_scene()
	
	match battle_end_state:
		0:
			cur_enemy.queue_free()
			leave_battle = true
			var vplayer = get_tree().get_first_node_in_group("voyage_player")
			vplayer.position = voyage_position
		1:
			lost_battle = true
			print("player_died")
		2:
			cur_enemy.reparent(cur_voyage_scene)
			var vplayer = get_tree().get_first_node_in_group("voyage_player")
			vplayer.position = voyage_position
			leave_battle = true

#region State Machine Functions

func _should_enter_voyage() -> bool:
	if enter_voyage:
		return true
	else: 
		return false

func _should_enter_battle() -> bool:
	if enter_battle:
		return true
	else:
		return false

func _should_leave_battle() -> bool:
	if leave_battle:
		return true
	else:
		return false

func _should_return_to_port() -> bool:
	if return_to_port:
		return true
	else:
		return false

func _player_lost_battle() -> bool:
	if lost_battle:
		return true
	else:
		return false

func _reset_from_defeat() -> bool:
	if reset_defeat:
		return true
	else:
		return false
#endregion
