@tool
extends Node2D
class_name water

@export var inital_pos: Vector2 = Vector2.ZERO
@export var water_size: Vector2 = Vector2(8.0, 16.0)
@export var surface_pos_y: float = 0.5
@export_range(2, 2000) var segment_count: int = 500

@export_range(1,64) var wave_spread_updates: int = 8
@export var surface_line_thickness: float = 1.0
@export var surface_color: Color = Color("3ce1da")
@export var water_fill_color: Color = Color("37b0c5")

@export var natural_wave_height: float = 50.0
@export var natural_wavelength: float = 4.0
@export var natural_wave_variance: float = 1.0
@export var speed: float = 1.0

@export var rising: bool = false
@export var time_to_rise: float = 10.0
@export var rise_final_y_pos: float = 0.0
@export var rise_time_to_start: float = 20.0
@onready var starting_init_pos: Vector2 = inital_pos
@onready var starting_size: Vector2 = water_size

var segment_data: Array = []
var recently_splashed: bool = false

var surface_line: Line2D
var fill_polygon: Polygon2D
var time: float
@onready var initial_pos: Vector2 = global_position

func _ready() -> void:
	for i in get_children():
		queue_free()
	
	initiate_water()

@export_tool_button("Update Water") var update_water_button: Callable = func():
	_ready()
	update_visuals()

var new_collision: CollisionShape2D
func initiate_water():
	segment_data.clear()
	for i in range(segment_count):
		segment_data.append({
			"height": surface_pos_y,
			"velocity": 0.0,
			"wave_to_left": 0.0,
			"wave_to_right": 0.0
		})
	
	var new_line: Line2D = Line2D.new()
	new_line.width = surface_line_thickness
	new_line.default_color = surface_color
	add_child(new_line)
	surface_line = new_line
	
	var new_polygon: Polygon2D = Polygon2D.new()
	new_polygon.color = water_fill_color
	new_polygon.show_behind_parent = true
	surface_line.add_child(new_polygon)
	fill_polygon = new_polygon


func _process(delta: float) -> void:
	update_physics(delta)
	update_visuals()
	#if natural_waves:
		#segment_data[1]["height"] -= natural_wave_height

func update_physics(delta: float):
	time+=delta*speed
	
	for updates in range(wave_spread_updates):
		for i in range(segment_count):
			segment_data[i]["height"] = (sin((time+i)/natural_wavelength) * natural_wave_height)

func update_visuals():
	var points: Array[Vector2] = []
	var segment_width: float = water_size.x / (segment_count - 1)
	for i in range(segment_count):
		points.append(Vector2(i * segment_width, segment_data[i]["height"])+inital_pos)
	var final_points: Array[Vector2] = []
	final_points += points
	
	surface_line.points = final_points
	
	var bottom_y: float = surface_pos_y + water_size.y
	final_points.append(Vector2(water_size.x, bottom_y)+inital_pos)
	final_points.append(Vector2(0, bottom_y)+inital_pos)
	fill_polygon.polygon = final_points

#var rise_started: bool = false
#var rise_tween: Tween
#func rise():
	##print("rise")
	#if rising:
		#rise_started=true
		#await get_tree().create_timer(rise_time_to_start, false).timeout
		#var final_water_size_y = abs(rise_final_y_pos-inital_pos.y)+1000.0
		#rise_tween = create_tween()
		#rise_tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
		#rise_tween.set_parallel()
		#rise_tween.tween_property(self, "water_size", Vector2(water_size.x, water_size.y+final_water_size_y), time_to_rise)
		#rise_tween.tween_property(self, "inital_pos", Vector2(inital_pos.x, inital_pos.y+rise_final_y_pos), time_to_rise)
#
#func reset():
	##print(starting_init_pos, " ", starting_size)
	##print("reset")
	#if rising:
		#if rise_tween:
			#rise_tween.kill()
		#rise_started=false
		#inital_pos = starting_init_pos
		#water_size = starting_size

@onready var curr_val: int = 0
func set_value(val: int):
	if val > 100:
		val = 100
	elif val <= 0:
		val = 0
	var val_diff: float = float(val-curr_val)
	var change_y: float = 2.5*val_diff
	water_size.y += change_y
	position.y -= change_y
	curr_val=val
