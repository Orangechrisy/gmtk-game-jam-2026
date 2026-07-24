extends EventCondition
class_name ECHasProvince

@export var province_name: String

func evaluate() -> bool:
	var province = GameState.get_province_by_name(province_name)
	if province:
		return province.curr_owner == 0
	return false

func get_condition_desc() -> String:
	return "Province of %s is loyal" % province_name
