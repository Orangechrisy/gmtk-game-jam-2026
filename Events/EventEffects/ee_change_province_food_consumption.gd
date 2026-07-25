extends EventEffect
class_name EEChangeProvinceFoodConsumption

# Values
@export var food_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().food_consumption += food_change

func get_effect_desc() -> String:
	return "%+.f Province Food Consumption" % food_change
