extends Resource
class_name AutoEvent
# Class for events which fire between days automatically - player has no agency

# Variables
@export var event_name: StringName = ""
@export var portrait: Texture2D # TODO: Unnecessary?
@export var event_desc: String = ""
@export var one_time: bool = false
var has_happened: bool = false

@export var conditions: Array[EventCondition]
@export var effects: Array[EventEffect]

# Helpers
func get_event_name() -> StringName:
	return event_name

func get_event_desc() -> String:
	return event_desc
	

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
	do_effects()
	
	if one_time:
		has_happened = true

# do_effects: Fires all effects
func do_effects() -> void:
	for effect in effects:
		effect.do_effect()
