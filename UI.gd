extends CanvasLayer
class_name UI

onready var timer_label = $TimerLabel
onready var box = $Box
onready var blocks_container = $Blocks
onready var blocks_show = $Box/BlocksShow

var rng = RandomNumberGenerator.new()
var timer: Timer

func set_timer(src_timer: Timer):
	timer = src_timer
	timer.connect("timeout", self, "timer_end")

func start():
	box.show()
	timer_label.show()
	show_random_blocks()

func _process(delta):
	if timer_label.is_visible_in_tree() and timer is Timer:
		timer_label.text = "%10.f Seconds remaining." % ceil(timer.time_left)

func timer_end():
	box.hide()
	timer_label.hide()

func show_random_blocks():
	rng.randomize()
	for i in range(1):
		var block = blocks_container.get_child(rng.randi_range(0, blocks_container.get_child_count() - 1)).duplicate() as Node2D
		blocks_show.add_child(block)
		disable_collision_recursive(block)
		block.position = Vector2(rng.randi_range(-200, 200), rng.randi_range(-200, 200))
		
func _ready():
	blocks_container.hide()
#	set_timer(Timer.new())
#	timer.start(10)
#	start()

func disable_collision_recursive(node: Node):
	if not node is Node:
		return
		
	if node is CollisionShape2D:
		node.disabled = true
		
	if node.get_child_count() == 0:
		return
		
	for child_node in node.get_children():
		disable_collision_recursive(child_node)
