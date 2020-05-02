extends Spatial

export var ACCELERATION = 1
export var MAX_SPEED = 1
export var FRICTION = 500

var velocity = Vector3.ZERO

func _process(delta):
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if (input_vector == Vector3.ZERO):
		velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)
	else:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)

	translation = translation + velocity
	
func _input(event):
	if event is InputEventMouseMotion:
		if event.is_pressed():
			event
