extends EventEffect
class_name EEChangeNobleFavor

# Values
@export var favor_change: int = 0

func do_effect() -> void:
	GameState.change_noble_sentiment(favor_change)

func get_effect_desc() -> String:
	return "%+.f Noble Favor" % favor_change
