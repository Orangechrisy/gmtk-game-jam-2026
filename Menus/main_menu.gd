extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sub_menu in get_children():
		if sub_menu.has_signal("back_up"):
			sub_menu.connect("back_up", on_back_up)

func _on_start_game_button_pressed() -> void:
	GameManager.reset()
	# TODO: more interesting transition.
	# map there the whole time (main menu as child to it) and this just hides the main menu
	# and emits a signal for the map to show things with a nice transition?
	# like maybe the map when main menu active blurred? idk
	get_tree().change_scene_to_file("res://Map/map.tscn")


func _on_options_button_pressed() -> void:
	$MainMainMenu.visible = false
	$OptionsMenu.visible = true


func _on_credits_button_pressed() -> void:
	$MainMainMenu.visible = false
	$CreditsMenu.visible = true


func _on_quit_game_button_pressed() -> void:
	$MainMainMenu.visible = false
	$QuitConfirmMenu.visible = true

func on_back_up() -> void:
	$MainMainMenu.visible = true
