tool
extends Node2D
class_name Level

enum {
	PICK_PHASE,
	BUILD_PHASE,
	PLAY_PHASE,
	END_PHASE
}

var level_state = PICK_PHASE
var current_round =  0
var max_rounds = 10

const blocks = [
	"plank4.png",
	"plank6.png"
]

export(NodePath) var ui_path
export(NodePath) var block_container_path
export(NodePath) var player_path

var timer = Timer.new()
var blockNodes = []
var player: Player

func start_round():
	current_round += 1

	if current_round >= max_rounds:
		level_state = END_PHASE

	level_state = PICK_PHASE
	get_ui().set_timer(timer)
	timer.start(1)
	

func _ready():
	if not Engine.editor_hint:
		player = get_node(player_path)
		self.remove_child(player)
		self.add_child(timer)
		timer.one_shot = true
		timer.connect("timeout", self, "timer_finished")
		start_round()

func timer_finished():
	if level_state == PICK_PHASE:
		level_state = PLAY_PHASE
		self.add_child(player)
	print("Time up")
		
func _process(delta):
	pass

func get_ui() -> UI:
	return get_node(ui_path) as UI
	
func get_block_container() -> Node:
	return get_node(block_container_path) as Node

func _get_configuration_warning():
	var warning = []
	if ui_path == "":
		warning.append("The level need to have a UI Node")
	elif not get_node(ui_path) is UI:
		warning.append("The ui node needs to be of type UI")
		
	if block_container_path == "":
		warning.append("The level needs a block container")
		
	if player_path == "":
		warning.append("The level needs a player")
	
	
	return PoolStringArray(warning).join("\n")
