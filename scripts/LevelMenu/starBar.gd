extends HBoxContainer

var active_star = preload("res://assets/GUI/Level/Star/Active.png")
var unactive_star = preload("res://assets/GUI/Level/Star/Unactive.png")

func update_stars(value):
	var num_stars = clamp(value, 0, 3)
	for i in get_child_count():
		if num_stars > i:
			get_child(i).texture = active_star
		else:
			get_child(i).texture = unactive_star
