extends GridMap

#internals
var center : Vector3 = Vector3(0,0,0)

func _ready():
	
	var x = mesh_library.get_item_list()
	for x in range(-100,100):
		for z in range(-100, 100):
			var item = get_cell_item(x,0,z)
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
	if event is InputEventMouseButton:
		var camera = get_viewport().get_camera()
		var position2D = get_viewport().get_mouse_position()
		var dropPlane  = Plane(Vector3(0, 1, 0), 1)
		var world = get_world().direct_space_state
		var position3D = dropPlane.intersects_ray(
			camera.project_ray_origin(position2D),camera.project_ray_normal(position2D)
		)
		var positionMap = world_to_map(position3D)
		print("positionMap:" + String(positionMap))
		var finalMapPosition = Vector3(positionMap.x, 0, positionMap.z)
		var zDif = center.z - fmod(positionMap.z, 3)
		finalMapPosition.z = finalMapPosition.z - zDif
		var cell = get_cell_item(finalMapPosition.x, finalMapPosition.y, finalMapPosition.z)
		set_cell_item(finalMapPosition.x, finalMapPosition.y, finalMapPosition.z,0)
		print("finalMapPosition:" + String(finalMapPosition))
		
	
