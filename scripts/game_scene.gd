extends Node2D

@onready var game_ui: CanvasLayer = $InGameUI

var current_level: int

const GAME_SCENE = "res://scenes/game_scene.tscn"

func _ready():
	set_current_level()

	if current_level == 1 and GameManager.is_first_play:
		game_ui.game_scene_ready.emit(current_level, 10, true) # must get config for poles from the game manager
		GameManager.is_first_play = false
	else:
		game_ui.game_scene_ready.emit(current_level, 10)
	
func set_current_level():
	if GameManager.is_play_click:
		current_level = GameManager.current_level
	else:
		current_level = GameManager.selected_level

func _on_in_game_ui_restart_level():
	GameManager.level_selected.emit(current_level)
	SceneLoader.load_scene(GAME_SCENE)
