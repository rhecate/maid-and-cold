extends Resource
class_name SaveGame

const SAVE_GAME_PATH := "user://savegame.res"

@export var maid_stats : MaidStats
@export var saw_intro : bool = false

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists():
	return ResourceLoader.exists(SAVE_GAME_PATH)
	
static func load_savegame():
	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
		return ResourceLoader.load(SAVE_GAME_PATH)
