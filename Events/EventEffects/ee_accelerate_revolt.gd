extends EventEffect
class_name EEAccelerateRevolt

func do_effect() -> void:
	GameState.revolt_accelerated = true

func get_effect_desc() -> String:
	return "Accelerate Revolution by 1 Day"
