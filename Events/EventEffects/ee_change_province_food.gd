extends EventEffect
class_name EEChangeProvinceFood

# Values
@export var food_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().food_yield += food_change
	GameManager.add_to_results_popup("%+.f Food in %s" % [food_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	return "%+.f Province Food Yield" % food_change
