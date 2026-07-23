extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func event_selected(event: MapEvent, province: Node2D):
	print("event selected!")
	%Title.text = event.get_event_name()
	%Portrait.texture = event.get_portrait()
	%CharacterName.text = event.get_character_name()
	%Description.text = event.get_event_dialogue()
	for option in event.get_options():
		pass
		var button = load("res://Events/EventOptions/event_option_button.tscn")
		button.set_values(option)
		%Options.add_child(button)
	visible = true
