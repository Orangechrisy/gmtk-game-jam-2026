extends Control

signal back_up()

func _on_back_button_pressed() -> void:
	MusicManager.play_sfx(MusicManager.SFX.CLICK)
	self.visible = false
	back_up.emit()

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)
