extends Node
export(PackedScene) var scene
func clicked():
	get_tree().change_scene_to(scene)
