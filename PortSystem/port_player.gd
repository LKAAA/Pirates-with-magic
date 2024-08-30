extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_manager: InteractionManager = $InteractionManager

const SPEED = 60.0
const JUMP_VELOCITY = -250.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Interaction
	if Input.is_action_just_pressed("use"):
			print("init interaction")
			interaction_manager.initiate_interaction()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1:
		animated_sprite_2d.flip_h = true
	if direction == -1:
		animated_sprite_2d.flip_h = false
	
	if velocity.x == 0:
		animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Walk")
