extends TileMap

var fill_grid_size = Vector2i(256, 256)
var grid_size = Vector2i(80, 64)

enum Layers {
	GROUND,
	GRASS,
	ROAD,
	PAVEMENT,
	HOUSE,
}

var city_layout: Array

func _ready():
	GameManager.tilemap = self;
	city_layout = fill_grid_with_zeros()
	
	generate_city_layout() 
	build_city()

func build_city():
	
	for x in range(fill_grid_size.x):
		for y in range(fill_grid_size.y):
			
			if (x == 0 and y == 0) or (x == grid_size.x - 1 and y == grid_size.y - 1):
				
				self.set_cell(Layers.HOUSE, Vector2i(x, y), 0, Vector2i(3, 51)) 
			elif city_layout[x][y] == Layers.GRASS:
				
				self.set_cell(Layers.GRASS, Vector2i(x, y), 0, Vector2i(5, 51)) 
			elif city_layout[x][y] == Layers.ROAD:
				
				self.set_cell(Layers.ROAD, Vector2i(x, y), 0, Vector2i(3, 38))
			elif city_layout[x][y] == Layers.PAVEMENT:
				
				self.set_cell(Layers.PAVEMENT, Vector2i(x, y), 0, Vector2i(21, 40))
			elif city_layout[x][y] == Layers.HOUSE:
		
				var directions = [
					Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1),  # Top-left, top, top-right
					Vector2(0, -1),                   Vector2(0, 1),  # Left,      right
					Vector2(1, -1), Vector2(1, 0), Vector2(1, 1)      # Bottom-left, bottom, bottom-right
				]
				
				if !isAdjacentCellsFilled(x, y, directions, Layers.ROAD):
					self.set_cell(Layers.HOUSE, Vector2i(x, y),0, Vector2i(18, 11))
					#self.set_cell(Layers.HOUSE, Vector2i(x, y), 0, Vector2i(31, 8))
				else:
					self.set_cell(Layers.GRASS, Vector2i(x, y), 0, Vector2i(5, 51)) 
			else:
				self.set_cell(Layers.GROUND, Vector2i(x, y),0, Vector2i(16, 50))

func generate_city_layout() -> void:
	
	generate_roads()
	generate_pavements()
	place_houses()
	fill_grass()

func generate_roads():
	
	# main vertical road
	for x in range(grid_size.x):
		city_layout[x][floor(grid_size.y / 2)] = Layers.ROAD
	
	# main horizontal road
	for y in range(grid_size.y):
		city_layout[floor(grid_size.y / 2)][y] = Layers.ROAD
	
	#var roads_determinant = 2
	#
	#for i in range(roads_determinant):
		#
		#var random_x = randi() % grid_size.x
		#var random_y = randi() % grid_size.y
		#
		#var prev_random_x 
		#var prev_random_y
		#
		#for y in range(grid_size.y):
			#city_layout[y][random_x] = Layers.ROAD
		#for x in range(grid_size.y):
			#city_layout[random_y][x] = Layers.ROAD

func generate_pavements():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.ROAD:
				if y > 0 and city_layout[x][y - 1] == Layers.GROUND:
					city_layout[x][y - 1] = Layers.PAVEMENT
				if y < grid_size.y - 1 and city_layout[x][y + 1] == Layers.GROUND:
					city_layout[x][y + 1] = Layers.PAVEMENT
				if x > 0 and city_layout[x - 1][y] == Layers.GROUND:
					city_layout[x - 1][y] = Layers.PAVEMENT
				if x < grid_size.x - 1 and city_layout[x + 1][y] == Layers.GROUND:
					city_layout[x + 1][y] = Layers.PAVEMENT

func place_houses():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.PAVEMENT and !isNextToHouse(x, y):
				# Randomly place houses next to pavements
				if randi() % 80 == 0:
					if y > 0 and city_layout[x][y - 2] == Layers.GROUND:
						city_layout[x][y - 2] = Layers.HOUSE
					if y < (grid_size.y - 2) and city_layout[x][y + 1] == Layers.GROUND:
						city_layout[x][y + 2] = Layers.HOUSE
					if x > 0 and city_layout[x - 2][y] == Layers.GROUND:
						city_layout[x - 2][y] = Layers.HOUSE
					if x < (grid_size.x - 2) and city_layout[x + 1][y] == Layers.GROUND:
						city_layout[x + 2][y] = Layers.HOUSE

func fill_grass():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.GROUND:
				city_layout[x][y] = Layers.GRASS

func isNextToHouse(x, y) -> bool:
	
	var directions = [
		Vector2(-2, -2), Vector2(-2, 1), Vector2(-2, 2),  # Top-left, top, top-right
		Vector2(1, -2),                   Vector2(1, 2),  # Left,      right
		Vector2(2, -2), Vector2(2, 1), Vector2(2, 2)      # Bottom-left, bottom, bottom-right
	]

	return isAdjacentCellsFilled(x, y, directions, Layers.HOUSE)

func isAdjacentCellsFilled(x, y, directions, layer) -> bool:
	
	for dir in directions:
		var neighbor_x = x + dir.x
		var neighbor_y = y + dir.y
		
		# Check if the new position is within the grid bounds
		if (neighbor_x >= 0 and neighbor_x < grid_size.x) and (neighbor_y >= 0 and neighbor_y < grid_size.y):
			if city_layout[neighbor_x][neighbor_y] >= layer:
				return true
		
	return false

func fill_grid_with_zeros():
	var grid = [] 
	
	for x in range(fill_grid_size.x):
		var row: Array[int] = []
		for y in range(fill_grid_size.y):
			row.append(0)
		grid.append(row)
	
	return grid

func place_object(obj):
	$Node2D.add_child(obj)
