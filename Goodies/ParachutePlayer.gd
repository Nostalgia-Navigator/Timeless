extends Spatial

const star = preload("res://Blender/StarParticle.tscn")

const colors = [
	preload("res://Blender/Parachute/ParachuteRed.material"),
	preload("res://Blender/Parachute/ParachuteBlue.material"),
	preload("res://Blender/Parachute/ParachuteWhite.material")
]

func createParticles():
	for i in range(15):
		var s = star.instance()
		var m = colors[i%len(colors)]
		for c in s.get_children():
			if c is MeshInstance:
				c.set_surface_material(0, m)
		var o = $Sideturn.get_global_transform().origin
		s.transform.origin = o
		
		var speed = rand_range(16, 24)
		var angle = randf() * PI * 2
		s.angular_velocity = Vector3(0, randf() * PI*2 + PI*2, 0)
		s.linear_velocity = Vector3(speed*cos(angle), 16, speed*sin(angle))
		get_parent().add_child(s)
		queue_free()
