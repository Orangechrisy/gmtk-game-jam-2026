extends EventEffect
class_name EERunEnding

# Values
@export var ending: GameState.Ending
@export var new_quest_level: int

func do_effect() -> void:
	pass # TODO: Implement ending functionality!

func get_effect_desc() -> String:
	return "Ends your reign"
