@tool
extends Node2D

@export var vertices: PackedVector2Array
@export var province_name: String
@export var province_image: Sprite2D
@export var curr_owner: int = 0 # not sure what this should be, but could be an enum
@export var potential_events: Array[Resource]
@export_group("Counters")
@export var base_food: float
@export var base_gold: float
@export var food_yield: float:
	set(change):
		food_yield = max(0, food_yield + change)
@export var food_consumption: float:
	set(change):
		food_consumption = max(0, food_consumption + change)
@export var gold_yield: float:
	set(change):
		gold_yield = max(0, gold_yield + change)
@export var gold_consumption: float:
	set(change):
		food_yield = max(0, food_yield + change)
@export var loyalty: int:
	set(change):
		loyalty = max(0, loyalty + change)
@export var fervor: int:
	set(change):
		fervor = max(0, fervor + change)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = vertices
	GameState.connect("day_updated", on_day_updated)

func on_day_updated(new_day):
	base_food = base_food + food_yield - food_consumption
	base_gold = base_gold + gold_yield - gold_consumption
	if fervor > loyalty:
		curr_owner = 1
	# change image?

# try to do the event, based on rng and variables of the province or something
func try_event(event: MapEvent) -> bool:
	# TODO: determine event odds somehow
	return true

# gets the possible events, shuffles them, and tries to fire them, if one fires it returns true
func roll_event_odds() -> bool:
	var possible_events: Array[Resource] = potential_events.filter(func(event): return event.can_appear())
	possible_events.shuffle()
	for event in possible_events:
		if try_event(event):
			return true
	return false

# the province has been clicked on
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("province ", province_name, " clicked")

# TODO: province hover over (to see stats?)
