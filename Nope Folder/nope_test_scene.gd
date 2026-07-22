extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("day_updated", on_day_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	GameManager.end_day()

func on_day_updated(new_day: int) -> void:
	$DayLabel.text = "DAY " + str(new_day)
