extends Node

# Custom functions

## end_day: Runs all end-of-day functions, like variable updates and rolling new events
## Variables: NONE (for now)
## Returns: void
func end_day() -> void:
	GameState.update_day()
	reduce_days_to_revolution()
	
	if GameState.get_days_to_revolution() <= 0:
		pass # TODO: Implement game over functionality
	
	GameState.reset_actions_left()
	
	# Update Food/Gold stores
	# TODO: Implement penalties for running out
	calculate_food()
	if GameState.get_food() <= 0:
		print("Out of Food!")
		GameState.set_food(0)
	
	calculate_gold()
	if GameState.get_gold() <= 0:
		print("Out of Gold!")
		GameState.set_gold(0)
	
	roll_auto_event_chance()
	
	# Anything else we want to do
	
	roll_events()

## calculate_food: Calculates new Food total based on output/consumption of each province
func calculate_food() -> void:
	for province in GameState.provinces:
		if province.get_curr_owner() == 0:
			GameState.change_food(province.calculate_food())
			
## calculate_gold: Calculates new Gold total based on output/consumption of each province
func calculate_gold() -> void:
	for province in GameState.provinces:
		if province.get_curr_owner() == 0:
			GameState.change_gold(province.calculate_gold())

## reduce_days_to_revolution: Calculates number of days to lose, then updates
## Variables: NONE (for now)
## Returns: void
func reduce_days_to_revolution() -> void:
	var days_to_reduce: int = 1
	# Run some calculations here based on events that happened
	GameState.reduce_days_to_revolution(days_to_reduce)

## how many events do we want to have happen?
## from most to least likely (fervor?) roll event odds for each province 
## if not enough events, roll again
func roll_events() -> void:
	var owned_provinces: Array[Province] = GameState.provinces.filter(func(province): return province.curr_owner == 0)
	owned_provinces.sort_custom(func(a, b): return a.fervor > b.fervor)
	print(owned_provinces.size())
	var num_events: int = min(owned_provinces.size(), randi_range(3, 5))
	while num_events > 0:
		for i in owned_provinces:
			if num_events > 0:
				if owned_provinces[i].roll_event_odds():
					num_events -= 1

# TODO: Finish implementing this!
## Roll an opportunity for an event to happen between days
func roll_auto_event_chance() -> void:
	if randf_range(0, 1) <= GameState.auto_event_odds:
		GameState.auto_events.shuffle()
		for event in GameState.auto_events:
			if event.can_appear():
				event.event_fired() # TODO: Handle more cleanly, show popup
				return

## update the current province in the gamestate, 
func update_current_province(province: Province):
	GameState.set_current_province(province)

func update_current_event(event: MapEvent):
	GameState.set_current_event(event)
