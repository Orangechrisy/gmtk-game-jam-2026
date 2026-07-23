extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("day_updated", on_day_updated)
	GameState.connect("days_to_revolution_updated", on_days_to_revolution_updated)
	GameState.connect("food_updated", on_food_updated)
	GameState.connect("gold_updated", on_gold_updated)
	GameState.connect("common_sentiment_updated", on_common_sentiment_updated)
	GameState.connect("noble_sentiment_updated", on_noble_sentiment_updated)


# UI Updates

func on_day_updated(new_day: int) -> void:
	$DayLabel.text = "DAY " + str(new_day)

func on_days_to_revolution_updated(new_days_left: int) -> void:
	$ToRevolutionLabel.text = "DAYS TO REVOLUTION: " + str(new_days_left)

func on_food_updated(new_food: int) -> void:
	$FoodLabel.text = "Food: " + str(new_food)

func on_gold_updated(new_gold: int) -> void:
	$GoldLabel.text = "Gold: " + str(new_gold)

func on_common_sentiment_updated(new_sentiment: int) -> void:
	$CommonFervorBar.value = new_sentiment

func on_noble_sentiment_updated(new_sentiment: int) -> void:
	$NobleFervorBar.value = new_sentiment
