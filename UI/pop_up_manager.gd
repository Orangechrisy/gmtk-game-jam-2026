extends Node2D

const REVOLT_POP_UP: PackedScene = preload("res://UI/revolt_pop_up.tscn")
const MESSAGE_POP_UP: PackedScene = preload("res://UI/message_popup.tscn")

func popup(Popupscene: PackedScene, global_pos: Vector2, message: String = ""):
	var popupnode = Popupscene.instantiate()
	popupnode.global_position = global_pos
	if Popupscene == MESSAGE_POP_UP:
		popupnode.message = message
	add_child(popupnode)
