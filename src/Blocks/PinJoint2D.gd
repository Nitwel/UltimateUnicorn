extends PinJoint2D


func _physics_process(delta: float) -> void:
	var plank = ($"../RigidBody2D" as RigidBody2D)
	if(plank.rotation_degrees > 70):
		plank.rotation_degrees = 70
	elif(plank.rotation_degrees < -70):		plank.rotation_degrees = -70
	print(plank.rotation_degrees)
