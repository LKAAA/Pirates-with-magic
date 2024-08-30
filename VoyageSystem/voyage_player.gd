extends CharacterBody2D


const SPEED = 140.0


func _physics_process(delta: float) -> void:
	var horizontal = Input.get_axis("walk_left", "walk_right")
	var vertical = Input.get_axis("walk_up", "walk_down")
	
	# First check if you are moving in both direction
	if vertical && horizontal: # If you are moving in both direction cap speed at half so it doesnt move at double move speed diagonally
		velocity.x = horizontal * SPEED
		velocity.y = vertical * SPEED
	elif horizontal: # If only moving horizontal you want to slow down vertical to 0
		velocity.x = horizontal * SPEED
		velocity.y = move_toward(velocity.y, 0, SPEED)
	elif vertical: # Same but with vertical and horizontal
		velocity.y = vertical * SPEED
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
