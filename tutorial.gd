extends Control

var step: int = 0
func _ready() -> void:
	$TutorialBlockOut.hide()
	$Arrows/ArrowDown.hide()
	$Arrows/ArrowLeft.hide()
	$Arrows/ArrowRight.hide()
	$Arrows/ArrowUp.hide()
	GameState.connect("update_tutorial", on_update_tutorial)
	GameState.connect("tutorial_next_step", tutorial_next_step)

func on_update_tutorial(show: bool) -> void:
	if show:
		start_tutorial()

func tutorial_next_step(nextstep: int):
	if nextstep > 8:
		next_step()

func start_tutorial():
	await get_tree().physics_frame
	step=0
	if SaveData.get_data("TutorialCompleted"):
		hide()
		end_tutorial()
	else:
		GameState.MouseMode = GameState.Click.TUTORIAL
		next_step()
		SaveData.save_data("TutorialCompleted", true)

var text_showing: bool = false
func show_text(text: String, pos: Vector2):
	if text_showing:
		hide_text()
		await get_tree().create_timer(0.5).timeout
	text_showing=true
	$Label.hide()
	$Label.position = pos
	$Label.text = text
	$Label/AnimationPlayer.play("fadein_text")
	$Label.show()

func hide_text():
	text_showing=false
	$Label/AnimationPlayer.play_backwards("fadein_text")

var button_anim: bool = false
var button_showing: bool = false
func show_button(pos: Vector2):
	if button_showing:
		hide_button()
		await get_tree().create_timer(0.5).timeout
	button_showing=true
	$ContinueButton.hide()
	$ContinueButton.position = pos
	$ContinueButton/AnimationPlayer.play("fadein_button")
	$ContinueButton.show()
	await get_tree().create_timer(0.5).timeout
	button_anim = false

func hide_button():
	button_showing=false
	$ContinueButton/AnimationPlayer.play_backwards("fadein_button")

var blockout_showing: bool = false
func show_blockout(pos: Vector2):
	if blockout_showing:
		hide_blockout()
		await get_tree().create_timer(0.5).timeout
	blockout_showing=true
	$TutorialBlockOut.hide()
	$TutorialBlockOut.position = pos
	$TutorialBlockOut/AnimationPlayer.play("fadein_blockout")
	$TutorialBlockOut.show()

func hide_blockout():
	blockout_showing=false
	$TutorialBlockOut/AnimationPlayer.play_backwards("fadein_blockout")

var arrow_showing: bool = false
func show_arrow(arrow: String, pos: Vector2):
	if arrow_showing:
		hide_arrows()
		await get_tree().create_timer(0.5).timeout
	arrow_showing=true
	$Arrows/ArrowDown.hide()
	$Arrows/ArrowLeft.hide()
	$Arrows/ArrowRight.hide()
	$Arrows/ArrowUp.hide()
	
	$Arrows.position = pos
	$Arrows/AnimationPlayer.play("fadein_arrows")
	
	match arrow:
		"Up":
			$Arrows/ArrowUp.show()
		"Left":
			$Arrows/ArrowLeft.show()
		"Down":
			$Arrows/ArrowDown.show()
		"Right":
			$Arrows/ArrowRight.show()

func hide_arrows():
	arrow_showing=false
	$Arrows/AnimationPlayer.play_backwards("fadein_arrows")

#TUTORIAL
func next_step():
	step+=1
	match step:
		1: #INTRO
			var text: String = "You are the ruler of a once great kingdom.\nAt the current moment, you kingdom is at risk of falling to rebellion."
			var textpos: Vector2 = Vector2(450.5, 340.0)
			show_text(text, textpos)
			var buttonpos: Vector2 = Vector2(841, 574)
			show_button(buttonpos)
			show()
		2: #DAYS
			var text: String = "This is how many days you have until your empire falls into rebellion.\nCan you change your fate before that happens?"
			var textpos: Vector2 = Vector2(360.5, 300.0)
			show_text(text, textpos)
			var buttonpos: Vector2 = Vector2(782, 540)
			show_button(buttonpos)
			var blockoutpos: Vector2 = Vector2(930.0, 118.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(792.0, 267.0)
			show_arrow("Up", arrowpos)
		3: #COMMONER
			var text: String = "This the Favor of the Commoners in your Empire.\nIf your Commoner Favor reaches 0, this could spell trouble for your empire."
			var textpos: Vector2 = Vector2(247.0, 668.0)
			show_text(text, textpos)
			var buttonpos: Vector2 = Vector2(742.0, 894.0)
			show_button(buttonpos)
			var blockoutpos: Vector2 = Vector2(120.0, 896.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(302.0, 934.0)
			show_arrow("Left", arrowpos)
		4: #FOOD
			var text: String = "This the Empire's Food.\nIf you run out of Food, your Commoner Favor will considerably decrease each turn!"
			var textpos: Vector2 = Vector2(316.0, 379.0)
			show_text(text, textpos)
			var buttonpos: Vector2 = Vector2(853.0, 603.0)
			show_button(buttonpos)
			var blockoutpos: Vector2 = Vector2(141.0, 687.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(358.0, 645.0)
			show_arrow("Left", arrowpos)
		5: #NOBLE
			var text: String = "This the Favor of the Nobles in your Empire.\nIf your Noble Favor reaches 0, the nobles will start acting deceitful."
			var textpos: Vector2 = Vector2(434.0, 642.0)
			show_text(text, textpos)
			var buttonpos: Vector2 = Vector2(1059.0, 853.0)
			show_button(buttonpos)
			var blockoutpos: Vector2 = Vector2(1786.0, 870.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(1645.0, 903.0)
			show_arrow("Right", arrowpos)
		6: #GOLD
			var text: String = "This the Empire's Gold.\nYou can purchase things during events, but careful!\nIf you run out, Noble Favor will dramatically decrease!"
			var textpos: Vector2 = Vector2(580.0, 387.0)
			show_text(text, textpos)
			var buttonpos: Vector2 = Vector2(1140.0, 630.0)
			show_button(buttonpos)
			var blockoutpos: Vector2 = Vector2(1800.0, 687.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(1641.0, 672.0)
			show_arrow("Right", arrowpos)
		7: #HOVER
			GameState.tutorial_next_step.emit(step)
			
			var text: String = "Hover your mouse over a province to see its gold and food output, as well as its fervor and loyalty.\nFervor naturally increases each turn. If Fervor increases past Loyalty, it may fall, so be cautious."
			var textpos: Vector2 = Vector2(194.0, 364.0)
			show_text(text, textpos)
			var buttonpos: Vector2 = Vector2(885.0, 593.0)
			show_button(buttonpos)
			var blockoutpos: Vector2 = Vector2(743.0, 694.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(621.0, 692.0)
			show_arrow("Right", arrowpos)
		8: #ARMY
			GameState.tutorial_next_step.emit(step)
			
			var text: String = "A way to mitigate Fervor is by placing Armies.\nTo do this, first click Place Army."
			var textpos: Vector2 = Vector2(-20.0, 293.0)
			show_text(text, textpos)
			hide_button()
			var blockoutpos: Vector2 = Vector2(510.0, 107.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(368.0, 259.0)
			show_arrow("Up", arrowpos)
		9: #ARMY 2
			if !text_showing:
				step=8
				return
			var text: String = "Now, click on a province.\nThis will block Fervor gain this turn, and it will block Fervor gain from any Events."
			var textpos: Vector2 = Vector2(194.0, 364.0)
			show_text(text, textpos)
			var blockoutpos: Vector2 = Vector2(743.0, 694.0)
			show_blockout(blockoutpos)
			var arrowpos: Vector2 = Vector2(621.0, 692.0)
			show_arrow("Right", arrowpos)
		10: #EVENTS
			GameState.tutorial_next_step.emit(step)
			
			var text: String = "To end the day, you must complete every event. To do this, simply click on the province with an event icon.\nBut, be careful! A wrong decision could put the future of your nation at peril!\nGood luck!"
			var textpos: Vector2 = Vector2(194.0, 364.0)
			show_text(text, textpos)
			hide_blockout()
			hide_arrows()
		_:
			end_tutorial()
		

func _on_continue_button_mouse_entered() -> void:
	if GameState.MouseMode == GameState.Click.TUTORIAL:
		MusicManager.play_sfx(MusicManager.SFX.MOUSEOVER)

func _on_continue_button_pressed() -> void:
	if !button_anim:
		button_anim = true
		next_step()

func end_tutorial():
	GameManager.update_tutorial(false)
	if text_showing:
		hide_text()
	if arrow_showing:
		hide_arrows()
	if button_showing:
		hide_button()
	if blockout_showing:
		hide_blockout()
