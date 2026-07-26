extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("show_results_popup", show_popup)
	GameState.connect("add_to_label", add_to_label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_popup() -> void:
	$AnimationPlayer.play("show_popup")

func reset_label() -> void:
	$Node2D/Label.text = "Nothing happened..."

func add_to_label(to_add: String) -> void:
	if $Node2D/Label.text == "Nothing happened...":
		$Node2D/Label.text = to_add + "\n"
	else:
		$Node2D/Label.text += to_add + "\n"
