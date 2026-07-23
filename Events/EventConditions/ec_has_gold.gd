extends EventCondition
class_name ECHasGold

@export var val: int

func evaluate() -> bool:
	return GameState.get_gold() >= val

func get_condition_desc() -> String:
	return "Gold at least %f" % val
