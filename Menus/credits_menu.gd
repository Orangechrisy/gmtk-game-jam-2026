extends Control

signal back_up()

func _on_back_button_pressed() -> void:
	self.visible = false # TODO: Improve
	back_up.emit()
