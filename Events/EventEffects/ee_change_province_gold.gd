extends EventEffect
class_name EEChangeProvinceGold

# Values
@export var gold_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().change_counter(Province.Counter.GOLDY, gold_change)
	GameManager.add_to_results_popup("%+.f Gold in %s" % [gold_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	var color: String
	if gold_change > 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Province Gold Yield[/color]" % gold_change
