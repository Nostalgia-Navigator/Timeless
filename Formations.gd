extends Node
func get_random_formation():
	var c = get_child(randi()%get_child_count())
	var result = []
	for p in c.get_children():
		result.append(p)
	return result
