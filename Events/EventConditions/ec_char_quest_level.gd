extends EventCondition
class_name ECCharQuestLevel

@export var char_name: StringName
@export var quest_level: int

func evaluate() -> bool:
	var character = GameState.get_character_by_name(char_name)
	if character and character.has_quest:
		return character.quest_progress == quest_level
	return false

func get_condition_desc() -> String:
	return "%s likes you"
