extends InteractionManager

signal shipyard_interaction

func receive_interaction() -> void:
	shipyard_interaction.emit()
