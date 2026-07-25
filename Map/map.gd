extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MainInterface.connect("pause_game", pause_game)
	%MainInterface.connect("unpause_game", unpause_game)
	%PauseMenu.connect("back_up", unpause_game)
	GameManager.connect("restart", reset)
	GameManager.connect("quit_to_main", exit)
	MusicManager.start_base_track()
	for child in $Provinces.get_children():
		GameState.provinces.append(child)

## does the necessary actions for pausing the game and opening the pause menu
func pause_game() -> void:
	%PauseMenu.visible = true
	GameState.MouseMode = GameState.Click.PAUSE

## does the necessary actions for unpausing the game and closing the pause menu
func unpause_game() -> void:
	%PauseMenu.visible = false
	GameState.MouseMode = GameState.Click.BASIC

## sets things up for base game
func reset() -> void:
	%MainInterface.visible = true
	%PauseMenu.visible = false
	%MainMenu.visible = false

## exits to main menu
func exit() -> void:
	%MainInterface.visible = false
	%PauseMenu.visible = false
	%MainMenu.visible = true
