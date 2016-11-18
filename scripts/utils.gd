
extends Node

func get_main_node():
	var root = get_tree().get_root();
	return root.get_child(root.get_child_count() - 1);
