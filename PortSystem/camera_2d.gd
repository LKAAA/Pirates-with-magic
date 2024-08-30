extends Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		self.zoom -= Vector2(0.02,0.02)
	if Input.is_action_just_pressed("ui_right"):
		self.zoom += Vector2(0.02,0.02)
