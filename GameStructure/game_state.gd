extends Node

# VARIABLES

# Game Structure
@export var active_scene: Node2D

# Data
var day: int = 0
var base_days_to_revolution: int = 30
var days_to_revolution: int = 30

var revolt_stalled: bool = false
var revolt_accelerated: bool = false

var gold: int
var food: int
var noble_sentiment: int = 100 # TODO: Maybe make per-character
var common_sentiment: int = 100 # TODO: Maybe make per-character

var armies: int = 3
var armies_left: int = 3

# TODO: Add province tracking
@export var provinces: Array[Province]
var current_province: Province

# Characters
@export var characters: Array[Character]

@export var auto_event_odds: float = 1 # TODO: Set to something reasonable
@export var auto_events: Array[AutoEvent]

# SIGNALS

signal day_updated(new_day)
signal days_to_revolution_updated(new_days_left)
signal gold_updated(new_gold)
signal food_updated(new_food)
signal common_sentiment_updated(new_sentiment)
signal noble_sentiment_updated(new_sentiment)

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

# Armies

# Controls armies available for this turn
func get_armies_left() -> int:
	return armies_left

func change_armies_left(val: int) -> void:
	armies_left += val
	
func reset_armies_left() -> void:
	armies_left = armies

# Controls total army count
func get_armies() -> int:
	return armies

func change_armies(val: int) -> void:
	armies += val
	if armies < 0:
		armies = 0

# Province check

func get_current_province() -> Province:
	return current_province

func set_current_province(val: Province) -> void:
	current_province = val

## Gets a province based on its name
func get_province_by_name(val: String) -> Province:
	for province in provinces:
		if province.province_name == val:
			return province
	
	return null

func get_random_province() -> Province:
	provinces.shuffle()
	for province in provinces:
		if province.curr_owner == 0:
			return province
	
	return null # Somehow we don't have provinces

func get_character_by_name(val: StringName) -> Character:
	for character in characters:
		if character.char_name == val:
			return character
			
	return null
