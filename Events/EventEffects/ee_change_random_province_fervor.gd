extends EventEffect
class_name EEChangeRandomFervor

# Values
@export var fervor_change: int = 0

func do_effect() -> void:
	var selected_province = GameState.get_random_province()
	if selected_province.has_army:
		GameManager.add_to_results_popup("Fervor suppressed by Army in %s" % selected_province.province_name)
	
	else:
		selected_province.change_counter(Province.Counter.FERVOR, fervor_change)
		GameManager.add_to_results_popup("%+.f Fervor in %s" % [fervor_change, selected_province.province_name])

func get_effect_desc() -> String:
	return "%+.f Fervor in Random Province" % fervor_change
