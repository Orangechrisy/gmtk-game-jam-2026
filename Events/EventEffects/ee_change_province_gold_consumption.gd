extends EventEffect
class_name EEChangeProvinceGoldConsumption

# Values
@export var gold_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().gold_consumption += gold_change

func get_effect_desc() -> String:
	return "%+.f Province Gold Consumption" % gold_change
