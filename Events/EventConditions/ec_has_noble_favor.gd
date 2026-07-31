extends EventCondition
class_name ECHasNobleFavor

@export var val: int

func evaluate() -> bool:
	return GameState.get_noble_sentiment() >= val
	
func get_condition_desc() -> String:
	return "Noble Favor at least %f" % val

func get_unavailable_desc() -> String:
	return "No Noble Favor Remaining."
