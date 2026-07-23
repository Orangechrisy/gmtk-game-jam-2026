extends Node

# VARIABLES

# Game Structure
@export var active_scene: Node2D

# Data
var day: int = 0
var base_days_to_revolution: int = 30
var days_to_revolution: int = 30

var gold: int
var food: int
var noble_sentiment: int = 100 # TODO: Maybe make per-character
var common_sentiment: int = 100 # TODO: Maybe make per-character

var actions_per_day: int = 3
var actions_left: int = 3

# TODO: Add province tracking
@export var provinces: Array[Node]

@export var auto_event_odds: float = 1 # TODO: Set to something reasonable
@export var auto_events: Array[AutoEvent]

# SIGNALS

signal day_updated(new_day)
signal days_to_revolution_updated(new_days_left)
signal gold_updated(new_gold)
signal food_updated(new_food)
signal common_sentiment_updated(new_sentiment)
signal noble_sentiment_updated(new_sentiment)
signal actions_left_updated(new_actions_left)

# Day

func get_day() -> int:
	return day

func update_day() -> void:
	day += 1
	day_updated.emit(day)

func reset_day() -> void:
	day = 0
	day_updated.emit(day)

# Days to Revolution

func get_days_to_revolution() -> int:
	return days_to_revolution

func set_days_to_revolution(val: int) -> void:
	days_to_revolution = val
	days_to_revolution_updated.emit(days_to_revolution)
	
func reduce_days_to_revolution(val: int) -> void:
	days_to_revolution -= val
	days_to_revolution_updated.emit(days_to_revolution)

func reset_days_to_revolution() -> void:
	days_to_revolution = base_days_to_revolution
	days_to_revolution_updated.emit(days_to_revolution)

# Gold

func get_gold() -> int:
	return gold

func set_gold(val: int) -> void:
	gold = val
	gold_updated.emit(gold)

func change_gold(val: int) -> void:
	gold += val
	gold_updated.emit(gold)

# Food

func get_food() -> int:
	return food

func set_food(val: int) -> void:
	food = val
	food_updated.emit(food)

func change_food(val: int) -> void:
	food += val
	food_updated.emit(food)
	
# Common Sentiment

func get_common_sentiment() -> int:
	return common_sentiment

func set_common_sentiment(val: int) -> void:
	common_sentiment = val
	common_sentiment_updated.emit(common_sentiment)

func change_common_sentiment(val: int) -> void:
	common_sentiment += val
	common_sentiment_updated.emit(common_sentiment)


# Noble Sentiment

func get_noble_sentiment() -> int:
	return noble_sentiment

func set_noble_sentiment(val: int) -> void:
	noble_sentiment = val
	noble_sentiment_updated.emit(noble_sentiment)

func change_noble_sentiment(val: int) -> void:
	noble_sentiment += val
	noble_sentiment_updated.emit(noble_sentiment)

# Actions

func get_actions_left() -> int:
	return actions_left

func reduce_actions_left() -> void:
	actions_left -= 1
	actions_left_updated.emit(actions_left)

func reset_actions_left() -> void:
	actions_left = actions_per_day
	actions_left_updated.emit(actions_left)
