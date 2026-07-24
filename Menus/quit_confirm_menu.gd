extends Control

signal back_up()

func _on_back_button_pressed() -> void:
	self.visible = false # TODO: Improve this
	back_up.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
