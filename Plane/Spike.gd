extends Node3D
@export var speed: float
@export var damage: int = randf_range(5, 25)
func _physics_process(delta):
	translate(Vector3(0, 0, speed * delta))
func _on_area_entered(area):
	var p = area.get_parent()
	var n = p.name
	if p.is_in_group("Player"):
		if (p.playing and p.vulnerable):
			p.on_damage(self)
			queue_free()
