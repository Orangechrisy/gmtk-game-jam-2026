extends EventEffect
class_name EEChangeRandomFervorLoss

# Values
@export var fervor_change: int = 0

func do_effect() -> void:
	var selected_province = GameState.get_random_province()
	if selected_province.has_army:
		GameManager.add_to_results_popup("Fervor suppressed by Army in %s" % selected_province.province_name)
	
	else:
		selected_province.change_counter(Province.Counter.PERMFERVOR, fervor_change)
		GameManager.add_to_results_popup("%+.f Fervor per Day in %s" % [fervor_change, selected_province.province_name])

func get_effect_desc() -> String:
	var color: String
	if fervor_change < 0:
		color = "[color=#517633]"
	else:
		color = "[color=#AD321F]"
	return color+"%+.f Fervor per Day in Random Province[/color]" % fervor_change
