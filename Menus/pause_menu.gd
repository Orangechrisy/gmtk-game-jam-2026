extends Control

signal back_up()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sub_menu in get_children():
		if sub_menu.has_signal("back_up"):
			sub_menu.connect("back_up", on_back_up)


func _on_return_to_game_button_pressed() -> void:
	self.visible = false
	back_up.emit()

func on_back_up() -> void:
	$PausePauseMenu.visible = true

func _on_options_button_pressed() -> void:
	$PausePauseMenu.visible = false
	$OptionsMenu.visible = true

# TODO: Improve this! Depending on how we handle the main menu!
func _on_quit_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
