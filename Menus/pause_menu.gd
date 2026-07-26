extends Control

signal back_up()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("mouse_mode_updated", on_mouse_mode_updated)
	for sub_menu in get_children():
		if sub_menu.has_signal("back_up"):
			sub_menu.connect("back_up", on_back_up)

func on_mouse_mode_updated(new_mode) -> void:
	if new_mode == GameState.Click.PAUSE:
		set_mouse_behavior_recursive(MOUSE_BEHAVIOR_INHERITED)
	else:
		set_mouse_behavior_recursive(MOUSE_BEHAVIOR_DISABLED)

func _on_return_to_game_button_pressed() -> void:
	back_up.emit()
	play_click()

func on_back_up() -> void:
	$PausePauseMenu.visible = true

func _on_options_button_pressed() -> void:
	$PausePauseMenu.visible = false
	$OptionsMenu.visible = true
	play_click()

# TODO: Improve this! Depending on how we handle the main menu!
func _on_quit_to_menu_button_pressed() -> void:
	GameManager.quit_to_main.emit()
	play_click()

func play_click():
	MusicManager.play_sfx(MusicManager.SFX.CLICK)

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)
