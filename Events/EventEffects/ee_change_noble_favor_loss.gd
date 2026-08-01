extends EventEffect
class_name EEChangeNobleFavorLoss

# Values
@export var favor_change: int = 0

func do_effect() -> void:
	GameState.change_noble_sentiment_loss(favor_change)
	GameManager.add_to_results_popup("%+.f Noble Favor per Day" % favor_change)

func get_effect_desc() -> String:
	var color: String
	if favor_change > 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Noble Favor per Day[/color]" % favor_change
