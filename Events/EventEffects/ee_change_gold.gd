extends EventEffect
class_name EEChangeGold

# Values
@export var gold_change: int = 0

func do_effect() -> void:
	GameState.change_gold(gold_change)
	GameManager.add_to_results_popup("%+.f Gold" % gold_change)

func get_effect_desc() -> String:
	var color: String
	if gold_change > 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Gold[/color]" % gold_change
