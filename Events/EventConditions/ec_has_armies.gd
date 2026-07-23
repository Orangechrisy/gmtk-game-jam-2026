extends EventCondition
class_name ECHasArmies

@export var val: int

func evaluate() -> bool:
	return GameState.get_armies_left() >= val

func get_condition_desc() -> String:
	return "Armies left at least %f" % val
