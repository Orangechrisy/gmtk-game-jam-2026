extends Node

@onready var playing: bool = false
@export var web: bool = false
@export var default_db: float = -15.0

var tracks_playing = {
	"Military": false,
	"Farm": false,
	"Church": false,
	"Mine": false,
	"Outskirts": false,
	"City": false,
	"Villa": false,
	"Port": false,
	"Town": false
}

func _ready() -> void:
	GameState.connect("province_owner_changed", add_track)
	
	_reset()

#stopping music
func _reset():
	var nodes: Array = [$MainTheme, $OtherMusic]
	for parentnode in nodes:
		for track in parentnode.get_children():
			#print("track")
			if track.playing:
				var tween = create_tween()
				tween.tween_property(track, "volume_linear", 0.0, 1.0)
				tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
				track.stop()
			track.volume_db = default_db

#Ending Tracks
enum ENDINGTYPE { BAD, GOOD }

func play_ending_song(ending_type: int = ENDINGTYPE.BAD):
	_reset()
	await get_tree().create_timer(1.0,false).timeout
	$OtherMusic.get_child(ending_type).play()

#Base Track
func start_base_track():
	if not $"MainTheme/Capital (Base)".playing:
		_reset()
		await get_tree().create_timer(1.0,false).timeout
		$MainTheme/"Capital (Base)".play()

func get_current_time():
	return $MainTheme/"Capital (Base)".get_playback_position()

func loop():
	_reset()
	await get_tree().physics_frame
	$"MainTheme/Capital (Base)".play()
	if web:
		var i: int = 1
		for track_name in tracks_playing:
			if tracks_playing[track_name]:
				$MainTheme.get_child(i).play()
			i+=1

func add_track(province: Province):
	var province_name = province.province_name
	#print(province_name)
	var time: float = get_current_time() 
	var track: AudioStreamPlayer
	match province_name:
		"Military":
			track = $MainTheme/Military
		"Farm":
			track = $MainTheme/Farm
		"Town":
			track = $MainTheme/Town
		"Villa":
			track = $MainTheme/Villa
		"City":
			track = $MainTheme/City
		"Port":
			track = $MainTheme/Port
		"Mine":
			track = $MainTheme/Mine
		"Port":
			track = $MainTheme/Port
		"Church":
			track = $MainTheme/Church
		"Outskirts":
			track = $MainTheme/Outskirts
		_:
			print("Error: cannot add music, unknown Province")
			return
	tracks_playing[province_name] = true
	if !web:
		track.volume_linear = 0.0
		track.play(time)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(track, "volume_linear", db_to_linear(default_db), 1.0)
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

#SFX
enum SFX {CLICK, CLICKINVALID, MOUSEOVER, POPUP, POSJINGLE, NEGJINGLE, REVOLT, CHARDEATH, ARMYPLACE}

func play_sfx(SFX_ID: int, change_pitch: bool = true):
	var Audio = $SFX.get_child(SFX_ID)
	if change_pitch:
		Audio.pitch_scale = randf_range(0.8,1.2)
	Audio.play()


func _on_capital_base_finished() -> void:
	loop()
