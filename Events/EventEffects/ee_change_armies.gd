extends EventEffect
class_name EEChangeArmies

# Values
@export var armies_change: int = 0

func do_effect() -> void:
	GameState.change_armies(armies_change)
	GameManager.add_to_results_popup("%+.f Armies (Permanent)" % armies_change)

func get_effect_desc() -> String:
	return "%+.f Armies (Permanent)" % armies_change
