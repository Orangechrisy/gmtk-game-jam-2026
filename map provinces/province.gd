extends Node2D

@export var vertices: PackedVector2Array
@export var province_name: String
@export var province_image: Sprite2D
@export var current_owner: int # not sure what this should be, but could be an enum
@export var potential_events: Array
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
	GameState.day_updated.connect(_on_day_update)

func _on_day_update(new_day):
	base_food = base_food + food_yield - food_consumption
	base_gold = base_gold + gold_yield - gold_consumption
	if fervor > loyalty:
		current_owner = 1
	# change image? update potential events?

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("province ", province_name, " clicked")
