extends EventEffect
class_name EEStallRevolt

func do_effect() -> void:
	GameState.revolt_stalled = true
	GameManager.add_to_results_popup("Revolution stalled")

func get_effect_desc() -> String:
	return "[color=#517633]Stall Revolution by 1 Day[/color]"
