extends EventEffect
class_name EEChangeFervor

# Values
@export var fervor_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().fervor += fervor_change

func get_effect_desc() -> String:
	return "%+.f Fervor" % fervor_change
