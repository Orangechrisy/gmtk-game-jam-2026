extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainInterface.connect("pause_game", pause_game)
	$PauseMenu.connect("back_up", unpause_game)

## does the necessary actions for pausing the game and opening the pause menu
func pause_game() -> void:
	$PauseMenu.visible = true

## does the necessary actions for unpausing the game and closing the pause menu
func unpause_game() -> void:
	$PauseMenu.visible = false
