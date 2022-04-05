extends Sprite3D
func _ready():
	if true: return
	call_deferred("_create_collision_polygon")
func _create_collision_polygon():
		var bm = BitMap.new()
		bm.create_from_image_alpha(texture.get_data())
		var pos = transform.origin
		var rect = Rect2(pos.x, pos.z, texture.get_width(), texture.get_height())
		var my_array = bm.opaque_to_polygons(rect, 0.0001)
		var poly = Polygon2D.new()
		poly.set_polygons(my_array)
		var offsetX = 0
		var offsetY = 0
		if (texture.get_width() % 2 != 0):
			offsetX = 1
		if (texture.get_height() % 2 != 0):
			offsetY = 1
			
		var a = Area.new()
		for i in range(poly.polygons.size()):
			var p = CollisionPolygon.new()
			p.depth = 1
			p.rotation_degrees.x = 90
			p.set_polygon(poly.polygons[i])
			
			#p.transform.origin -= Vector3((texture.get_width() / 2) + offsetX, 0, (texture.get_height() / 2) + offsetY) * scale.x
			p.scale = scale
			a.call_deferred("add_child", p)
		call_deferred("add_child", a)
		a.connect("area_entered", self, "on_area_entered")
func on_area_entered(other):
	var p = other.get_parent()
	if p.name == "Bomb":
		p.queue_free()
