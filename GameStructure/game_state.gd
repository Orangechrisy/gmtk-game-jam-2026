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

var gold: int = 50
var food: int = 50
var noble_sentiment: int = 100 
var common_sentiment: int = 100
var noble_sentiment_loss: int = -1
var common_sentiment_loss: int = -1

var armies: int = 3
var armies_left: int = 3

@export var provinces: Array[Province]
var current_province: Province

#DEFAULTS
@onready var default_days_to_revolution = days_to_revolution

@onready var default_revolt_stalled = revolt_stalled
@onready var default_revolt_accelerated = revolt_accelerated

@onready var default_gold = gold
@onready var default_food = food
@onready var default_noble_sentiment = noble_sentiment
@onready var default_common_sentiment = common_sentiment

@onready var default_armies = armies

@onready var default_current_province = current_province


func _reset():
	reset_day()
	set_days_to_revolution(default_days_to_revolution)
	revolt_stalled = default_revolt_stalled
	revolt_accelerated = default_revolt_accelerated
	set_gold(default_gold)
	set_food(default_food)
	set_noble_sentiment(default_noble_sentiment)
	noble_sentiment_loss = -1
	set_common_sentiment(default_common_sentiment)
	common_sentiment_loss = -1
	set_armies(default_armies)
	reset_armies_left()
	current_province = default_current_province
	
	for character in GameState.characters:
		character.is_alive = true
		character.quest_progress = 0
	
	MusicManager.start_base_track()

# Characters
@export var characters: Array[Character]

# Endings
@export var ending_names: Array[StringName]
@export var ending_texts: Array[String]

# Events
@export var auto_event_odds: float = 1 # TODO: Set to something reasonable
@export var auto_events: Array[MapEvent]
var current_event: MapEvent

# ENUMS
enum Ending {REVOLUTION, COMMON_ASSASSIN, NOBLE_ASSASSIN, FLEE_DOCK_FAIL, FLEE_DOCK_SUCCESS, FLEE_MINES_FAIL, FLEE_MINES_SUCCESS, FLEE_OUTSKIRTS_FAIL, FLEE_OUTSKIRTS_SUCCESS, SURRENDER_FAIL, SURRENDER_SUCCESS, ABDICATE_FAIL, ABDICATE_SUCCESS}

# MOUSE SHIT
enum Click {BASIC, ARMY_PLACEMENT, EVENT, TUTORIAL, PAUSE, MAIN}
var MouseMode: int = Click.MAIN:
	set(val):
		# if we pause while an event is active, we want to go back to event mouse mode
		if MouseMode == Click.PAUSE and current_event != null:
			MouseMode = Click.EVENT
		else:
			MouseMode = val
		mouse_mode_updated.emit(MouseMode)

# SIGNALS

signal day_updated(new_day)
signal days_to_revolution_updated(new_days_left)
signal gold_updated(new_gold)
signal food_updated(new_food)
signal common_sentiment_updated(new_sentiment)
signal noble_sentiment_updated(new_sentiment)
signal armies_left_updated(new_armies_left)
signal active_events(any_active)
signal mouse_mode_updated(new_mode)
@warning_ignore("unused_signal")
signal province_owner_changed(province: Province)
signal game_ended(ending: int, ending_name: StringName, ending_text: String)
# For event results label
signal show_results_popup()
signal add_to_label(to_add: String)
signal update_tutorial(show: bool)

# Day

func get_day() -> int:
	return day

func update_day() -> void:
	day += 1
	day_updated.emit(day)

func reset_day() -> void:
	day = 0
	day_updated.emit(day)

func any_active_events(val: bool) -> void:
	active_events.emit((val or (current_event != null)))

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

func get_common_sentiment_loss() -> int:
	return common_sentiment_loss

func change_common_sentiment_loss(val: int) -> void:
	common_sentiment_loss += val


# Noble Sentiment

func get_noble_sentiment() -> int:
	return noble_sentiment

func set_noble_sentiment(val: int) -> void:
	noble_sentiment = val
	noble_sentiment_updated.emit(noble_sentiment)

func change_noble_sentiment(val: int) -> void:
	noble_sentiment += val
	noble_sentiment_updated.emit(noble_sentiment)

func get_noble_sentiment_loss() -> int:
	return noble_sentiment_loss

func change_noble_sentiment_loss(val: int) -> void:
	noble_sentiment_loss += val

# Armies

# Controls armies available for this turn
func get_armies_left() -> int:
	return armies_left

func change_armies_left(val: int) -> void:
	armies_left += val
	if armies_left < 0:
		armies_left = 0
	armies_left_updated.emit(armies_left)
	
func reset_armies_left() -> void:
	armies_left = armies
	armies_left_updated.emit(armies_left)

# Controls total army count
func get_armies() -> int:
	return armies

func set_armies(val: int) -> void:
	armies = val
	if armies_left > armies:
		armies_left = armies

func change_armies(val: int) -> void:
	armies += val
	if armies_left > armies:
		armies_left = armies
	if armies < 0:
		armies = 0

# Province check

func get_current_province() -> Province:
	return current_province

func set_current_province(val: Province) -> void:
	current_province = val

func get_current_event() -> MapEvent:
	return current_event

func set_current_event(val: MapEvent) -> void:
	current_event = val

func do_show_tutorial(val: bool) -> void:
	if val:
		MouseMode = Click.TUTORIAL
	else:
		MouseMode = Click.BASIC
	update_tutorial.emit(val)

## Gets a province based on its name
func get_province_by_name(val: String) -> Province:
	for province in provinces:
		if province.province_name == val:
			return province
	
	return null

func reset_outlines():
	for province in provinces:
		province.hide_outline()

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

# Results popup
func reset_results_label() -> void:
	show_results_popup.emit()

func add_to_results_popup(to_add: String) -> void:
	add_to_label.emit(to_add)
	
func emit_ending(ending: int):
	game_ended.emit(ending, ending_names[ending], ending_texts[ending])
