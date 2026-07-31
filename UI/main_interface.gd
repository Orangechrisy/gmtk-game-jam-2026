extends Control

signal pause_game()
signal unpause_game()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("mouse_mode_updated", on_mouse_mode_updated)
	GameState.connect("day_updated", on_day_updated)
	GameState.connect("active_events", show_end_day)
	GameState.connect("days_to_revolution_updated", on_days_to_revolution_updated)
	GameState.connect("food_updated", on_food_updated)
	GameState.connect("gold_updated", on_gold_updated)
	GameState.connect("common_sentiment_updated", on_common_sentiment_updated)
	GameState.connect("noble_sentiment_updated", on_noble_sentiment_updated)
	GameState.connect("armies_left_updated", on_armies_left_updated)
	GameState.connect("tutorial_next_step", tutorial_next_step)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_menu_button_pressed()


# UI Updates

func on_mouse_mode_updated(new_mode) -> void:
	if new_mode == GameState.Click.ARMY_PLACEMENT:
		set_mouse_behavior_recursive(MOUSE_BEHAVIOR_INHERITED)
		%PlaceArmyButton.text = "Cancel"
	else:
		%PlaceArmyButton.text = "Place Army"
		if new_mode == GameState.Click.BASIC:
			set_mouse_behavior_recursive(MOUSE_BEHAVIOR_INHERITED)
		else:
			set_mouse_behavior_recursive(MOUSE_BEHAVIOR_DISABLED)

func on_day_updated(new_day: int) -> void:
	%DayLabel.text = "Day " + str(new_day)

func on_days_to_revolution_updated(new_days_left: int) -> void:
	%DaysUntilRevLabel.text = str(new_days_left)

func on_food_updated(new_food: int) -> void:
	%FoodLabel.text = "Food: " + str(new_food)

func on_gold_updated(new_gold: int) -> void:
	%GoldLabel.text = "Gold: " + str(new_gold)

func on_common_sentiment_updated(new_sentiment: int) -> void:
	%CommonFervorBar.material.set_shader_parameter("fire_height", clamp((new_sentiment / 100.0), 0.0, 1.0))
	%CommonFervorBar/Label.text = str(new_sentiment)
	var fire_height = %CommonFervorBar.material.get_shader_parameter("fire_height")
	var box_height = %CommonFervorBar.material.get_shader_parameter("box_height")
	var alt_fire_height = (fire_height * (1.0 - box_height)) + box_height

func on_noble_sentiment_updated(new_sentiment: int) -> void:
	if new_sentiment < 0:
		new_sentiment = 0
	$NobleTextureRect2/NoblePatch/WineBar.set_value(new_sentiment)
	$NobleTextureRect2/NoblePatch/Label.text = str(new_sentiment)

func on_armies_left_updated(new_armies_left: int) -> void:
	%PlaceArmyLabel.text = "Armies Left: " + str(new_armies_left)


func _on_menu_button_pressed() -> void:
	play_click()
	if GameState.MouseMode == GameState.Click.PAUSE:
		unpause_game.emit()
	else:
		pause_game.emit()

## Handles army placement button
func _on_place_army_button_pressed() -> void:
	if GameState.get_armies_left() <= 0: 
		MusicManager.play_sfx(MusicManager.SFX.CLICKINVALID)
		return
	play_click()
	if (GameState.MouseMode == GameState.Click.BASIC) or tutorial_can_use_army:
		if tutorial_can_use_army:
			GameState.tutorial_next_step.emit(9)
		GameState.MouseMode = GameState.Click.ARMY_PLACEMENT
	elif (GameState.MouseMode == GameState.Click.ARMY_PLACEMENT):
		GameState.MouseMode = GameState.Click.BASIC

## adjust end day button visibility (val = true means there is an active event)
func show_end_day(_val: bool) -> void:
	var tween = create_tween()
	tween.tween_property(%End, "offset_transform_position", Vector2(0, -50), 1.2) \
	.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished

## ends the day when pressed
var end_day_anim_playing: bool = false
func _on_end_day_pressed() -> void:
	if end_day_anim_playing:
		MusicManager.play_sfx(MusicManager.SFX.CLICKINVALID)
		return
	end_day_anim_playing=true
	play_click()
	var tween = create_tween()
	tween.tween_property(%End, "offset_transform_position", Vector2(0, -300), 1.0) \
	.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	end_day_anim_playing=false
	GameManager.end_day()

func play_click():
	MusicManager.play_sfx(MusicManager.SFX.CLICK)

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)

#tutorial
var tutorial_can_use_army: bool = false
func tutorial_next_step(step: int):
	if step==8:
		tutorial_can_use_army=true
		set_mouse_behavior_recursive(MOUSE_BEHAVIOR_INHERITED)
	else:
		tutorial_can_use_army=false
		set_mouse_behavior_recursive(MOUSE_BEHAVIOR_DISABLED)
