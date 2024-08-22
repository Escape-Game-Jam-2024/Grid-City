extends CanvasLayer

@onready var back_button: TextureButton = $UI/HBoxContainer/BackButton
@onready var pause_button: TextureButton = $UI/HBoxContainer/PauseButton
@onready var pause_scene: Control = $PauseScene

const LEVEL_SCENE = "res://scenes/LevelMenu/LevelSelector.tscn"

func _ready():
	pause_button.clicked.connect(pause)
	pause_scene.get_node('VBoxContainer/HBoxContainer/PlayButton').clicked.connect(unpause)
	back_button.clicked.connect(change_to_level_scene)

	pause_scene.hide()
	
func pause():
	get_tree().paused = true
	pause_scene.get_node('AnimationPlayer').play('start_pause')
	pause_scene.show()

func unpause():
	get_tree().paused = false
	pause_scene.hide()

func change_to_level_scene():
	SceneLoader.load_scene(LEVEL_SCENE, false)
