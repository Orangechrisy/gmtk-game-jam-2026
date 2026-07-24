extends EventEffect
class_name EECommonAssassinChance

# Values
@export var favor_threshold: int = 20

func do_effect() -> void:
	var favor = GameState.get_common_sentiment()
	if favor <= favor_threshold:
		var death_odds = 5 + (favor_threshold - favor)
		if randi_range(1, 100) > death_odds:
			pass # TODO: KILL

func get_effect_desc() -> String:
	return "Chance of Assassination if Common Favor is below %f" % favor_threshold
