extends ColorRect

@onready var gridbox = $VBoxContainer/Top/CenterContainer/ClipControl/GridBox
@onready var stars_label = $VBoxContainer/Top/MarginContainer/StarCounter/Content/Stars
@onready var total_stars_label = $VBoxContainer/Top/MarginContainer/StarCounter/Content/TotalStars

var num_grids = 1
var total_stars = 1
var current_grid = 1
var grid_width = 1
var level_stars = [3, 2, 1, 2, 1, 0]

func _ready():
	grid_width = gridbox.get_child(0).get_size().x
	# Number all the level boxes
	num_grids = gridbox.get_child_count()
	total_stars = (num_grids * 18) * 3
	stars_label.text = str(get_stars())
	total_stars_label.text = str(total_stars)
	for grid in gridbox.get_children():
		for box in grid.get_children():
			var num = box.get_index() + 1 + 18 * grid.get_index()
			box.level_num = num
			if num > level_stars.size():
				box.locked = true # if it doesnt have a star then its locked
				box.stars = 0
			else:
				box.locked = false
				box.stars = level_stars[num - 1]

func _on_PrevButton_pressed():
	if current_grid > 1:
		current_grid -= 1
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(gridbox, "position:x", gridbox.position.x + grid_width, 0.5)

func _on_NextButton_pressed():
	if current_grid < num_grids:
		current_grid += 1
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(gridbox, "position:x", gridbox.position.x - grid_width, 0.5)

func get_stars():
	var stars = 0
	for star in level_stars:
		stars += star
	return stars
