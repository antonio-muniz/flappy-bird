
extends Area2D

func _ready():
	connect("body_enter", self, "_on_body_enter");

func _on_body_enter(other_body):
	if other_body.is_in_group(game.BIRD_GROUP):
		game.current_score += 1;
		# increase score