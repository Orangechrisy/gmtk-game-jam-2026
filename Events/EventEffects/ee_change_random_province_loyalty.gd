extends EventEffect
class_name EEChangeRandomLoyalty

# Values
@export var loyalty_change: int = 0

func do_effect() -> void:
	var selected_province = GameState.get_random_province()
	selected_province.change_counter(Province.Counter.LOYALTY, loyalty_change)
	GameManager.add_to_results_popup("%+.f Loyalty in %s" % [loyalty_change, selected_province.province_name])

func get_effect_desc() -> String:
	var color: String
	if loyalty_change > 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Loyalty in Random Province" % loyalty_change
