extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_to_game_button_pressed() -> void:
	self.visible = false


func _on_options_button_pressed() -> void:
	$OptionsMenu.visible = true

# TODO: Implement this! Depending on how we handle the main menu!
func _on_quit_to_menu_button_pressed() -> void:
	pass # Replace with function body.
