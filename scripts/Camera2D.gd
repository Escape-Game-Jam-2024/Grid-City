extends Camera2D

var dragging: bool = false
var last_mouse_position: Vector2

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_position = event.position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		var mouse_delta = event.position - last_mouse_position
		position -= mouse_delta
		last_mouse_position = event.position
