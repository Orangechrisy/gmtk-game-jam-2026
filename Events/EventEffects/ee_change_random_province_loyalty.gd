extends EventEffect
class_name EEChangeRandomLoyalty

# Values
@export var loyalty_change: int = 0

func do_effect() -> void:
	GameState.get_random_province().loyalty += loyalty_change

func get_effect_desc() -> String:
	return "%+.f Loyalty in Random Province" % loyalty_change
