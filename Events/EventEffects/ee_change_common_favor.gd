extends EventEffect
class_name EEChangeCommonFavor

# Values
@export var favor_change: int = 0

func do_effect() -> void:
	GameState.change_common_sentiment(favor_change)
	GameManager.add_to_results_popup("%+.f Common Favor" % favor_change)

func get_effect_desc() -> String:
	var color: String
	if favor_change > 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Common Favor[/color]" % favor_change
