extends Node2D

class_name TempPopup

@export var Short: bool = true

func _ready() -> void:
	changetext()
	
	if Short:
		$AnimationPlayer.play("shortpopup")
		await get_tree().create_timer(3.0, false).timeout
	else:
		$AnimationPlayer.play("longpopup")
		await get_tree().create_timer(10.0, false).timeout
	queue_free()

func changetext():
	pass
