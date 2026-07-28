extends Node

const save_path = "user://save_info.dat"

var game_save_data: Dictionary = {
	"MasterVolume": 50.0,
	"MusicVolume": 50.0,
	"SfxVolume": 50.0,
	"Fullscreen": false,
	"TutorialCompleted": false,
	"EndingsCompleted": []
}

func _ready() -> void:
	load_data()

func load_data():
	if not FileAccess.file_exists(save_path):
		create_save_data()
		return
		
	var file = FileAccess.open(save_path, FileAccess.READ)
	game_save_data = file.get_var(true)
	file.close()

func get_data(key: String, ending: int = -1):
	if ending == -1:
		return game_save_data[key]
	else:
		return game_save_data[key][ending]

func save_data(key: String, val: Variant, ending: int = -1):
	if ending == -1:
		game_save_data[key] = val
	else:
		game_save_data[key][ending] = val
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(game_save_data,true)
	file.close()

func create_save_data():
	game_save_data["EndingsCompleted"].resize(GameState.Ending.size())
	game_save_data["EndingsCompleted"].fill(false)
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(game_save_data,true)
	file.close()
