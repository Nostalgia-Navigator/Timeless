extends Node3D

@export var sprites # (Array, Texture2D)
@export var scene: PackedScene
func _ready():
	var c = scene.instantiate()
	c.texture = sprites[randi() % len(sprites)]
	c.transform.origin = transform.origin
	get_parent().call_deferred("add_child", c)
	queue_free()
