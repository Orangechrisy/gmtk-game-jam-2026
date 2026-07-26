extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("reset_label", reset_label)
	GameState.connect("add_to_label", add_to_label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_label() -> void:
	$AnimationPlayer.play("show_popup")

func add_to_label(to_add: String) -> void:
	$Node2D/Label.text += to_add + "\n"
