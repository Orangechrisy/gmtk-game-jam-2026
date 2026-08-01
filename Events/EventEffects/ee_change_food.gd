extends EventEffect
class_name EEChangeFood

# Values
@export var food_change: int = 0

func do_effect() -> void:
	GameState.change_food(food_change)
	GameManager.add_to_results_popup("%+.f Food" % food_change)

func get_effect_desc() -> String:
	var color: String
	if food_change > 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Food[/color]" % food_change
