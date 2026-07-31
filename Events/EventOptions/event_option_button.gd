extends Button

@export var option_name: StringName
@export var option_desc: StringName
@export var conditions: Array[EventCondition]
@export_range(0, 1, 0.01) var success_odds: float
@export var success_outcome: Array[EventEffect]
@export var failure_outcome: Array[EventEffect]
@export var unavailable: bool = false:
	set(val):
		unavailable=val
		if unavailable:
			make_button_unavailable()

var tooltip: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tooltip = get_node("/root/EventScene/OptionsTooltip")

func set_values(option: EventOption):
	option_name = option.option_name
	conditions = option.conditions
	success_odds = option.success_odds
	success_outcome = option.success_effects
	failure_outcome = option.failure_effects
	text = TextManager.get_text(option_name)
	option_name = "[b]" + str(success_odds * 100) + "%[/b] " + option_name
	print(unavailable)
	if !unavailable:
		option_desc = option.option_desc
	else:
		option_desc = "Can't choose:\n"+option.get_failed_conditions()

func _on_mouse_entered() -> void:
	tooltip.set_values(option_desc, success_outcome, failure_outcome, unavailable)
	tooltip.visible = not tooltip.visible
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)

func _on_mouse_exited() -> void:
	tooltip.visible = not tooltip.visible


func _on_pressed() -> void:
	if !unavailable:
		GameManager.event_button_pressed() # Clears results label
		MusicManager.play_sfx(MusicManager.SFX.CLICK)
		if randf_range(0, 1) <= success_odds:
			MusicManager.play_sfx(MusicManager.SFX.POSJINGLE, false)
			for effect in success_outcome:
				effect.do_effect()
		else:
			MusicManager.play_sfx(MusicManager.SFX.NEGJINGLE, false)
			for effect in failure_outcome:
				effect.do_effect()
		get_node("/root/EventScene").close_event(true)
	else:
		MusicManager.play_sfx(MusicManager.SFX.CLICKINVALID)


func make_button_unavailable():
	#text = "Unavailable"
	
	add_theme_color_override("font_color", Color("b0b0b0ff"))
	add_theme_color_override("font_hover_color", Color("d7d7d7ff"))
	
	var norm_box:= StyleBoxTexture.new()
	norm_box.texture = load("res://Assets/stamp_disabled.png")
	add_theme_stylebox_override("normal", norm_box)
	
	var hover_box:= StyleBoxTexture.new()
	hover_box.texture = load("res://Assets/stamp_disabled_hover.png")
	add_theme_stylebox_override("hover", hover_box)
