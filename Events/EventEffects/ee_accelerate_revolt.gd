extends EventEffect
class_name EEAccelerateRevolt

func do_effect() -> void:
	GameState.revolt_accelerated = true
	GameManager.add_to_results_popup("Revolution Accelerated")

func get_effect_desc() -> String:
	return "Accelerate Revolution by 1 Day"
