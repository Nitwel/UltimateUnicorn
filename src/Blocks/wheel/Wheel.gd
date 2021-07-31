extends Node2D

onready var planks = [$Right, $Bottom, $Left, $Top]
export var speed = 0.1
export var radius = 256
var startAngle = 0

func _process(delta):
	planks[0].set_position(rotatePos( startAngle, radius))
	planks[1].set_position(rotatePos( startAngle + PI/2, radius))
	planks[2].set_position(rotatePos( startAngle + PI, radius))
	planks[3].set_position(rotatePos( startAngle + (PI/2 * 3), radius))
	
	startAngle += speed * PI * delta
	
func rotatePos(angle: float, radius: float) -> Vector2:
	return Vector2(cos(angle) *  radius, sin(angle) * radius)
