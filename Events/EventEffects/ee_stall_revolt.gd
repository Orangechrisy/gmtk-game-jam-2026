extends EventEffect
class_name EEStallRevolt

func do_effect() -> void:
	GameState.revolt_stalled = true

func get_effect_desc() -> String:
	return "Stall Revolution by 1 Day"
