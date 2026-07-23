extends EventCondition
class_name ECHasCommonFavor

@export var val: int

func evaluate() -> bool:
	return GameState.get_common_sentiment() >= val
	
func get_condition_desc() -> String:
	return "Common Favor at least %f" % val
