extends Node2D

const REVOLT_POP_UP: PackedScene = preload("res://UI/revolt_pop_up.tscn")
const NUMBER_POP: PackedScene = preload("res://UI/revolt_pop_up.tscn")

func popup(Popupscene: PackedScene, global_pos: Vector2, message: String = ""):
	var popupnode = Popupscene.instantiate()
	popupnode.global_position = global_pos
	add_child(popupnode)
