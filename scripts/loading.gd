extends VBoxContainer

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var gamePlaySound = $LoadingSound
	
func _on_timer_timeout():
	progress_bar.value += 1
