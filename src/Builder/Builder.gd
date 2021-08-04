extends Node2D


export(NodePath) var block_path
export var size = Vector2(100, 100) setget set_width
const cam_speed_slow = 1000
const cam_speed_fast = 2000

signal placed(location, node)

onready var cam = $Camera2D

func set_width(newSize: Vector2):
	size = newSize
	cam.limit_right = size.x * 64
	cam.limit_bottom = size.y * 64

func _process(delta):
	var move = get_move_direction()
	var camera_speed = cam_speed_fast if Input.is_action_pressed("sprint") else cam_speed_slow
	if cam.get_camera_screen_center() != cam.position:
		cam.position = cam.get_camera_screen_center()
	cam.position += move * camera_speed * delta
	
	if block_path != "":
		var block = get_node(block_path) as Node2D
		var mouse_pos = get_global_mouse_position()
		block.position = Vector2(floor(mouse_pos.x / 64) * 64 + 64, floor(mouse_pos.y / 64) * 64 + 32)
		
		if Input.is_action_just_pressed("click"):
			emit_signal("placed", block)

func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

func disable():
	pass

func _ready():
	size = Vector2(100, 100)
