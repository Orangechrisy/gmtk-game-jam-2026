extends EventEffect
class_name EEChangeArmiesLeft

# Values
@export var armies_change: int = 0

func do_effect() -> void:
	GameState.change_armies_left(armies_change)
	GameManager.add_to_results_popup("%+.f Armies" % armies_change)

func get_effect_desc() -> String:
	var color: String
	if armies_change > 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Armies[/color]" % armies_change
