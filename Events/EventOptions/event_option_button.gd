extends Button

@export var option_name: StringName
@export var option_desc: StringName
@export var conditions: Array[EventCondition]
@export_range(0, 1, 0.01) var success_odds: float
@export var success_outcome: Array[EventEffect]
@export var failure_outcome: Array[EventEffect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_values(option: EventOption):
	option_name = option.option_name
	option_desc = option.option_desc
	conditions = option.conditions
	success_odds = option.success_odds
	success_outcome = option.success_effects
	failure_outcome = option.failure_effects
	option_name = "[b]" + str(success_odds * 100) + "%[/b] " + option_name


func _on_mouse_entered() -> void:
	pass # Replace with function body.
	


func _on_mouse_exited() -> void:
	pass # Replace with function body.
