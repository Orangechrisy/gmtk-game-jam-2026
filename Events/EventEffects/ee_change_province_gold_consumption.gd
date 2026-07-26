extends EventEffect
class_name EEChangeProvinceGoldConsumption

# Values
@export var gold_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().change_counter(Province.Counter.GOLDC, gold_change)
	GameManager.add_to_results_popup("%+.f Gold Consumption in %s" % [gold_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	return "%+.f Province Gold Consumption" % gold_change
