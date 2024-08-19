extends VBoxContainer

@onready var play_button: TextureButton = $Top/CenterContainer/PlayButton
@onready var volume_button: TextureButton = $Bottom/VolumeButton

const SOUND_ON = 'res://assets/GUI/Button/Icon/SoundOn.png'
const SOUND_OFF = 'res://assets/GUI/Button/Icon/SoundOff.png'

var loading_scene = preload("res://scenes/loading.tscn").instantiate()

func _ready():
	play_button.pressed.connect(load_loading_scene)
	volume_button.pressed.connect(toggle_volume)

func load_loading_scene():
	# await get_tree().current_scene.tree_exited
	get_tree().root.add_child(loading_scene)

func toggle_volume():
	if (volume_button.texture_file == SOUND_ON):
		volume_button.texture_file = SOUND_OFF
	else:
		volume_button.texture_file = SOUND_ON
