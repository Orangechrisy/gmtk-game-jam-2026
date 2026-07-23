extends Node2D

@export var test_event: MapEvent
var test_option: EventOption

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("day_updated", on_day_updated)
	GameState.connect("food_updated", on_food_updated)
	
	$EventLabel.text = test_event.get_event_name()
	$EventChoiceButton.text = test_event.get_options()[0].get_option_name()
	test_option = test_event.get_options()[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	GameManager.end_day()

func on_day_updated(new_day: int) -> void:
	$DayLabel.text = "DAY " + str(new_day)

func on_food_updated(new_food: int) -> void:
	$FoodLabel.text = "FOOD: " + str(new_food)


func _on_event_choice_button_pressed() -> void:
	test_option.calculate_success()
	GameState.reduce_actions_left() # TODO: Don't do this! Tell the Game Manager to do it!
