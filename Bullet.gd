extends Spatial
export(Vector3) var vel
export(int) var damage = 4
export(String, "Plane", "Player") var hit = "Plane"
# Called when the node enters the scene tree for the first time.
func _ready():
	var t = Timer.new()
	t.wait_time = 8
	t.one_shot = true
	t.connect("timeout", self, "queue_free")
	t.connect("timeout", t, "queue_free")
	get_parent().add_child(t)
	t.start()
	
	for c in get_children():
		if c is MeshInstance:
			pass
			#c.set_surface_material(0, c.get_surface_material(0).duplicate())
		
	pass
func _process(delta):
	self.global_translate(vel)
func _on_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group(hit):
		p.on_damage(self)
		self.queue_free()
		return
	if hit == "Plane":
		if area.is_in_group("Goodie"):
			p = area.get_parent().get_parent().get_parent().get_parent()
			p.get_node("Warning").play("Warn")
