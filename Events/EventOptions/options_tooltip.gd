extends Control

@export var OFFSET: Vector2

## shows what would happen if selected
func set_values(desc: StringName, success_outcome: Array[EventEffect], failure_outcome: Array[EventEffect]):
	%OptionDescription.text = desc
	set_outcome_text(success_outcome, failure_outcome)

## makes the above a bit cleaner
func set_outcome_text(successes: Array[EventEffect], failures: Array[EventEffect]):
	%SuccessEffect.text = "[font_size=20]"
	%FailureEffect.text = "[font_size=20]"
	for succ in successes:
		%SuccessEffect.text += succ.get_effect_desc() + '\n'
	for fail in failures:
		%FailureEffect.text += fail.get_effect_desc() + '\n'
	if failures.size() > 0:
		%SuccessEffect.text = "[font_size=20]On success: \n[color=green]" + %SuccessEffect.text
		%FailureEffect.text = "[font_size=20]On failure: \n[color=red]" + %FailureEffect.text
	%SuccessEffect.text += "[/font_size]"
	%FailureEffect.text += "[/font_size]"

# tracks the mouse position
func _process(_delta: float) -> void:
	if visible:
		position = get_global_mouse_position() + OFFSET
