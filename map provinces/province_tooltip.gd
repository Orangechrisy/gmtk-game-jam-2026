extends Control

@export var OFFSET: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# tracks the mouse position
func _process(delta: float) -> void:
	if visible:
		position = get_global_mouse_position() + OFFSET
