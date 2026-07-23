extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	$OptionsMenu.visible = true


func _on_credits_button_pressed() -> void:
	$CreditsMenu.visible = true


func _on_quit_game_button_pressed() -> void:
	$QuitConfirmMenu.visible = true
