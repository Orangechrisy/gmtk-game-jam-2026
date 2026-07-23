extends Resource
class_name MapEvent
# Class for events which appear on the map - player can select and pick an option

# Variables
@export var event_name: StringName = ""
@export var portrait: Texture2D
@export var character_name: StringName = ""
@export var dialogue: Array[String] # TODO: Replace with something
@export var one_time: bool = false
var has_happened: bool = false

@export var conditions: Array[EventCondition]
@export var options: Array[EventOption]

# Helpers
func get_event_name() -> StringName:
	return event_name

func get_event_dialogue() -> Array[String]:
	return dialogue

func get_options() -> Array[EventOption]:
	return options

func get_portrait() -> Texture2D:
	return portrait

func get_character_name() -> StringName:
	return character_name

# Functionality

# can_appear: Checks whether event is able to appear
func can_appear() -> bool:
	for condition in conditions:
		if not condition.evaluate():
			return false
	
	if one_time and has_happened:
		return false
	
	return true

# Controls one-time events
# TODO: Could be done better?
func event_fired() -> void:
	if one_time:
		has_happened = true
