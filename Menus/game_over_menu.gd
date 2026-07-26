extends Node2D
class_name GameOverMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("game_ended", on_game_ended)

func on_game_ended(ending: int, ending_title: StringName, ending_desc: String) -> void:
	$AnimationPlayer.play("fade_in")
	$EndingTitleLabel.text = ending_title
	$EndingBodyLabel.text = ending_desc
	$EndingScoreLabel.text = str(GameManager.calculate_score(ending))


func _on_to_menu_button_pressed() -> void:
	$AnimationPlayer.play("RESET")
	GameManager.quit_to_main.emit()
