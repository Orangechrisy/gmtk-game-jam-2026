extends EventEffect
class_name EEChangeRandomFervor

# Values
@export var fervor_change: int = 0

func do_effect() -> void:
	GameState.get_random_province().fervor += fervor_change

func get_effect_desc() -> String:
	return "%+.f Fervor in Random Province" % fervor_change
