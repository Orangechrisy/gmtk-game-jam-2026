extends EventEffect
class_name EEChangeProvinceFoodConsumption

# Values
@export var food_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().change_counter(Province.Counter.FOODC, food_change)
	GameManager.add_to_results_popup("%+.f Food Consumption in %s" % [food_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	var color: String
	if food_change < 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Province Food Consumption" % food_change
