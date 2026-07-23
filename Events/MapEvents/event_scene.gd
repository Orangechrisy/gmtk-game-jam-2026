extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func event_selected(event: MapEvent, province: Node2D):
	print("event selected!")
	%Title.text = event.get_event_name()
	%Portrait.texture = event.get_portrait()
	%CharacterName.text = event.get_character_name()
	set_dialogue(event.get_event_dialogue())
	create_buttons(event.get_options())
	visible = true

func set_dialogue(dialogue_strings: Array[String]):
	%Description.text = ""
	for line in dialogue_strings:
		%Description.text += line + '\n'

func create_buttons(options: Array[EventOption]):
	if options.size() > 3:
		var halfway = int(ceil(options.size() / 2.0))
		set_button_placements(%Options, options, Vector2i(0, halfway), halfway)
		set_button_placements(%Options2, options, Vector2i(halfway, options.size()), options.size() - halfway)
	else:
		set_button_placements(%Options, options, Vector2i(0, options.size()), options.size())

func set_button_placements(container: HBoxContainer, options: Array[EventOption], range: Vector2i, num_buttons: int):
	for i in range:
		var option = options[i]
		var button = load("res://Events/EventOptions/event_option_button.tscn").instantiate()
		button.set_values(option)
		container.add_child(button)
	# idk why this needs to go up to the hbox, but otherwise it returns 0
	var area_size = container.get_parent().get_parent().size.x
	var button_size = container.get_child(0).get_combined_maximum_size().x
	container.add_theme_constant_override("separation", int((area_size - (button_size * num_buttons)) / num_buttons) / 2)
