extends Control

var current_event: MapEvent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

## shows the current event (either clicked on or auto?)
func event_selected(event: MapEvent):
	print("event selected!")
	current_event = event
	GameManager.update_current_event(event)
	%Title.text = event.get_event_name()
	%Portrait.texture = event.get_portrait()
	%CharacterName.text = event.get_character_name()
	set_dialogue(event.get_event_dialogue())
	create_buttons(event.get_options())
	visible = true

# TODO: handle dialogue text better than just basically a block with newlines
func set_dialogue(dialogue_strings: Array[String]):
	%Description.text = ""
	for line in dialogue_strings:
		%Description.text += line + '\n'

## dynamically creates up to 6 buttons, if more than 3 then it goes to a new row
func create_buttons(options: Array[EventOption]):
	print(%Options.get_children())
	if options.size() > 3:
		var halfway = int(ceil(options.size() / 2.0))
		set_button_placements(%Options, options, Vector2i(0, halfway), halfway)
		set_button_placements(%Options2, options, Vector2i(halfway, options.size()), options.size() - halfway)
	else:
		set_button_placements(%Options, options, Vector2i(0, options.size()), options.size())

## aligns the buttons so they are nicely spaced
func set_button_placements(container: HBoxContainer, options: Array[EventOption], option_range: Vector2i, num_buttons: int):
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
func close_event(removed: bool):
	visible = false
	GameManager.update_current_event(null)
	for button in %Options.get_children():
		button.queue_free()
	for button in %Options2.get_children():
		button.queue_free()
	# for province events
	if GameState.get_current_province() != null:
		if removed:
			GameState.get_current_province().update_events(null, false)
		else:
			GameState.get_current_province().update_events(current_event, true)
		GameManager.update_current_province(null)

# button to hide the event without removing it
func _on_close_pressed() -> void:
	close_event(false)
