@tool
extends CanvasLayer

signal restart_level
signal game_over # will be triggered when all the houses light up
signal game_scene_ready

@export var level_num: int:
	set(new_value):
		level_num = new_value

@export var number_of_poles: int:
	set(new_value):
		number_of_poles = new_value

@onready var pause_scene: Control = $PauseScene
@onready var dialog_box: Control = $DialogBox
@onready var level_label: RichTextLabel = $Menu/Top/CenterContainer/Level/RichTextLabel
@onready var timer_label: RichTextLabel = $Menu/Top/HBoxContainer/Right/Timer/RichTextLabel
@onready var pole_picker: Node = $Menu/Bottom/HBoxContainer/PolePicker
@onready var timer: Timer = $Timer

var is_restart = false
var time_elapsed: float = 0
@onready var clickSound: AudioStreamPlayer2D = $Menu/Top/HBoxContainer/BackButton/ClickSound

const LEVEL_SCENE = "res://scenes/LevelMenu/LevelSelector.tscn"
const GAME_OVER_SCENE = "res://scenes/game_over.tscn"

func _ready():
	timer.start()

	game_scene_ready.connect(_on_game_scene_ready)

func _on_game_scene_ready(current_level: int, poles: int):
	level_num = current_level
	pole_picker.game_ui_ready.emit(poles)

func get_formatted_time() -> Array[int]:
	var minutes = floor(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	return [minutes, seconds]

func _on_pause_scene_play():
	clickSound.play()
	pause_scene.hide()

func go_to_level_selector():
	clickSound.play()
	dialog_box.show()

func _on_pause_button_clicked():
	clickSound.play()
	pause_scene.show()

func _on_pause_scene_restart():
	is_restart = true
	dialog_box.show()

func _on_dialog_box_primary_button_clicked():
	clickSound.play()
	get_tree().paused = false
	if not is_restart:
		SceneLoader.load_scene(LEVEL_SCENE, false)
	else:
		restart_level.emit()
		is_restart = false

func _on_dialog_box_secondary_button_clicked():
	clickSound.play()
	dialog_box.hide()

func _process(_delta):
	level_label.text = '[center] Level %s' % level_num
	pole_picker.poles = number_of_poles

	if not Engine.is_editor_hint():
		timer_label.text = '[center] %02d:%02d' % get_formatted_time()

func _on_timer_timeout():
	time_elapsed += 1

func _on_help_button_clicked():
	GameManager.commit_level_results(level_num, true, time_elapsed, pole_picker.poles_remaining)
	SceneLoader.load_scene(GAME_OVER_SCENE, false)
