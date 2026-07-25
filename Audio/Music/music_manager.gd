extends Node

@onready var playing: bool = false
@export var default_db: float = -17.0

func _ready() -> void:
	GameState.connect("province_owner_changed", add_track)
	
	_reset()

func _reset():
	for track in get_children():
		#print("track")
		if track.playing:
			var tween = create_tween()
			tween.tween_property(track, "volume_linear", 0.0, 1.0)
			tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			if is_inside_tree(): await tween.finished
			if is_inside_tree(): await get_tree().create_timer(0.5).timeout
			track.stop()
		track.volume_db = default_db

func start_base_track():
	_reset()
	await get_tree().create_timer(1.0,false).timeout
	$"Capital (Base)".play()

func get_current_time():
	return $"Capital (Base)".get_playback_position()

func add_track(province: Province):
	var province_name = province.province_name
	#print(province_name)
	var time: float = get_current_time() 
	var track: AudioStreamPlayer
	match province_name:
		"Military":
			track = $Military
		"Farm":
			track = $Farm
		"Town":
			track = $Town
		"Villa":
			track = $Villa
		"City":
			return
		"Port":
			track = $Port
		"Mine":
			track = $Mine
		"Port":
			track = $Port
		"Church":
			track = $Church
		"Outskirts":
			track = $Outskirts
		_:
			print("Error: cannot add music, unknown Province")
			return
	track.volume_linear = 0.0
	track.play(time)
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(track, "volume_linear", db_to_linear(default_db), 1.0)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(1.0).timeout
