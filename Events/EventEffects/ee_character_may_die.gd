extends EventEffect
class_name EECharacterMayDie

# Values
@export var char_name: StringName
@export var chance: int

func do_effect() -> void:
	var char = GameState.get_character_by_name(char_name)
	if char:
		if randi_range(1, 100) <= chance:
			GameManager.kill_character(char)
			GameManager.add_to_results_popup("%s has died" % TextManager.get_text(char_name))
	else:
		print("ERROR: Character name not found!!!")

func get_effect_desc() -> String:
	return "%s may die" % TextManager.get_text(char_name)
