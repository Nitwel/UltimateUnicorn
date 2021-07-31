extends RigidBody2D

onready var just_aired_timer: Timer = $JustAiredTimer
onready var throw_timer = $ThrowTimer

onready var label = $Label

const FLOOR_NORMAL := Vector2.UP

enum {
	IDLE,
	RUN,
	AIR,
	SLIDE,
}

var states_string := {
	IDLE: "idle",
	RUN: "run",
	AIR: "air",
	SLIDE: "slide",
}

export var air_speed := 200.0
export var jump_force := 600.0
const move_accel := 4000
const move_deaccel = 4000
const air_deaccel = 2000
const move_max_vel = 500

var _state: int = IDLE
var throwing = false

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var is_on_ground := false
	var is_on_wall = false
	var wall_index = -1
	var right_wall = true
	var floor_index = -1
	
	print(state.linear_velocity.x)
	
	for x in range(state.get_contact_count()):
		var ci = state.get_contact_local_normal(x)
		
		if ci.dot(Vector2(0, -1)) > 0.6:
			is_on_ground = true
			floor_index = x
			
		var wall_angle = ci.dot(Vector2(1, 0))
		if wall_angle > 0.9:
			is_on_wall = true
			wall_index = x
			right_wall = true
		elif wall_angle < -0.9:
			right_wall = false
			wall_index = x
			is_on_wall = true
			

	var move_direction := get_move_direction()
	
	match _state:
		IDLE:
			if move_direction.x:
				change_state(RUN)
			elif is_on_ground and Input.is_action_just_pressed("jump"):
				apply_central_impulse(Vector2.UP * jump_force)
				change_state(AIR)	
		RUN:
			if state.get_contact_count() == 0:
				change_state(AIR)
			elif is_on_ground and Input.is_action_just_pressed("jump"):
				apply_central_impulse(Vector2.UP * jump_force)
				change_state(AIR)
			else:
				move(state, move_direction)
				
			if state.linear_velocity.x == 0:
				change_state(IDLE)
		AIR:
			move(state, move_direction)
			
			if is_on_ground and just_aired_timer.is_stopped():
				change_state(IDLE)
			elif is_on_wall and just_aired_timer.is_stopped():
				change_state(SLIDE)
		
		SLIDE:
			if is_on_wall and move_direction.x and right_wall == (move_direction.x > 0):
				#state.linear_velocity.x = move_direction.x * air_speed
				pass
			elif state.get_contact_count() == 0:
				change_state(AIR)
			elif is_on_ground and just_aired_timer.is_stopped():
				change_state(IDLE)
			if is_on_wall and Input.is_action_just_pressed("jump"):
				apply_central_impulse(Vector2(-6000 if right_wall else 6000, -600))
				state.linear_velocity.x -6000 if right_wall else 6000
				throwing = true
				change_state(AIR)
	state.linear_velocity.y += 20
	
func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump")
	)
	
func move(state: Physics2DDirectBodyState, move_direction: Vector2) -> void:
	if move_direction.x > 0:
		if state.linear_velocity.x < move_max_vel:
			state.linear_velocity.x += move_accel * state.get_step()
	elif move_direction.x < 0:
		if state.linear_velocity.x > -move_max_vel:
			state.linear_velocity.x -=	move_accel * state.get_step()
	else:
		var abs_x_vel = abs(state.linear_velocity.x)
		if _state == AIR:
			abs_x_vel -= air_deaccel * state.get_step()
		else:
			abs_x_vel -= move_deaccel * state.get_step()
			
		if abs_x_vel < 0:
			abs_x_vel = 0
		state.linear_velocity.x = sign(state.linear_velocity.x) * abs_x_vel
	
func change_state(target_state: int) -> void:
	label.text = states_string[target_state]
	leave_state()
	_state = target_state
	enter_state()
	
func enter_state() -> void:
	match _state:
		IDLE:
			pass
			#linear_velocity.x = 0
		AIR:
			just_aired_timer.start()
		SLIDE:
			gravity_scale = 2
			friction = 0
		_:
			return 

func leave_state() -> void:
	match _state:
		SLIDE:
			gravity_scale = 9
			friction = 0
		_:
			return
	
