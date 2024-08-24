extends CanvasLayer

signal restart_level

@onready var pause_scene: Control = $PauseScene
@onready var dialog_box: Control = $DialogBox

const LEVEL_SCENE = "res://scenes/LevelMenu/LevelSelector.tscn"

func _on_pause_scene_play():
	pause_scene.hide()

func go_to_level_selector():
	dialog_box.show()

func _on_pause_button_clicked():
	pause_scene.show()

func _on_pause_scene_restart():
	restart_level.emit()

func _on_dialog_box_primary_button_clicked():
	get_tree().paused = false
	SceneLoader.load_scene(LEVEL_SCENE, false)

func _on_dialog_box_secondary_button_clicked():
	dialog_box.hide()
