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
@onready var timer_panel: PanelContainer = $Menu/Top/HBoxContainer/Right/Timer
@onready var timer_label: RichTextLabel = $Menu/Top/HBoxContainer/Right/Timer/RichTextLabel
@onready var pole_picker: Node = $Menu/Bottom/HBoxContainer/PolePicker
@onready var tutorial_dialog: Control = $Tutorial
@onready var timer: Timer = $Timer

var is_restart: bool = false
var time_elapsed: float = 0
@onready var clickSound: AudioStreamPlayer2D = $Menu/Top/HBoxContainer/BackButton/ClickSound

const LEVEL_SCENE = "res://scenes/LevelMenu/LevelSelector.tscn"
const GAME_OVER_SCENE = "res://scenes/game_over.tscn"

var tutorial_intructions: Array = []
var current_instruction_index: int = 0

func _ready():
	timer.start()

	game_scene_ready.connect(_on_game_scene_ready)

	tutorial_intructions = [
		{
			"text": "Welcome to Grid City! In this strategy game, 
			your goal is to connect power poles and light up all the houses in the city.
			Ready to become a master electrician? Let’s get started!",
			"size": Vector2(1200, 600),
			"primary_button_text": "",
			"secondary_button_text": "Next",
			"node": null,
		},
		{
			"text": "The grid consists of housees, roads and pavements. 
			You have to place the poles on the road.
			To place a pole first drag the pole image from the bottom left tool bar or left click on your mouse.
			Subsequently place the pole by left clicking on your mouse.",
			"size": Vector2(1200, 700),
			"primary_button_text": "",
			"secondary_button_text": "Next",
			"node": pole_picker
		},
		{
			"text": "The pole base will turn [color=#ff0000]red[/color] on areas where you are not allowed to place poles 
			[color=#00ff00]green[/color] otherwise. You can cancel a pole selection by right clicking on your mouse and the same
			applies when you want to remove an already placed pole (make sure you right click on the base of the pole). After placing
			two or more poles in the correct position, electricity will appear between them indicating a successful connection. In order
			to light up a house make sure to place the pole near it.",
			"size": Vector2(1500, 900),
			"primary_button_text": "",
			"secondary_button_text": "Next",
			"node": pole_picker
		},
		{
			"text": "Your final score will be determined by the amount of time you took to connect all the houses as well as the number of poles used. 
			Have fun lighting up the city!",
			"size": Vector2(1200, 500),
			"primary_button_text": "Finish",
			"secondary_button_text": "",
			"node": timer_panel
		}
	]

func _on_game_scene_ready(current_level: int, poles: int, is_first_play: bool = false):
	level_num = current_level
	pole_picker.game_ui_ready.emit(poles)

	if is_first_play:
		tutorial_dialog.show()
		set_instruction()

func set_instruction():
	var current_instruction = tutorial_intructions[current_instruction_index]
	
	tutorial_dialog.dialog_box_size = current_instruction["size"]
	tutorial_dialog.dialog_text = current_instruction["text"]
	tutorial_dialog.primary_button_text = current_instruction["primary_button_text"]
	tutorial_dialog.secondary_button_text = current_instruction["secondary_button_text"]

	if current_instruction["node"] != null:
		current_instruction["node"].z_index = 1
		print(current_instruction["node"])

func _on_tutorial_primary_button_clicked():
	tutorial_dialog.hide()
	GameManager.is_first_play = false

func _on_tutorial_secondary_button_clicked():
	var current_instruction = tutorial_intructions[current_instruction_index]

	if current_instruction["node"] != null:
		current_instruction["node"].z_index = 0
	current_instruction_index += 1
	set_instruction()

func get_formatted_time() -> Array[int]:
	var minutes: int = floor(time_elapsed / 60)
	var seconds: int = int(time_elapsed) % 60
	return [minutes, seconds]

func _on_pause_scene_play():
	clickSound.play()
	pause_scene.hide()

func go_to_level_selector():
	clickSound.play()
	dialog_box.show()

	if pause_scene.visible:
		dialog_box.unpause_after_close = false
	else:
		dialog_box.unpause_after_close = true

func _on_pause_button_clicked():
	clickSound.play()
	pause_scene.show()

func _on_pause_scene_restart():
	is_restart = true
	dialog_box.show()

	if pause_scene.visible:
		dialog_box.unpause_after_close = false
	else:
		dialog_box.unpause_after_close = true

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
