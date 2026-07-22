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
	roll_events()

# reduce_days_to_revolution: Calculates number of days to lose, then updates
# Variables: NONE (for now)
# Returns: void
func reduce_days_to_revolution() -> void:
	var days_to_reduce: int = 1
	# Run some calculations here based on events that happened
	GameState.reduce_days_to_revolution(days_to_reduce)

# how many events do we want to have happen?
# from most to least likely (fervor?) roll event odds for each province 
# if not enough events, roll again
func roll_events() -> void:
	var owned_provinces: Array[Node2D] = GameState.provinces.filter(func(province): return province.curr_owner == 0)
	owned_provinces.sort_custom(func(a, b): return a.fervor > b.fervor)
	var num_events: int = max(owned_provinces.size(), randi() % 4)
	while num_events > 0:
		for i in owned_provinces:
			if num_events > 0:
				if owned_provinces[i].roll_event_odds():
					num_events -= 1
	
	
