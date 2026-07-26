extends EventEffect
class_name EEChangeArmiesLeft

# Values
@export var armies_change: int = 0

func do_effect() -> void:
	GameState.change_armies_left(armies_change)
	GameManager.add_to_results_popup("%+.f Armies" % armies_change)

func get_effect_desc() -> String:
	return "%+.f Armies" % armies_change
