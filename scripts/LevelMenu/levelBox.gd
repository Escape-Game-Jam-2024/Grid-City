@tool
extends TextureButton

signal level_selected

@export var locked = true:
	set = set_locked
@export var level_num = 1:
	set = set_level
@export var stars = 1:
	set = set_stars

@onready var label = $Label
@onready var starBar = $StarBar

var unlocked_level = preload("res://assets/gui/Level/Button/Dummy.png")
var locked_level = preload("res://assets/gui/Level/Button/Locked.png")

func set_locked(value):
	locked = value
	if not is_inside_tree():
		await ready
	if(locked):
		self.disabled = true
		label.visible = false
		starBar.visible = false
	else:
		self.disabled = false
		label.visible = true
		starBar.visible = true

func set_level(value):
	level_num = value
	if not is_inside_tree():
		await ready
	label.text = str(level_num)


func _on_gui_input(event):
	if locked:
		return
	if event is InputEventMouseButton and event.pressed:
		level_selected.emit(level_num)
		GameManager.level_selected.emit(level_num)
		SceneLoader.load_scene("res://scenes/game_scene.tscn", true)

func set_stars(value):
	stars = value
	if not is_inside_tree():
		await ready
	starBar.update_stars(value)
