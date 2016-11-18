
extends RigidBody2D

const FLAP_IMPULSE = 150;
const UPWARD_ROTATION_SPEED = 3;
const DOWNWARD_ROTATION_SPEED = 1.5;
const HIT_ROTATION_SPEED = 2;
const MAX_UPWARD_ROTATION = 30;
const BIRD_SPEED = 50;

const FLYING_STATE = 0;
const FLAPPING_STATE = 1;
const HIT_STATE = 2;
const GROUNDED_STATE = 3;

signal state_changed;

onready var state = FlyingState.new(self);

func _ready():
	set_fixed_process(true);
	set_process_input(true);
	add_to_group(game.BIRD_GROUP);
	connect("body_enter", self, "_on_body_enter");

func _fixed_process(delta):
	state.update(delta);
	
func _input(event):
	state.input(event);

func _on_body_enter(other_body):
	if state.has_method("on_body_enter"):
		state.on_body_enter(other_body);

func set_state(new_state):
	state.exit();
	if new_state == FLYING_STATE:
		state = FlyingState.new(self);
	elif new_state == FLAPPING_STATE:
		state = FlappingState.new(self);
	elif new_state == HIT_STATE:
		state = HitState.new(self);
	elif new_state == GROUNDED_STATE:
		state = GroundedState.new(self);
	emit_signal("state_changed", self);
		
func get_state():
	if state extends FlyingState:
		return FLYING_STATE;
	elif state extends FlappingState:
		return FLAPPING_STATE;
	elif state extends HitState:
		return HIT_STATE;
	elif state extends GroundedState:
		return GROUNDED_STATE;


class FlyingState:
	var bird;
	var previous_gravity_scale;
	
	func _init(bird):
		self.bird = bird;
		previous_gravity_scale = bird.get_gravity_scale();
		bird.set_gravity_scale(0);
		bird.get_node("animation").play("flying");
		bird.set_linear_velocity(Vector2(BIRD_SPEED, bird.get_linear_velocity().y));
	
	func update(delta):
		pass;
		
	func input(event):
		pass;
		
	func exit():
		bird.get_node("animation").stop();
		bird.get_node("sprite").set_pos(Vector2(0,0));
		bird.set_gravity_scale(previous_gravity_scale);
		
		
class FlappingState:
	var bird;
	
	func _init(bird):
		self.bird = bird;
		bird.set_linear_velocity(Vector2(BIRD_SPEED, bird.get_linear_velocity().y));
		flap();
	
	func update(delta):
		if bird.get_rotd() > MAX_UPWARD_ROTATION:
			bird.set_rotd(MAX_UPWARD_ROTATION);
			bird.set_angular_velocity(0);
		if bird.get_linear_velocity().y > 0:
			bird.set_angular_velocity(DOWNWARD_ROTATION_SPEED);
		
	func input(event):
		if event.is_action_pressed("flap"):
			flap();
		
	func exit():
		pass;
		
	func flap():
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, -FLAP_IMPULSE));
		bird.set_angular_velocity(-UPWARD_ROTATION_SPEED);
		bird.get_node("animation").play("flap");
	
	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUND_GROUP):
			bird.set_state(bird.GROUNDED_STATE);
		elif other_body.is_in_group(game.PIPES_GROUP):
			bird.set_state(bird.HIT_STATE);
		
class HitState:
	var bird;
	
	func _init(bird):
		self.bird = bird;
		bird.set_linear_velocity(Vector2(0, 0));
		bird.set_angular_velocity(HIT_ROTATION_SPEED);
		var pipe = bird.get_colliding_bodies()[0];
		bird.add_collision_exception_with(pipe);
	
	func update(delta):
		pass;
		
	func input(event):
		pass;
		
	func exit():
		pass;
	
	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUND_GROUP):
			bird.set_state(bird.GROUNDED_STATE);
		
class GroundedState:
	var bird;
	
	func _init(bird):
		self.bird = bird;
		bird.set_linear_velocity(Vector2(0, 0));
		bird.set_angular_velocity(0);
	
	func update(delta):
		pass;
		
	func input(event):
		pass;
		
	func exit():
		pass;
