extends VBoxContainer

@onready var progress_bar: TextureProgressBar = $ProgressBar

func _on_timer_timeout():
	progress_bar.value += 1
