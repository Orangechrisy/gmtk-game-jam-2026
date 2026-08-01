extends Control

@export var OFFSET: Vector2

## shows what would happen if selected
func set_values(desc: StringName, success_outcome: Array[EventEffect], failure_outcome: Array[EventEffect], unavailable: bool):
	%OptionDescription.text = desc
	if !unavailable:
		set_outcome_text(success_outcome, failure_outcome)
	else:
		%SuccessEffect.hide()
		%FailureEffect.hide()

## makes the above a bit cleaner
func set_outcome_text(successes: Array[EventEffect], failures: Array[EventEffect]):
	%SuccessEffect.text = ""
	%FailureEffect.text = ""
	
	if successes.size() == 0:
		%SuccessEffect.text += "Nothing happens"
	else:
		for succ in successes:
			%SuccessEffect.text += succ.get_effect_desc() + '\n'
	%SuccessEffect.text.trim_suffix("\n")
	for fail in failures:
		%FailureEffect.text += fail.get_effect_desc() + '\n'
	%FailureEffect.text.trim_suffix("\n")
	if failures.size() > 0:
		%SuccessEffect.text = "[font_size=30][u]On success:[/u][/font_size] \n[color=#517633]" + %SuccessEffect.text
		%FailureEffect.text = "\n[font_size=30][u]On failure:[/u][/font_size] \n[color=AD321F]" + %FailureEffect.text
		%FailureEffect.show()
	else:
		%FailureEffect.hide()
	%SuccessEffect.show()
	%SuccessEffect.get_parent().size = %SuccessEffect.get_minimum_size()

# tracks the mouse position
func _process(_delta: float) -> void:
	if visible:
		position = get_global_mouse_position() + OFFSET
