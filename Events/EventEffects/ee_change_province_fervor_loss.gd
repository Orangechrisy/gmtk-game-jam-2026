extends EventEffect
class_name EEChangeFervorLoss

# Values
@export var fervor_change: int = 0

func do_effect() -> void:
	GameState.get_current_province().change_counter(Province.Counter.PERMFERVOR, fervor_change)
	GameManager.add_to_results_popup("%+.f Fervor in %s per Day" % [fervor_change, GameState.get_current_province().province_name])

func get_effect_desc() -> String:
	var color: String
	if fervor_change < 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Fervor per Day[/color]" % fervor_change
