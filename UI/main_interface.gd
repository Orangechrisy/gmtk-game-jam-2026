extends Control

signal pause_game()

# Variables
var army_placing_mode: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("day_updated", on_day_updated)
	GameState.connect("active_events", show_end_day)
	GameState.connect("days_to_revolution_updated", on_days_to_revolution_updated)
	GameState.connect("food_updated", on_food_updated)
	GameState.connect("gold_updated", on_gold_updated)
	GameState.connect("common_sentiment_updated", on_common_sentiment_updated)
	GameState.connect("noble_sentiment_updated", on_noble_sentiment_updated)
	GameState.connect("armies_left_updated", on_armies_left_updated)

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

func on_armies_left_updated(new_armies_left: int) -> void:
	$PlaceArmyLabel.text = "ARMIES LEFT: " + str(new_armies_left)


func _on_menu_button_pressed() -> void:
	pause_game.emit()

## Handles army placement button
func _on_place_army_button_pressed() -> void:
	if GameState.get_armies_left() <= 0: return
	
	if not army_placing_mode:
		$PlaceArmyButton.text = "CANCEL"
		army_placing_mode = true
		pass
	
	else:
		$PlaceArmyButton.text = "PLACE ARMY"
		army_placing_mode = false
		pass

## adjust end day button visibility (val = true means there is an active event)
func show_end_day(val: bool) -> void:
	$EndDay.visible = not val

## ends the day when pressed
func _on_end_day_pressed() -> void:
	$EndDay.visible = false
	GameManager.end_day()
