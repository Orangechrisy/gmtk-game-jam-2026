extends Resource
class_name Character

@export var char_name: StringName = ""

var is_alive: bool = true
@export var has_quest: bool = false
var quest_progress: int = 0:
	set(change):
		quest_progress += 1
