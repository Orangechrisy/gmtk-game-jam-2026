extends Control
class_name GameOverMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("game_ended", on_game_ended)

func on_game_ended(ending: int, ending_title: StringName, ending_desc: String) -> void:
	$AnimationPlayer.play("fade_in")
	$EndingTitleLabel.text = TextManager.get_text(ending_title)
	$EndingBodyLabel.text = TextManager.get_text(ending_desc)
	$EndingScoreLabel.text = str(GameManager.calculate_score(ending))
	
	# Handle music (very awkward)
	match ending:
		GameState.Ending.FLEE_DOCK_SUCCESS:
			MusicManager.play_ending_song(MusicManager.ENDINGTYPE.GOOD)
		GameState.Ending.FLEE_MINES_SUCCESS:
			MusicManager.play_ending_song(MusicManager.ENDINGTYPE.GOOD)
		GameState.Ending.FLEE_OUTSKIRTS_SUCCESS:
			MusicManager.play_ending_song(MusicManager.ENDINGTYPE.GOOD)
		GameState.Ending.SURRENDER_SUCCESS:
			MusicManager.play_ending_song(MusicManager.ENDINGTYPE.GOOD)
		GameState.Ending.ABDICATE_SUCCESS:
			MusicManager.play_ending_song(MusicManager.ENDINGTYPE.GOOD)
		_:
			MusicManager.play_ending_song(MusicManager.ENDINGTYPE.BAD)


func _on_to_menu_button_pressed() -> void:
	$AnimationPlayer.play("RESET")
	MusicManager.play_sfx(MusicManager.SFX.CLICK)
	GameManager.quit_to_main.emit()

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)
