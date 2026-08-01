extends EventEffect
class_name EECharacterQuest

# Values
@export var char_name: StringName
@export var new_quest_level: int

func do_effect() -> void:
	var char = GameState.get_character_by_name(char_name)
	if char and char.has_quest:
		char.quest_progress = new_quest_level
	else:
		print("ERROR: Character name not found!!!")

func get_effect_desc() -> String:
	return "[color=#517633]%s may be happy[/color]" % TextManager.get_text(char_name)
