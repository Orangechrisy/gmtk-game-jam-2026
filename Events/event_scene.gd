extends Control

var current_event: MapEvent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_event_scene()
	GameState.connect("mouse_mode_updated", on_mouse_mode_updated)

func on_mouse_mode_updated(new_mode) -> void:
	if new_mode == GameState.Click.EVENT:
		set_mouse_behavior_recursive(MOUSE_BEHAVIOR_INHERITED)
	else:
		set_mouse_behavior_recursive(MOUSE_BEHAVIOR_DISABLED)

## resets the event scene to ensure the next event selected can adjust as needed
func reset_event_scene() -> void:
	visible = false
	GameManager.update_current_event(null)
	for button in %Options.get_children():
		button.queue_free()
	for button in %Options2.get_children():
		button.queue_free()
	%Close.visible = true
	%CharacterName.get_parent().visible = true
	%Portrait.texture = null
	%Portrait.visible = true

## shows the current event (either clicked on or auto?)
func event_selected(event: MapEvent):
	current_event = event
	GameManager.update_current_event(event)
	%Title.text = "[font_size=28]" + TextManager.get_text(event.get_event_name()) + "[/font_size]"
	%Portrait.texture = event.get_portrait()
	%CharacterName.text = "[font_size=28]" + TextManager.get_text(event.get_character_name()) + "[/font_size]"
	if %CharacterName.text == "":
		set_auto_event()
	set_dialogue(event.get_event_dialogue())
	create_buttons(event.get_options())
	visible = true
	GameState.MouseMode = GameState.Click.EVENT
	MusicManager.play_sfx(MusicManager.SFX.POPUP)

## adjusts the event popup to fit with the auto event setup
func set_auto_event() -> void:
	%Close.visible = false
	%CharacterName.get_parent().visible = false
	if %Portrait.texture != null:
		%Portrait.visible = false

# TODO: handle dialogue text better than just basically a block with newlines
func set_dialogue(dialogue_strings: Array[String]) -> void:
	%Description.text = "[font_size=28]"
	for line in dialogue_strings:
		%Description.text += TextManager.get_text(line) + '\n'
	%Description.text += "[/font_size]"

## dynamically creates up to 6 buttons, if more than 3 then it goes to a new row
func create_buttons(options: Array[EventOption]) -> void:
	if options.size() > 3:
		var halfway = int(ceil(options.size() / 2.0))
		set_button_placements(%Options, options, Vector2i(0, halfway), halfway)
		set_button_placements(%Options2, options, Vector2i(halfway, options.size()), options.size() - halfway)
	else:
		set_button_placements(%Options, options, Vector2i(0, options.size()), options.size())

## aligns the buttons so they are nicely spaced
func set_button_placements(container: HBoxContainer, options: Array[EventOption], option_range: Vector2i, num_buttons: int) -> void:
	for i in option_range:
		var option = options[i]
		var button = load("res://Events/EventOptions/event_option_button.tscn").instantiate()
		button.set_values(option)
		container.add_child(button)
	# idk why this needs to go up to the hbox, but otherwise it returns 0
	var area_size = container.get_parent().get_parent().size.x
	var button_size = container.get_child(0).get_combined_maximum_size().x
	container.add_theme_constant_override("separation", int((area_size - (button_size * num_buttons)) / num_buttons) / 2)

## closes the event scene (hides it), removes the options so its fresh next time
func close_event(removed: bool) -> void:
	reset_event_scene()
	# for province events
	if GameState.get_current_province() != null:
		if removed:
			GameState.get_current_province().update_events(null, false)
		else:
			GameState.get_current_province().update_events(current_event, true)
		GameManager.update_current_province(null)
	# so game manager can figure out if the day can end
	GameManager.check_for_events()
	GameState.MouseMode = GameState.Click.BASIC
	GameState.reset_outlines()

# button to hide the event without removing it
func _on_close_pressed() -> void:
	if GameState.MouseMode == GameState.Click.EVENT:
		close_event(false)
	MusicManager.play_sfx(MusicManager.SFX.CLICK)

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)
