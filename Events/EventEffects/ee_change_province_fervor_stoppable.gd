extends EventEffect
class_name EEChangeFervorStoppable

# Values
@export var fervor_change: int = 0

func do_effect() -> void:
	if GameState.get_current_province().has_army:
		GameManager.add_to_results_popup("Fervor suppressed by Army in %s" % GameState.get_current_province().province_name)
	else:
		GameState.get_current_province().change_counter(Province.Counter.FERVOR, fervor_change)
		GameManager.add_to_results_popup("%+.f Fervor in %s" % [fervor_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	var color: String
	if fervor_change < 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Fervor[/color]" % fervor_change
