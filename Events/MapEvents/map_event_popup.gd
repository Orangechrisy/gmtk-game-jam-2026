extends Control

func _ready() -> void:
	$VBoxContainer/TextureRect/Sprite2D.hide()

func _on_mouse_entered() -> void:
	$VBoxContainer/TextureRect/Sprite2D.show()

func _on_mouse_exited() -> void:
	$VBoxContainer/TextureRect/Sprite2D.hide()
