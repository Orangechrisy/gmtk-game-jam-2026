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
var noble_sentiment: int # TODO: Maybe make per-character
var common_sentiment: int # TODO: Maybe make per-character

# TODO: Add province tracking

# SIGNALS

signal day_updated(new_day)

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
	
func reduce_days_to_revolution(val: int) -> void:
	days_to_revolution -= val

func reset_days_to_revolution() -> void:
	days_to_revolution = base_days_to_revolution

# Gold

func get_gold() -> int:
	return gold

func set_gold(val: int) -> void:
	gold = val

func change_gold(val: int) -> void:
	gold += val

# Food

func get_food() -> int:
	return food

func set_food(val: int) -> void:
	food = val

func change_food(val: int) -> void:
	food += val
