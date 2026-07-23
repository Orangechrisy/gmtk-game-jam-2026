extends EventEffect
class_name EEChangeGold

# Values
@export var gold_change: int = 0

func do_effect() -> void:
	GameState.change_gold(gold_change)

func get_effect_desc() -> String:
	return "%+.f Gold" % gold_change
