extends EventEffect
class_name EEChangeFervor

# Values
@export var fervor_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().fervor += fervor_change
	GameManager.add_to_results_popup("%+.f Fervor in %s" % [fervor_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	return "%+.f Fervor" % fervor_change
