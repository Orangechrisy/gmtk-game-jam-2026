extends Control

signal pause_game()
signal unpause_game()

var favor_tooltip_tween: Tween
var storage_tooltip_tween: Tween
@export var OFFSET: Vector2

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

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_menu_button_pressed()
	if $FavorTooltip.visible:
		$FavorTooltip.position = get_global_mouse_position() + OFFSET - Vector2(0, $FavorTooltip.size.y)
		if OFFSET.x < 0:
			$FavorTooltip.position.x -= $FavorTooltip.size.x


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
	if GameState.MouseMode == GameState.Click.BASIC:
		GameState.MouseMode = GameState.Click.ARMY_PLACEMENT
	elif GameState.MouseMode == GameState.Click.ARMY_PLACEMENT:
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


func _on_commoner_favor_hover_mouse_entered() -> void:
	if (GameState.MouseMode == GameState.Click.BASIC):
		if not GameState.get_current_event():
			if OFFSET.x < 0:
				OFFSET.x *= -1
				$FavorTooltip.set_anchors_and_offsets_preset(PRESET_BOTTOM_LEFT, PRESET_MODE_MINSIZE, 0)
				$FavorTooltip.set_h_grow_direction(GROW_DIRECTION_END)
			$FavorTooltip.show()
			$FavorTooltip/TooltipTimer.start()
			$FavorTooltip/MarginContainer/VBoxContainer/Title.text = "Common Favor"
			if GameState.get_noble_sentiment_loss() < -1:
				$FavorTooltip/MarginContainer/VBoxContainer/Events.show()
				$FavorTooltip/MarginContainer/VBoxContainer/Events.text = str(GameState.get_common_sentiment_loss() + 1) + " Events"
			else:
				$FavorTooltip/MarginContainer/VBoxContainer/Events.hide()
			var revolting_provinces: int = 0
			for province in GameState.provinces:
				if province.curr_owner != province.Owner.KING:
					revolting_provinces -= 1
			if revolting_provinces < 0:
				$FavorTooltip/MarginContainer/VBoxContainer/ProvincesLost.show()
				$FavorTooltip/MarginContainer/VBoxContainer/ProvincesLost.text = str(revolting_provinces) + " Provinces Lost"
			else:
				$FavorTooltip/MarginContainer/VBoxContainer/ProvincesLost.hide()

func _on_favor_bar_hover_mouse_exited() -> void:
	$FavorTooltip/TooltipTimer.stop()
	$FavorTooltip.hide()
	if favor_tooltip_tween: 
		favor_tooltip_tween.kill()
	favor_tooltip_tween = create_tween()
	favor_tooltip_tween.tween_property($FavorTooltip, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.05)

func _on_noble_favor_hover_mouse_entered() -> void:
	if (GameState.MouseMode == GameState.Click.BASIC):
		if not GameState.get_current_event():
			if OFFSET.x > 0:
				OFFSET.x *= -1
				$FavorTooltip.set_anchors_and_offsets_preset(PRESET_BOTTOM_RIGHT, PRESET_MODE_MINSIZE, 0)
				$FavorTooltip.set_h_grow_direction(GROW_DIRECTION_BEGIN)
			$FavorTooltip.show()
			$FavorTooltip/TooltipTimer.start()
			$FavorTooltip/MarginContainer/VBoxContainer/Title.text = "Noble Favor"
			if GameState.get_noble_sentiment_loss() < -1:
				$FavorTooltip/MarginContainer/VBoxContainer/Events.show()
				$FavorTooltip/MarginContainer/VBoxContainer/Events.text = str(GameState.get_noble_sentiment_loss() + 1) + " Events"
			else:
				$FavorTooltip/MarginContainer/VBoxContainer/Events.hide()
			var revolting_provinces: int = 0
			for province in GameState.provinces:
				if province.curr_owner != province.Owner.KING:
					revolting_provinces -= 1
			if revolting_provinces < 0:
				$FavorTooltip/MarginContainer/VBoxContainer/ProvincesLost.show()
				$FavorTooltip/MarginContainer/VBoxContainer/ProvincesLost.text = str(revolting_provinces) + " Provinces Lost"
			else:
				$FavorTooltip/MarginContainer/VBoxContainer/ProvincesLost.hide()

func _on_noble_favor_hover_mouse_exited() -> void:
	$FavorTooltip/TooltipTimer.stop()
	$FavorTooltip.hide()
	if favor_tooltip_tween: 
		favor_tooltip_tween.kill()
	favor_tooltip_tween = create_tween()
	favor_tooltip_tween.tween_property($FavorTooltip, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.05)

func _on_tooltip_timer_timeout() -> void:
	favor_tooltip_tween = create_tween()
	print("timer finished, show")
	favor_tooltip_tween.tween_property($FavorTooltip, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)


func _on_food_hover_mouse_entered() -> void:
	pass # Replace with function body.


func _on_food_hover_mouse_exited() -> void:
	pass # Replace with function body.


func _on_gold_hover_mouse_entered() -> void:
	pass # Replace with function body.


func _on_gold_hover_mouse_exited() -> void:
	pass # Replace with function body.
