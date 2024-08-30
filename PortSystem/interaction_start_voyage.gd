extends InteractionManager

signal begin_voyage

func receive_interaction() -> void:
	begin_voyage.emit()
