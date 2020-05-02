extends Spatial

export var rotation_speed = PI / 2
export var max_zoom = 3.0
export var min_zoom = 0.5
export var zoom_speed = 0.09

export var ACCELERATION = 1
export var MAX_SPEED = 1
export var FRICTION = 500

var zoom = 1.5
var mouse_sensitivity = 0.005
var velocity = Vector3.ZERO

func _ready():
	pass

func _process(delta):
	#get_input_keyboard(delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, 0)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	handle_movement(delta)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("midMouseButton"):
			if event.relative.x != 0:
				rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity)
			if event.relative.y != 0:
				$InnerGimbal.rotate_object_local(Vector3.RIGHT, -event.relative.y * mouse_sensitivity)
	if event.is_action_pressed("mouseWheelUp"):
		zoom -= zoom_speed
	if event.is_action_pressed("mouseWheelDown"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)

func handle_movement(delta):
	
	var input_vector = Vector3.ZERO
	var rightAmount = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var forwardAmount = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	var right = get_transform().basis.x
	var forward = get_transform().basis.z
	input_vector = right * rightAmount + forward * forwardAmount	
	input_vector = input_vector.normalized()
	
	if (input_vector == Vector3.ZERO):
		velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)
	else:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	var pos = get_translation()
	set_translation(pos + velocity)
