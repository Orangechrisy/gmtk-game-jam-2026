extends Node

signal restart
signal quit_to_main

## TODO: resets everything to default starting game state
func reset() -> void:
	GameState.MouseMode = GameState.Click.BASIC
	restart.emit()
	
	GameState._reset()
	for province in GameState.provinces:
		province._reset()

## TODO idk what we might want here
func quit_to_menu() -> void:
	GameState.MouseMode = GameState.Click.MAIN
	quit_to_main.emit()
	

## end_day: Runs all end-of-day functions, like variable updates and rolling new events
## Variables: NONE (for now)
## Returns: void
func end_day() -> void:
	var game_ended = check_game_end()
	
	# Don't bother with the rest of this function if the game is over
	if game_ended:
		return
	
	# Update Food/Gold stores
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
	
	handle_loss_effects()
	
	flip_provinces()
	
	GameState.update_day()
	
	roll_events()
	check_for_events()

## checks to see if there are any events currently active in provinces
## if there arent any, make end day button visible
func check_for_events() -> void:
	var event_exists = false
	for province in GameState.provinces:
		if province.event_present != null:
			event_exists = true
	if event_exists == false:
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
			province.change_counter(Province.Counter.FERVOR, 1)
			# province.fervor += 1

## calculate_common_favor: Calculate changes to Common Favor based on fervor/loyalty
func calculate_common_favor() -> void:
	for province in GameState.provinces:
		var common_sentiment_change = 0
		if province.curr_owner != province.Owner.KING:
			common_sentiment_change -= 2
			GameState.change_noble_sentiment(-1)
		elif province.fervor * 2 >= province.loyalty:
			common_sentiment_change -= 1
		
		if GameState.get_food() <= 0:
			common_sentiment_change *= 2
		
		GameState.change_common_sentiment(common_sentiment_change)

## calculate_noble_favor: Calculate changes to Noble Favor based on gold/control
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
		if province.get_curr_owner() == province.Owner.REBELS:
			province.do_loss_effects_passive()
			
## flip_provinces: Checks which provinces should flip owners, and flips owners if needed
func flip_provinces() -> void:
	for province in GameState.provinces:
		if (province.get_curr_owner() == province.Owner.KING) and (province.fervor > province.loyalty):
			province.set_curr_owner(province.Owner.REBELS)
	
## how many events do we want to have happen?
## from most to least likely (fervor?) roll event odds for each province 
## if not enough events, roll again
func roll_events() -> void:
	var owned_provinces: Array[Province] = GameState.provinces.filter(func(province): return province.curr_owner == Province.Owner.KING)
	owned_provinces.sort_custom(func(a, b): return a.fervor > b.fervor)
	var num_events: int = min(owned_provinces.size(), randi_range(3, 5))
	while num_events > 0:
		for province in owned_provinces:
			if num_events > 0:
				if province.roll_event_odds():
					num_events -= 1

## Roll an opportunity for an event to happen between days
func roll_auto_event_chance() -> void:
	if randf_range(0, 1) <= GameState.auto_event_odds:
		GameState.auto_events.shuffle()
		for event in GameState.auto_events:
			if event.can_appear():
				event.event_fired()
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
	
## results popup
func event_button_pressed() -> void:
	GameState.reset_results_label()

func add_to_results_popup(to_add: String) -> void:
	GameState.add_to_results_popup(to_add)

## check whether the player has lost
func check_game_end() -> bool:
	# Revolution happens
	if GameState.get_days_to_revolution() <= 0:
		end_game(GameState.Ending.REVOLUTION)
		return true
	# Noble favor
	if GameState.get_noble_sentiment() <= 0:
		end_game(GameState.Ending.NOBLE_ASSASSIN)
		return true
	# Common favor
	if GameState.get_common_sentiment() <= 0:
		end_game(GameState.Ending.REVOLUTION)
		return true
		
	return false

## checks whether the player meets the requirements for an ending
func check_ending_conditions(ending: int) -> int:
	match ending:
		GameState.Ending.FLEE_DOCK_SUCCESS:
			if GameState.get_noble_sentiment() <= 50:
				return GameState.Ending.FLEE_DOCK_FAIL
			if GameState.get_character_by_name("CHAR_ARISTOCRAT").is_alive:
				return GameState.Ending.FLEE_DOCK_FAIL
			return GameState.Ending.FLEE_DOCK_SUCCESS
		GameState.Ending.FLEE_MINES_SUCCESS:
			if GameState.get_common_sentiment() <= 50:
				return GameState.Ending.FLEE_MINES_FAIL
			return GameState.Ending.FLEE_MINES_SUCCESS
		GameState.Ending.FLEE_OUTSKIRTS_SUCCESS:
			if GameState.get_common_sentiment() <= 40:
				return GameState.Ending.FLEE_OUTSKIRTS_FAIL
			if GameState.get_noble_sentiment() <= 40:
				return GameState.Ending.FLEE_OUTSKIRTS_FAIL
			return GameState.Ending.FLEE_OUTSKIRTS_SUCCESS
		GameState.Ending.SURRENDER_SUCCESS:
			if GameState.get_common_sentiment() <= 50:
				return GameState.Ending.SURRENDER_FAIL
			if GameState.get_character_by_name("CHAR_RADICAL").is_alive:
				return GameState.Ending.SURRENDER_FAIL
			return GameState.Ending.SURRENDER_SUCCESS
		GameState.Ending.ABDICATE_SUCCESS:
			if GameState.get_noble_sentiment() <= 70:
				return GameState.Ending.SURRENDER_FAIL
			if GameState.get_character_by_name("CHAR_RADICAL").is_alive:
				return GameState.Ending.SURRENDER_FAIL
			return GameState.Ending.SURRENDER_SUCCESS
	
	return ending
	
## end the game - handles ending determination logic, then runs ending
func end_game(ending: int) -> void:
	
	var final_ending = check_ending_conditions(ending)
	GameState.emit_ending(final_ending)

func calculate_score(ending: int) -> int:
	
	var score = 0
	score += GameState.get_day()
	match ending:
		GameState.Ending.NOBLE_ASSASSIN:
			score *= 1.2
		GameState.Ending.ABDICATE_FAIL:
			score *= 2
		GameState.Ending.SURRENDER_FAIL:
			score *= 2
		GameState.Ending.FLEE_DOCK_FAIL:
			score *= 3
		GameState.Ending.FLEE_MINES_FAIL:
			score *= 3
		GameState.Ending.FLEE_OUTSKIRTS_FAIL:
			score *= 3
		GameState.Ending.ABDICATE_SUCCESS:
			score *= 4
		GameState.Ending.SURRENDER_SUCCESS:
			score *= 4
		GameState.Ending.FLEE_DOCK_SUCCESS:
			score *= 5
		GameState.Ending.FLEE_OUTSKIRTS_SUCCESS:
			score *= 5
		GameState.Ending.FLEE_MINES_SUCCESS:
			score *= 5
			
	
	return score

func update_tutorial(val: bool) -> void:
	GameState.do_show_tutorial(val)
