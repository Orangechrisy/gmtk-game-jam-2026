extends Control

signal back_up()

func _on_back_button_pressed() -> void:
	play_click()
	self.visible = false
	back_up.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func play_click():
	MusicManager.play_sfx(MusicManager.SFX.CLICK)

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)
