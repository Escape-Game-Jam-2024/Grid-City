extends VBoxContainer

signal timeout

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var timer: Timer = $Timer

const DELAY: float = 0.2

var time_elapsed: float = 0

func _on_timer_timeout():
	if time_elapsed >= DELAY:
		timeout.emit()
		timer.stop()
		
	progress_bar.value += 1
	time_elapsed += timer.wait_time
