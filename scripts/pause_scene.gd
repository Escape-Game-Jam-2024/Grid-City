extends Control

signal restart
signal play
signal level_selector

@export var show_by_default: bool = false

@onready var animation_player = $AnimationPlayer

var is_ready = false

func _ready():
	visible = show_by_default
	ready.connect(change_ready_status)

func _on_restart_button_clicked():
	restart.emit()

func change_ready_status():
	is_ready = true

func _on_play_button_clicked():
	play.emit()

func _on_level_selector_button_clicked():
	level_selector.emit()

func _on_visibility_changed():
	if not is_ready:
		return
		
	if visible:
		get_tree().paused = true
		animation_player.play('start_pause')
	else:
		get_tree().paused = false
