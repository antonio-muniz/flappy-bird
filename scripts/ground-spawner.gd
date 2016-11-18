
extends Node

const MOVE_DISTANCE = 168;
const PRE_SPAWN_AMOUNT = 2;
const scn_ground = preload("res://scenes/ground.tscn");

onready var container = get_node("ground_container");

func _ready():
	for i in range(PRE_SPAWN_AMOUNT):
		spawn_and_move_forward();

func spawn():
	var new_ground = scn_ground.instance();
	new_ground.connect("exit_tree", self, "spawn_and_move_forward");
	new_ground.set_pos(get_pos());
	container.add_child(new_ground);
	
func move_forward():
	set_pos(get_pos() + Vector2(MOVE_DISTANCE, 0));
	
func spawn_and_move_forward():
	spawn();
	move_forward();