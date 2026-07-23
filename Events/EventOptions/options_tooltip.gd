extends Control

@export var OFFSET: Vector2

func set_values(desc: StringName, success_outcome: Array[EventEffect], failure_outcome: Array[EventEffect]):
	%OptionDescription.text = desc
	#set_outcome_text(success_outcome, failure_outcome)

func set_outcome_text(successes: Array[EventEffect], failures: Array[EventEffect]):
	#%SuccessEffect.text = "succ\n"
	#%FailureEffect.text = "fail\n"
	for succ in successes:
		pass
		# TODO: set up EventEffect get function to get text nice there
		# success += succ + '/n'
	for fail in failures:
		pass
		# TODO: same here

func _process(delta: float) -> void:
	if visible:
		position = get_global_mouse_position() + OFFSET
