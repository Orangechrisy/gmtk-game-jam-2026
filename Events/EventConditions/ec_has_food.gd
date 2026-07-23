extends EventCondition
class_name ECHasFood

@export var val: int

func evaluate() -> bool:
	return GameState.get_food() >= val

func get_condition_desc() -> String:
	return "Food at least %f" % val
