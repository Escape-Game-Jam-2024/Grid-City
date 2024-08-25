extends VBoxContainer

@onready var message_label: RichTextLabel = $Top/MarginContainer/Message
@onready var stars_container: HBoxContainer = $Top/Stars
@onready var unactive_star: TextureRect = $Top/Stars/Unactive
@onready var active_star: TextureRect = $Top/Stars/Active
@onready var score_label: RichTextLabel = $Top/Score
@onready var next_button: TextureButton = $Bottom/NextButton
@onready var restart_button: TextureButton = $Bottom/RestartButton
@onready var level_selector: TextureButton = $Bottom/LevelSelector

var level_results: Dictionary
var last_level_played: int
var num_of_stars: int
var duplicate_stars: Array[TextureRect] = []

const GAME_SCENE = "res://scenes/game_scene.tscn"
const LEVEL_SCENE = "res://scenes/LevelMenu/LevelSelector.tscn"

func _ready():
	restart_button.clicked.connect(_on_restart_button_clicked)
	next_button.clicked.connect(_on_next_button_clicked)
	level_selector.clicked.connect(_on_level_selector_clicked)

	last_level_played = GameManager.last_level_played
	level_results = GameManager.level_results[last_level_played]
	num_of_stars = level_results["stars"]

	set_message()
	set_stars()
	score_label.text = "[center]SCORE: %s" % level_results["score"]

	if num_of_stars > 0:
		next_button.show()

func _on_restart_button_clicked():
	GameManager.level_selected.emit(last_level_played)
	SceneLoader.load_scene(GAME_SCENE)

func _on_next_button_clicked():
	GameManager.play_clicked.emit()
	SceneLoader.load_scene(GAME_SCENE)

func _on_level_selector_clicked():
	SceneLoader.load_scene(LEVEL_SCENE, false)
	print("level selector clicked")

func set_message():
	if num_of_stars > 0:
		message_label.text = "[center]LEVEL COMPLETE"
	else:
		message_label.text = "[center]SORRY, TRY AGAIN!"

func create_duplicate_star(ref_star: TextureRect):
	var duplicate_star = ref_star.duplicate()
	duplicate_star.visible = true
	stars_container.add_child(duplicate_star)
	duplicate_stars.append(duplicate_star)

func set_stars():
	var last_star_index: int = 0

	for i in range(num_of_stars):
		create_duplicate_star(active_star)
		last_star_index = i
	
	for j in range(last_star_index, 3):
		create_duplicate_star(unactive_star)

func _exit_tree():
	for star in duplicate_stars:
		stars_container.remove_child(star)
		star.free()
	queue_free()
