@tool
extends CanvasLayer

signal restart_level

@export var level_num: int:
	set(new_value):
		level_num = new_value

@onready var pause_scene: Control = $PauseScene
@onready var dialog_box: Control = $DialogBox
@onready var text_label: RichTextLabel = $Menu/Top/RichTextLabel

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

func _process(_delta):
	text_label.text = '[center] Level %s' % level_num
