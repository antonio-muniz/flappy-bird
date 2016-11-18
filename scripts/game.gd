
extends Node

const BIRD_GROUP = "bird";
const GROUND_GROUP = "ground";
const PIPES_GROUP = "pipes";

signal current_score_changed;
signal best_score_changed;

var current_score = 0 setget _on_current_score_changed;
var best_score = 0 setget _on_best_score_changed;

func _ready():
	stage_changer.connect("stage_changed", self, "_on_stage_changed");

func _on_stage_changed():
	current_score = 0;

func _on_current_score_changed(value):
	current_score = value;
	emit_signal("current_score_changed");
	
func _on_best_score_changed(value):
	best_score = value;
	emit_signal("best_score_changed");