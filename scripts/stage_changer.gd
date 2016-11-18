
extends Node

const GAME_STAGE = "res://stages/game_stage.tscn";

signal stage_changed;

var is_changing = false;

func change(scene_path):
	if (is_changing):
		return;
		
	is_changing = true;
	get_tree().get_root().set_disable_input(true);
	
	var animation = get_node("animation");
	animation.play("darken");
	yield(animation, "finished");
	get_tree().change_scene(scene_path);
	emit_signal("stage_changed");
	animation.play("lighten");
	yield(animation, "finished");
	
	get_tree().get_root().set_disable_input(false);
	is_changing = false;
