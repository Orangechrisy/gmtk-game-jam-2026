extends Node

var text_dict: Dictionary = {}
var lang_name_dict: Dictionary = {}
var curr_lang: String = ""

signal translation_changed(old_lang: String)

const ITEM_JSON_DATA = "res://data/Dialogue.json"

func _ready() -> void:
	#if is_inside_tree(): await get_tree().physics_frame
	#var video_settings = Confighandler.load_video_settings()
	#if video_settings.has("Language"):
		#load_translation(video_settings["Language"])
	#else:
	load_translation('en')

func load_json(path: String):
	var file = FileAccess.get_file_as_string(path)
	var json
	if file != null:
		json = JSON.parse_string(file)
	else:
		print("error importing file")
	
	return json

func init_json_data(lang_type: String) -> void:
	text_dict.clear()
	
	var json = load_json(ITEM_JSON_DATA)
	if json != null:
		if is_inside_tree(): await get_tree().physics_frame
		for i in json:
			parse_json(i, json[i], lang_type)
	else:
		print("error initalizing Items.json")

func parse_json(ID: String, json: Dictionary, lang_type: String):
	if ID != "LANG_NAME":
		text_dict[ID] = json[lang_type]
	else:
		for i in json:
			lang_name_dict[i] = json[i]


func load_translation(lang_type: String = "en"):
	if curr_lang==lang_type: return
	var old_lang = curr_lang
	curr_lang=lang_type
	init_json_data(lang_type)
	#if is_inside_tree(): await get_tree().physics_frame
	#translation_changed.emit(old_lang)

func get_text(TEXT_ID: String, convert_colors: bool = false) -> String:
	if convert_colors:
		return convert_text_colors(text_dict[TEXT_ID])
	else:
		return text_dict[TEXT_ID]

func convert_text_colors(text: String) -> String:
	var newtext: String = text
	
	#Colors
	#if newtext.contains("[color_heal]"):
		#newtext = newtext.replace("[color_heal]", "[color=00f563]")
	#if newtext.contains("[color_mouse]"):
		#newtext = newtext.replace("[color_mouse]", "[color=ceffff]")
	#if newtext.contains("[color_stun]"):
		#newtext = newtext.replace("[color_stun]", "[color=aea894]")
	#if newtext.contains("[color_dmg_special]"):
		#newtext = newtext.replace("[color_dmg_special]", "[color=f9b799]")
	#if newtext.contains("[color_parry]"):
		#newtext = newtext.replace("[color_parry]", "[color=00ffff]")
	#if newtext.contains("[color_perfectparry]"):
		#newtext = newtext.replace("[color_perfectparry]", "[color=f2b300]")
	#if newtext.contains("[color_ally]"):
		#newtext = newtext.replace("[color_ally]", "[color=55afed]")
	#if newtext.contains("[color_negative]"):
		#newtext = newtext.replace("[color_negative]", "[color=ff4747]")
	#if newtext.contains("[color_stackable]"):
		#newtext = newtext.replace("[color_stackable]", "[color=a679ff]")
	#if newtext.contains("[color_proj_change]"):
		#newtext = newtext.replace("[color_proj_change]", "[color=63dfb6]")
	#if newtext.contains("[color_convert]"):
		#newtext = newtext.replace("[color_convert]", "[color=ff66cc]")
	#if newtext.contains("[color_fire]"):
		#newtext = newtext.replace("[color_fire]", "[color=ff701b]")
	#if newtext.contains("[color_upgrade]"):
		#newtext = newtext.replace("[color_upgrade]", "[color=ffff00]")
	#if newtext.contains("[color_knockback]"):
		#newtext = newtext.replace("[color_knockback]", "[color=accccc]")
	#if newtext.contains("[color_teleport]"):
		#newtext = newtext.replace("[color_teleport]", "[color=a3a3f7]")
	#if newtext.contains("[color_shadow]"):
		#newtext = newtext.replace("[color_shadow]", "[color=86a6a4]")
	#if newtext.contains("[color_granitewall]"):
		#newtext = newtext.replace("[color_granitewall]", "[color=cca839]")
	
	#Input Buttons
	#if newtext.contains("[MB]"):
		#var keyboard: bool = true
		#if !Globals.controller_connected:
			#newtext = newtext.replace("[MB]", KeyManager.get_key_name("mouse_primary_action", keyboard).to_upper())
		#else:
			#keyboard = false
			#var controllertxt: String = '[font="res://assets/UI/promptfont.ttf"][font_size=30]'+KeyManager.get_key_name("mouse_primary_action", keyboard)+'[/font_size][/font]'
			#newtext = newtext.replace("(MB)", controllertxt)
	#if newtext.contains("[PB]"):
		#var keyboard: bool = true
		#if !Globals.controller_connected:
			#newtext = newtext.replace("[PB]", KeyManager.get_key_name("parry", keyboard).to_upper())
		#else:
			#keyboard = false
			#var controllertxt: String = '[font="res://assets/UI/promptfont.ttf"][font_size=30]'+KeyManager.get_key_name("parry", keyboard)+'[/font_size][/font]'
			#newtext = newtext.replace("[PB]", controllertxt)
	
	return newtext
