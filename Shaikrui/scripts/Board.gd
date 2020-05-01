extends Spatial

#graph members
onready var gridMap = $GridMap
onready var levelZeroHeight = $LevelZeroHeight

#internals
var center : Vector3 = Vector3(0,0,0)
var lastHoveredCell = null

func _ready():
	
	var x = gridMap.mesh_library.get_item_list()
	for x in range(-100,100):
		for z in range(-100, 100):
			var item = gridMap.get_cell_item(x,0,z)
			if item != -1:
				print("(%d,%d)" % [x,z])
				#calculate_center(x,z)
				#return

func calculate_center(x,z):
	center.x = 0
	center.z = fmod(z, 3)
	if center.z < 0:
		center.z += 3
	print("center = %d,%d" % [x,center.z])

func _input(event):
	if event is InputEventMouseMotion:
		var cellCoords = find_cell_by_screen_position(event.position)
		if cellCoords == null:
			if lastHoveredCell == null:
				return
			gridMap.set_cell_item(lastHoveredCell.x, lastHoveredCell.y, lastHoveredCell.z, 0)
			lastHoveredCell = null
			return
		lastHoveredCell = cellCoords
		gridMap.set_cell_item(lastHoveredCell.x, lastHoveredCell.y, lastHoveredCell.z, 1)
		
func find_cell_by_screen_position(screenPosition):
	var camera = get_viewport().get_camera()
	var from = camera.project_ray_origin(screenPosition)
	var to = from + camera.project_ray_normal(screenPosition) * 1000
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to)
	if result == null:
		return null
	var position3D = result.get("position")
	if position3D == null:
		return null
	var cellCoordinates = gridMap.world_to_map(position3D)
	var existingCellCoordnates = find_cell_by_cell_coordinates(cellCoordinates)
	return existingCellCoordnates
	
func find_cell_by_cell_coordinates(cellCoordinates):
	var zmod4 = fmod(cellCoordinates.z, 4)
	var zmod8 = fmod(cellCoordinates.z, 8)
	var xmod2 = fmod(cellCoordinates.x, 2)
	if (xmod2 == 0 and zmod8 == 0):
		return cellCoordinates
	if (abs(xmod2) == 1 and abs(zmod8) == 4):
		return cellCoordinates
	return null
