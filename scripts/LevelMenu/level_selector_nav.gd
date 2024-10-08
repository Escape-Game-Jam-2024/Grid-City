extends VBoxContainer

@onready var home_button: TextureButton = $Bottom/HomeButton
@onready var volume_button: TextureButton = $Bottom/VolumeButton
@onready var stageSelectorSound: AudioStreamPlayer2D = $LevelSelectorMusic

const SOUND_ON = 'res://assets/gui/Button/Icon/SoundOn.png'
const SOUND_OFF = 'res://assets/gui/Button/Icon/SoundOff.png'
const HOME_SCENE = "res://scenes/home.tscn"

func _ready():
	stageSelectorSound.play()
	home_button.pressed.connect(load_home_scene)
	volume_button.pressed.connect(toggle_volume)

	volume_button.texture_file = SOUND_ON
	
func load_home_scene():
	SceneLoader.load_scene(HOME_SCENE, false)


func toggle_volume():
	if (volume_button.texture_file == SOUND_ON):
		stageSelectorSound.stop()
		volume_button.texture_file = SOUND_OFF
	else:
		stageSelectorSound.play()
		volume_button.texture_file = SOUND_ON
