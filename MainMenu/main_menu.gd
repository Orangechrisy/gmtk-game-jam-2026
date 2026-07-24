extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sub_menu in get_children():
		if sub_menu.has_signal("back_up"):
			sub_menu.connect("back_up", on_back_up)

func _on_start_game_button_pressed() -> void:
	pass # Replace with function body.


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
