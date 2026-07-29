extends EventEffect
class_name EENoArmiesAlloweed


func do_effect() -> void:
	GameState.get_current_province().can_have_army = false
	GameManager.add_to_results_popup("Cannot place Armies in %s" % GameState.get_current_province())

func get_effect_desc() -> String:
	return "Armies banned in %s" % GameState.get_current_province()
