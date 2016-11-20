
extends Node

func get_main_node():
	var root = get_tree().get_root();
	return root.get_child(root.get_child_count() - 1);

func get_digits(number):
	var string_number = str(number);
	var digits = [];
	for i in range(string_number.length()):
		digits.append(string_number[i].to_int());
	return digits;