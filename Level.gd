extends Node2D

enum {
	PICK_PHASE,
	PLAY_PHASE,
	END_PHASE
}

var level_state = PICK_PHASE
var current_round =  0
var max_rounds = 10

onready var timer = $Timer
onready var timer_label = $Control/TimerLabel

func start_round():
	current_round += 1
	
	if current_round >= max_rounds:
		level_state = END_PHASE
		
	level_state = PICK_PHASE
	timer.start(5)

func _ready():
	timer.connect("timeout", self, "timer_finished")
	start_round()

func timer_finished():
	if level_state == PICK_PHASE:
		level_state = PLAY_PHASE
	print("Time up")
		
func _process(delta):
	timer_label.text = "%10.f Seconds remaining." % ceil(timer.time_left)
