extends ColorRect

@onready var gridbox = $VBoxContainer/Top/CenterContainer/ClipControl/GridBox
@onready var stars_label = $VBoxContainer/Top/MarginContainer/StarCounter/Content/Stars
@onready var total_stars_label = $VBoxContainer/Top/MarginContainer/StarCounter/Content/TotalStars
@onready var prev_button: Control = $VBoxContainer/Bottom/NavButtons/PrevButton
@onready var next_button: Control = $VBoxContainer/Bottom/NavButtons/NextButton
@onready var nav_buttons_container: HBoxContainer = $VBoxContainer/Bottom/NavButtons

var num_grids = 1
var total_stars = 1
var current_grid = 1
var grid_width = 1
var level_stars: Array[int]
var tween: Tween = null

func _ready():
	level_stars = GameManager.level_stars

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

	prev_button.hide()
	nav_buttons_container.alignment = BoxContainer.ALIGNMENT_END

func toggle_buttons(direction: int = 1):
	if current_grid == 2 and direction == -1:
		nav_buttons_container.alignment = BoxContainer.ALIGNMENT_END
		prev_button.hide()
	elif current_grid == num_grids - 1 and direction == 1:
		nav_buttons_container.alignment = BoxContainer.ALIGNMENT_BEGIN
		next_button.hide()
	else:
		prev_button.show()
		next_button.show()

func tween_animate(direction: int = 1):
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(gridbox, "position:x", gridbox.position.x + direction * grid_width, 0.5)

	await tween.finished

	tween = null

func _on_PrevButton_pressed():
	if tween != null: return

	toggle_buttons(-1)

	if current_grid > 1:
		current_grid -= 1
		tween_animate()

func _on_NextButton_pressed():
	if tween != null: return

	toggle_buttons()

	if current_grid < num_grids:
		current_grid += 1
		tween_animate(-1)

func get_stars():
	var stars = 0
	for star in level_stars:
		stars += star
	return stars
