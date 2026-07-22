extends Resource
class_name EventOption

# Variables
@export var option_name: StringName = ""
@export var option_desc: String = ""
@export var conditions: Array[EventCondition]
@export var success_odds: float = 1 # TODO: Add way to alter this?

@export var success_effects: Array[EventEffect]
@export var failure_effects: Array[EventEffect]

# Helper functions
func get_option_name() -> StringName:
	return option_name

func get_option_desc() -> String:
	return option_desc

# Functionality

func calculate_available() -> bool:
	for condition in conditions:
		if not condition.evaluate():
			return false
	
	return true
	
func calculate_success() -> void:
	if success_odds == 1:
		do_success_effects()
	
	else:
		if randf_range(0, 1) <= success_odds:
			do_success_effects()
		else:
			do_failure_effects()

func do_success_effects() -> void:
	for effect in success_effects:
		effect.do_effect()

func do_failure_effects() -> void:
	for effect in failure_effects:
		effect.do_effect()
