extends Node

@onready var loading_scene: PackedScene = preload("res://scenes/loading.tscn")

var scene_to_load_path: String
var loading_scene_instance: Node
var loading: bool = false
var progress_bar: TextureProgressBar
var timeout_reached: bool = false

func load_scene(path: String, show_loading: bool = true):
	var current_scene: Node = get_tree().current_scene

	if show_loading:
		loading_scene_instance = loading_scene.instantiate()
		get_tree().root.call_deferred("add_child", loading_scene_instance)

		progress_bar = loading_scene_instance.get_node('VBoxContainer/ProgressBar')

		ResourceLoader.load_threaded_request(path)
		
		current_scene.queue_free()

		loading = true
		scene_to_load_path = path

		loading_scene_instance.get_node('VBoxContainer').timeout.connect(set_timeout_reached)
	else:
		if ResourceLoader.has_cached(path):
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(path))
		else:
			get_tree().change_scene_to_packed(ResourceLoader.load(path))

func set_timeout_reached():
	timeout_reached = true

func _process(_delta):
	if (not loading) or (not timeout_reached):
		return
	
	var progress: Array[float] = []
	var status: int = ResourceLoader.load_threaded_get_status(scene_to_load_path, progress)

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value += progress[0] * (100 - progress_bar.value)
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		progress_bar.value = 100

		await get_tree().create_timer(0.1).timeout
		
		var scene_to_load: PackedScene = ResourceLoader.load_threaded_get(scene_to_load_path)

		if scene_to_load != null: get_tree().change_scene_to_packed(scene_to_load)

		if loading_scene_instance != null: loading_scene_instance.queue_free()

		loading = false
	else:
		print("Couldn't load scene")
