extends VBoxContainer

@onready var play_button: TextureButton = $Top/CenterContainer/PlayButton
@onready var level_selector_button: TextureButton = $Bottom/LevelSelectorButton
@onready var volume_button: TextureButton = $Bottom/VolumeButton
@onready var home_sound = $HomeScreenSound
@onready var menu_select_sound = $MenuSelectSound

const SOUND_ON = 'res://assets/gui/Button/Icon/SoundOn.png'
const SOUND_OFF = 'res://assets/gui/Button/Icon/SoundOff.png'

var loading_scene = preload("res://scenes/loading.tscn").instantiate()
var level_selector_scene = preload("res://scenes/LevelMenu/LevelSelector.tscn").instantiate()

func _ready():
	home_sound.play()
	play_button.pressed.connect(load_loading_scene)
	volume_button.pressed.connect(toggle_volume)
	level_selector_button.pressed.connect(load_level_selector_scene)

func load_level_selector_scene():
	menu_select_sound.play()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(level_selector_scene)
	
func load_loading_scene():
	menu_select_sound.play()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(loading_scene)

func toggle_volume():
	if (volume_button.texture_file == SOUND_ON):
		volume_button.texture_file = SOUND_OFF
		home_sound.play()
	else:
		volume_button.texture_file = SOUND_ON
		home_sound.stop()
