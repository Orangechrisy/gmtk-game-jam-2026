extends EventEffect
class_name EEChangeLoyalty

# Values
@export var loyalty_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().loyalty += loyalty_change

func get_effect_desc() -> String:
	return "%+.f Loyalty" % loyalty_change
