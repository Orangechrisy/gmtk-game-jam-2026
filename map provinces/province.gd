extends Node2D
class_name Province

@export var vertices: PackedVector2Array
@export var province_name: String
@export var province_image: Sprite2D
@export var curr_owner: int = 0 # not sure what this should be, but could be an enum
@export var potential_events: Array[Resource]
@export var event_location: Vector2
@export var TOOLTIP_TIME_DELAY: float = 0.5

@export_group("Counters")
@export var food_yield: float
@export var food_consumption: float
@export var gold_yield: float
@export var gold_consumption: float
@export var loyalty: int
@export var fervor: int

var event_present: MapEvent
var province_tooltip: Control
var tween: Tween


enum {FOODY, FOODC, GOLDY, GOLDC, LOYALTY, FERVOR}

# Signals
signal province_owner_changed(province: Province)

var has_army: bool:
	set(val):
		if val == false or curr_owner == 0: # No placing armies in unowned provinces
			has_army = val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = vertices
	$EventPopup.visible = false
	$EventPopup.position = event_location
	$TooltipTimer.timeout.connect(_on_timer_timeout)
	GameState.connect("day_updated", on_day_updated)
	$ProvinceTooltip.update_values()

func on_day_updated(new_day):
	if fervor > loyalty:
		curr_owner = 1
	# change image?

# update the event popup and if the province has an event currently
func update_events(event: MapEvent, show: bool):
	$EventPopup.visible = show
	event_present = event

# Helper functions
func get_curr_owner() -> int:
	return curr_owner

func set_curr_owner(new_value: int) -> void:
	curr_owner = new_value
	province_owner_changed.emit(self)
	
func calculate_food() -> int:
	return food_yield - food_consumption

func calculate_gold() -> int:
	return gold_yield - gold_consumption

func change_counter(counter: int, change: float) -> void:
	match counter:
		FOODY:
			food_yield = max(0, food_yield + change)
			$ProvinceTooltip.update_values()
		FOODC:
			food_consumption = max(0, food_consumption + change)
			$ProvinceTooltip.update_values()
		GOLDY:
			gold_yield = max(0, gold_yield + change)
			$ProvinceTooltip.update_values()
		GOLDC:
			gold_consumption = max(0, gold_consumption + change)
			$ProvinceTooltip.update_values()
		LOYALTY:
			loyalty = max(0, loyalty + change)
			$ProvinceTooltip.update_values()
		FERVOR:
			fervor = max(0, fervor + change)
			$ProvinceTooltip.update_values()

## try to do the event, based on rng and variables of the province or something
func try_event(event: MapEvent) -> bool:
	# TODO: determine event odds somehow
	return true

## gets the possible events, shuffles them, and tries to fire them, if one fires it returns true
func roll_event_odds() -> bool:
	var possible_events: Array[Resource] = potential_events.filter(func(event): return event.can_appear())
	possible_events.shuffle()
	for event in possible_events:
		if try_event(event):
			update_events(event, true)
			return true
	return false

## the province has been clicked on
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("province ", province_name, " clicked")
		if event_present:
			update_events(event_present, false)
			GameManager.update_current_province(self)
			EventScene.event_selected(event_present)
			var tween = get_tree().create_tween()
			tween.tween_property($ProvinceTooltip, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.05)
		else:
			roll_event_odds()

func _on_area_2d_mouse_entered() -> void:
	if not GameState.get_current_event():
		$TooltipTimer.start(TOOLTIP_TIME_DELAY)

func _on_area_2d_mouse_exited() -> void:
	$TooltipTimer.stop()
	if tween: 
		tween.kill()
	tween = create_tween()
	tween.tween_property($ProvinceTooltip, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.05)

func _on_timer_timeout() -> void:
	tween = create_tween()
	tween.tween_property($ProvinceTooltip, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
