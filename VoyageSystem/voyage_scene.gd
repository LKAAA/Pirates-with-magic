extends Node2D

signal begin_battle
signal return_to_port
@onready var training_dummy: Enemy = $TrainingDummy

var entered: bool
var entered2: bool

func _physics_process(delta: float) -> void:
	if entered:
		if Input.is_action_just_pressed("use"):
			begin_battle.emit(training_dummy)
	if entered2: 
		if Input.is_action_just_pressed("use"):
			return_to_port.emit()

func _on_x_spot_1_body_entered(body: Node2D) -> void:
	print("1")
	entered = true

func _on_x_spot_1_body_exited(body: Node2D) -> void:
	print("No 1")
	entered = false


func _on_x_spot_2_body_entered(body: Node2D) -> void:
	print("2")
	entered2 = true


func _on_x_spot_2_body_exited(body: Node2D) -> void:
	print("No 2")
	entered2 = false
