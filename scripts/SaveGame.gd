extends Resource
class_name SaveGame

const SAVE_GAME_PATH := "user://savegame.tres"

@export var maid_stats : MaidStats = MaidStats.new()


func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> void:
	return ResourceLoader.exists(SAVE_GAME_PATH)
	
static func load_savegame() -> void:
	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
		return ResourceLoader.load(SAVE_GAME_PATH)
