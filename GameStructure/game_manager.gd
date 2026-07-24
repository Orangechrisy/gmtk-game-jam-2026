extends Node

# Custom functions

## TODO: resets everything to default starting game state
func reset():
	pass

## end_day: Runs all end-of-day functions, like variable updates and rolling new events
## Variables: NONE (for now)
## Returns: void
func end_day() -> void:
	GameState.update_day()
	
	if GameState.get_days_to_revolution() <= 0:
		pass # TODO: Implement game over functionality
	
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
	
	GameState.reset_armies_left()
	
	roll_auto_event_chance()
	
	calculate_fervor()
	
	calculate_common_favor()
	calculate_noble_favor()
	
	reduce_days_to_revolution()
	
	# TODO: Handle provinces flipping!
	handle_loss_effects()
	
	flip_provinces()
	
	check_game_end()
	
	roll_events()
	check_for_events()

## checks to see if there are any events currently active in provinces
## if there arent any, make end day button visible
func check_for_events() -> void:
	var event_exists = false
	for province in GameState.provinces:
		if province.event_present != null:
			event_exists = true
	GameState.any_active_events(event_exists)

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

## calculate_fervor: Calculate fervor updates in all provinces
func calculate_fervor() -> void:
	for province in GameState.provinces:
		if not province.has_army:
			province.fervor += 1

## calculate_common_favor: Calculate changes to Common Favor based on fervor/loyalty
# TODO: Determine calculations!
func calculate_common_favor() -> void:
	for province in GameState.provinces:
		var common_sentiment_change = 0
		if province.curr_owner != 0:
			common_sentiment_change -= 3
			GameState.change_noble_sentiment(-1)
		elif province.fervor * 3 >= province.loyalty * 2:
			common_sentiment_change -= 2
		elif province.fervor * 3 >= province.loyalty:
			common_sentiment_change -= 1
		
		if GameState.get_food() <= 0:
			common_sentiment_change *= 2
		
		GameState.change_common_sentiment(common_sentiment_change)

func calculate_noble_favor() -> void:
	for province in GameState.provinces:
		if province.curr_owner != 0:
			GameState.change_noble_sentiment(-1)
		
		if GameState.get_gold() <= 0:
			GameState.change_noble_sentiment(-1)
	
## reduce_days_to_revolution: Calculates number of days to lose, then updates
## Variables: NONE (for now)
## Returns: void
# TODO: Play with the functionality here!
func reduce_days_to_revolution() -> void:
	var days_to_reduce: int = 1
	# Run some calculations here based on events that happened
	if GameState.get_common_sentiment() <= 50:
		days_to_reduce += 1
		
	if GameState.get_common_sentiment() <= 25:
		days_to_reduce += 1
		
	if GameState.revolt_accelerated:
		days_to_reduce += 1
		GameState.revolt_accelerated = false
	
	if GameState.revolt_stalled:
		days_to_reduce = 0
		GameState.revolt_stalled = false
		
	GameState.reduce_days_to_revolution(days_to_reduce)

func handle_loss_effects() -> void:
	for province in GameState.provinces:
		if province.get_curr_owner() == 1:
			province.do_loss_effects_passive()
			
## flip_provinces: Checks which provinces should flip owners, and flips owners if needed
func flip_provinces() -> void:
	for province in GameState.provinces:
		if province.get_curr_owner() == 0 and province.fervor > province.loyalty:
			province.set_curr_owner(1)
			# TODO: Other effects
	
## how many events do we want to have happen?
## from most to least likely (fervor?) roll event odds for each province 
## if not enough events, roll again
func roll_events() -> void:
	var owned_provinces: Array[Province] = GameState.provinces.filter(func(province): return province.curr_owner == Province.Owner.KING)
	owned_provinces.sort_custom(func(a, b): return a.fervor > b.fervor)
	print(owned_provinces.size())
	var num_events: int = min(owned_provinces.size(), randi_range(3, 5))
	print("num events: ", num_events)
	print(owned_provinces)
	while num_events > 0:
		for province in owned_provinces:
			if num_events > 0:
				if province.roll_event_odds():
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

## update the current event (to know if an event is open)
func update_current_event(event: MapEvent):
	GameState.set_current_event(event)

## kill character
func kill_character(character: Character) -> void:
	character.is_alive = false

## check whether the player has lost
func check_game_end() -> void:
	pass # TODO: Implement checks for game loss

## end the game
func end_game(ending: int) -> void:
	pass # TODO: Implement ending
