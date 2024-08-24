@tool
extends CanvasLayer

signal restart_level

@export var level_num: int:
	set(new_value):
		level_num = new_value

@onready var pause_scene: Control = $PauseScene
@onready var dialog_box: Control = $DialogBox
@onready var level_label: RichTextLabel = $Menu/Top/CenterContainer/Level/RichTextLabel
@onready var timer_label: RichTextLabel = $Menu/Top/HBoxContainer/Right/Timer/RichTextLabel
@onready var timer: Timer = $Timer

var is_restart = false

const LEVEL_SCENE = "res://scenes/LevelMenu/LevelSelector.tscn"

func _ready():
	timer.start()

func get_time_left() -> Array[float]:
	var time_left = timer.time_left
	var minutes = floor(time_left / 60)
	var seconds = int(time_left) % 60
	return [minutes, seconds]

func _on_pause_scene_play():
	pause_scene.hide()

func go_to_level_selector():
	dialog_box.show()

func _on_pause_button_clicked():
	pause_scene.show()

func _on_pause_scene_restart():
	is_restart = true
	dialog_box.show()

func _on_dialog_box_primary_button_clicked():
	if not is_restart:
		get_tree().paused = false
		SceneLoader.load_scene(LEVEL_SCENE, false)
	else:
		restart_level.emit()
		is_restart = false

func _on_dialog_box_secondary_button_clicked():
	dialog_box.hide()

func _process(_delta):
	level_label.text = '[center] Level %s' % level_num
	if not Engine.is_editor_hint():
		timer_label.text = '[center] %02d:%02d' % get_time_left()

func _on_timer_timeout():
	pass
