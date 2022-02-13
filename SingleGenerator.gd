extends Spatial

export(Array, Texture) var sprites
export(PackedScene) var scene
func _ready():
	var c = scene.instance()
	c.texture = sprites[randi() % len(sprites)]
	c.transform.origin = transform.origin
	get_parent().call_deferred("add_child", c)
	queue_free()
