extends MeshInstance

signal testStuff

func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseButton:
		print("mouse in cell")
