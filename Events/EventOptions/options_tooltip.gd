extends Control

@export var OFFSET: Vector2

func set_values(desc: StringName, success_outcome: Array[EventEffect], failure_outcome: Array[EventEffect]):
	%OptionDescription.text = desc
	set_outcome_text(success_outcome, failure_outcome)

func set_outcome_text(successes: Array[EventEffect], failures: Array[EventEffect]):
	%SuccessEffect.text = ""
	%FailureEffect.text = ""
	for succ in successes:
		%SuccessEffect.text += succ.get_effect_desc() + '\n'
	for fail in failures:
		%FailureEffect.text += fail.get_effect_desc() + '\n'
	if failures.size() > 0:
		%SuccessEffect.text = "[color=green]" + %SuccessEffect.text + "[/color]"
		%FailureEffect.text = "[color=red]" + %FailureEffect.text + "[/color]"
	
func _process(delta: float) -> void:
	if visible:
		position = get_global_mouse_position() + OFFSET
