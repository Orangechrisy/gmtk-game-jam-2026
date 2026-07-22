extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Custom functions

# end_day: Runs all end-of-day functions, like variable updates and rolling new events
# Variables: NONE (for now)
# Returns: void
func end_day() -> void:
	GameState.update_day()
	# Anything else we want to do
	reduce_days_to_revolution()

# reduce_days_to_revolution: Calculates number of days to lose, then updates
# Variables: NONE (for now)
# Returns: void
func reduce_days_to_revolution() -> void:
	var days_to_reduce: int = 1
	# Run some calculations here based on events that happened
	GameState.reduce_days_to_revolution(days_to_reduce)
