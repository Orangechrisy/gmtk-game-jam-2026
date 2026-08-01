extends Control

@export var web: bool = false
var first_play: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EndingsContainer.hide()
	$MainMainMenu/TutorialButton.hide()
	for sub_menu in get_children():
		if sub_menu.has_signal("back_up"):
			sub_menu.connect("back_up", on_back_up)
	
	#ENDINGS
	show_endings()
	GameState.connect("game_ended", game_ended)
	
	#TUTORIAL
	GameManager.connect("quit_to_main", show_tutorial)
	show_tutorial()

func game_ended(_ending, _ending_names, _ending_texts):
	show_endings()
	show_tutorial()

func show_endings():
	await get_tree().physics_frame
	var ending_count: int = 0
	for endingID in GameState.Ending.size():
		if SaveData.get_data("EndingsCompleted", endingID):
			ending_count+=1
	if ending_count > 0:
		$EndingsContainer/HBoxContainer/Num.text = str(ending_count)
		$EndingsContainer.show()

func show_tutorial():
	await get_tree().physics_frame
	if SaveData.get_data("TutorialCompleted"):
		$MainMainMenu/TutorialButton.show()

func _on_start_game_button_pressed() -> void:
	if web and first_play:
		SaveData.save_data("TutorialCompleted", false)
		first_play=false
	play_click()
	GameManager.reset()
	GameManager.roll_events()
	GameManager.check_for_events()
	GameManager.update_tutorial(true)
	# TODO: more interesting transition.
	# map there the whole time (main menu as child to it) and this just hides the main menu
	# and emits a signal for the map to show things with a nice transition?
	# like maybe the map when main menu active blurred? idk


func _on_options_button_pressed() -> void:
	play_click()
	$TitleFlag.visible = false
	$MainMainMenu.visible = false
	$OptionsMenu.visible = true


func _on_credits_button_pressed() -> void:
	play_click()
	$TitleFlag.visible = false
	$MainMainMenu.visible = false
	$CreditsMenu.visible = true


func _on_quit_game_button_pressed() -> void:
	play_click()
	$TitleFlag.visible = false
	$MainMainMenu.visible = false
	$EndingsContainer.visible = false
	$QuitConfirmMenu.visible = true

func on_back_up() -> void:
	$TitleFlag.visible = true
	$MainMainMenu.visible = true
	show_endings()

func play_click():
	MusicManager.play_sfx(MusicManager.SFX.CLICK)

func _on_mouse_entered() -> void:
	MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)


func _on_tutorial_button_pressed() -> void:
	SaveData.save_data("TutorialCompleted", false)
	_on_start_game_button_pressed()
