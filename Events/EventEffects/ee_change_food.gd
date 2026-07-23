extends EventEffect
class_name EEChangeFood

# Values
@export var food_change: int = 0

func do_effect() -> void:
	GameState.change_food(food_change)

func get_effect_desc() -> String:
	return "%+.f Food" % food_change
