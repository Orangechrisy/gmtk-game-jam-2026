extends EventEffect
class_name EEChangeLoyalty

# Values
@export var loyalty_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().change_counter(Province.Counter.LOYALTY, loyalty_change)
	GameManager.add_to_results_popup("%+.f Loyalty in %s" % [loyalty_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	return "%+.f Loyalty" % loyalty_change
