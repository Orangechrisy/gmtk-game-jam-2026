extends Sprite2D

func _ready() -> void:
	GameState.connect("update_tutorial", on_update_tutorial)
	
func on_update_tutorial(show: bool) -> void:
	visible = show
	
func _on_tutorial_start_button_pressed() -> void:
	GameManager.update_tutorial(false)
