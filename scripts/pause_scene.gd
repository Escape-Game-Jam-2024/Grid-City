extends Control

signal restart
signal play
signal level_selector

@export var show_by_default: bool = false

@onready var animation_player = $AnimationPlayer

func _ready():
	visible = show_by_default

func _on_restart_button_clicked():
	restart.emit()

func _on_play_button_clicked():
	play.emit()

func _on_level_selector_button_clicked():
	level_selector.emit()

func _on_visibility_changed():
	if visible and animation_player:
		get_tree().paused = true
		animation_player.play('start_pause')
	else:
		get_tree().paused = false

