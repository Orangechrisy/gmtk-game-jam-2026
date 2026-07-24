extends EventEffect
class_name EEChangeProvinceFood

# Values
@export var food_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().food_yield += food_change

func get_effect_desc() -> String:
	return "%+.f Province Food Yield" % food_change
