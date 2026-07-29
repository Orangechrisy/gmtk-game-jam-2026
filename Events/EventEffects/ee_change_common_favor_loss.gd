extends EventEffect
class_name EEChangeCommonFavorLoss

# Values
@export var favor_change: int = 0

func do_effect() -> void:
	GameState.change_common_sentiment_loss(favor_change)
	GameManager.add_to_results_popup("%+.f Common Favor per Day" % favor_change)

func get_effect_desc() -> String:
	return "%+.f Common Favor per Day" % favor_change
