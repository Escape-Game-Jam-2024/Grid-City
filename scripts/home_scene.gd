extends VBoxContainer

@onready var play_button: TextureButton = $Top/CenterContainer/PlayButton
@onready var level_selector_button: TextureButton = $Bottom/LevelSelectorButton
@onready var volume_button: TextureButton = $Bottom/VolumeButton

const SOUND_ON = 'res://assets/gui/Button/Icon/SoundOn.png'
const SOUND_OFF = 'res://assets/gui/Button/Icon/SoundOff.png'
const GAME_SCENE = 'res://scenes/example_game_scene.tscn'

var loading_scene: PackedScene = preload("res://scenes/loading.tscn")
var level_selector_scene: PackedScene = preload("res://scenes/LevelMenu/LevelScreen.tscn")

func _ready():
	play_button.pressed.connect(load_main_scene)
	volume_button.pressed.connect(toggle_volume)
	level_selector_button.pressed.connect(load_level_selector_scene)

	volume_button.texture_file = SOUND_ON

func load_level_selector_scene():
	get_tree().change_scene_to_packed(level_selector_scene)
	
func load_main_scene():
	SceneLoader.load_scene(GAME_SCENE)

func toggle_volume():
	if (volume_button.texture_file == SOUND_ON):
		volume_button.texture_file = SOUND_OFF
	else:
		volume_button.texture_file = SOUND_ON
