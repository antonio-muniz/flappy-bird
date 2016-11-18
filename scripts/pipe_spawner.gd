
extends Node2D

const PIPE_WIDTH = 26;
const PRE_SPAWN_AMOUNT = 3;
const OFFSET_X = 56;
const OFFSET_Y = 56;
const GROUND_HEIGHT = 56;

const scn_pipes = preload("res://scenes/pipes.tscn");

onready var container = get_node("pipe_container");

func _ready():
	var bird = utils.get_main_node().get_node("bird");
	bird.connect("state_changed", self, "_on_bird_state_changed", [], CONNECT_ONESHOT);
	
func _on_bird_state_changed(bird):
	if bird.get_state() == bird.FLAPPING_STATE:
		start();

func start():
	set_fixed_process(true);
	set_initial_position();
	for i in range(PRE_SPAWN_AMOUNT):
		spawn();
		move_forward();
	
func set_initial_position():
	var camera = utils.get_main_node().get_node("camera");
	var initial_x = PIPE_WIDTH/2 + get_viewport_rect().size.width + camera.get_total_position().x;
	set_pos(Vector2(initial_x, get_random_height()));

func spawn():
	var new_pipes = scn_pipes.instance();
	new_pipes.connect("exit_tree", self, "spawn_and_move_forward");
	new_pipes.set_pos(get_pos());
	container.add_child(new_pipes);
	
func move_forward():
	var next_x = get_pos().x + PIPE_WIDTH + OFFSET_X;
	set_pos(Vector2(next_x, get_random_height()));
	
func get_random_height():
	var viewport_size = get_viewport_rect().size;
	var maximum_y = viewport_size.height - OFFSET_Y - GROUND_HEIGHT;
	randomize();
	return rand_range(OFFSET_Y, maximum_y);
	
func spawn_and_move_forward():
	spawn();
	move_forward();