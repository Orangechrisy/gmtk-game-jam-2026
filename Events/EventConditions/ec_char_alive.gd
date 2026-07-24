extends EventCondition
class_name ECCharAlive

@export var char_name: StringName

func evaluate() -> bool:
	var character = GameState.get_character_by_name(char_name)
	if character:
		return character.is_alive
	return false

func get_condition_desc() -> String:
	return "%s is alive" % char_name
