extends EventEffect
class_name EECharacterDies

# Values
@export var char_name: StringName

func do_effect() -> void:
	var char = GameState.get_character_by_name(char_name)
	if char:
		GameManager.kill_character(char)
		GameManager.add_to_results_popup("%s has died" % TextManager.get_text(char_name))
	else:
		print("ERROR: Character name not found!!!")

func get_effect_desc() -> String:
	return "%s dies" % TextManager.get_text(char_name)
