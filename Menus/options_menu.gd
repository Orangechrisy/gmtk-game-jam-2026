extends CanvasLayer

signal back_up()

func _on_back_button_pressed() -> void:
	play_click()
	self.visible = false
	back_up.emit()

func play_click():
	MusicManager.play_sfx(MusicManager.SFX.CLICK)

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)

func _on_mainvolume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)

func _on_musicvolume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)

func _on_sfxvolume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
