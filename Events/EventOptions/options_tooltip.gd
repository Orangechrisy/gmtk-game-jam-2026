extends Control

@export var texture: Texture2D
@export var desc: StringName
@export var success: StringName
@export var failure: StringName

func set_values(description: StringName, success_outcome: Array[EventEffect], failure_outcome: Array[EventEffect]):
	desc = description
	set_outcome_text(success_outcome, failure_outcome)

func set_outcome_text(successes: Array[EventEffect], failures: Array[EventEffect]):
	success = ""
	failure = ""
	for succ in successes:
		pass
		# TODO: set up EventEffect get function to get text nice there
		# success += succ + '/n'
	for fail in failures:
		pass
		# TODO: same here
