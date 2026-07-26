extends Node2D

var bubble_texture: Texture2D = load("res://Assets/bubble.png")
var bubble_count: int = 0
func _on_bubble_timer_timeout() -> void:
	if bubble_count>=10:
		return
	bubble_count+=1
	
	var bubble = Sprite2D.new()
	bubble.texture = bubble_texture
	bubble.scale = Vector2.ZERO
	bubble.global_position = Vector2(randf_range(30.0,100.0), 400.0)
	bubble.rotation_degrees = randf_range(0.0,360.0)
	add_child(bubble)
	
	var new_scale_mod: float = randf_range(0.2,0.8)
	var time: float = randf_range(3.0,5.0)
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.set_parallel()
	tween.tween_property(bubble, "global_position", Vector2(bubble.global_position.x, 700), time)
	tween.tween_property(bubble, "scale", Vector2(new_scale_mod, new_scale_mod), time)
	await get_tree().create_timer(time-1.0,false).timeout
	var tween2 = create_tween()
	tween2.tween_property(bubble, "modulate", Color("00000000"), 1.0)
	await tween2.finished
	bubble_count-=1
	bubble.queue_free()
