
extends StaticBody2D

onready var camera = utils.get_main_node().get_node("camera");
onready var right = get_node("right");

func _ready():
	set_fixed_process(true);
	add_to_group(game.PIPES_GROUP);

func _fixed_process(delta):
	if camera == null:
		return;
	
	if right.get_global_pos().x < camera.get_total_position().x:
		queue_free();
		emit_signal("exit_tree");