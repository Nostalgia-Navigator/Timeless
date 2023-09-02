extends Area3D
var contained = {}
func _ready():
	get_parent().get_node("Wraparound").connect("on_wrapped", Callable(self, "on_wrapped"))
func on_wrapped(v):
	return
	var name = ""
	for c in contained:
		if c == null:
			contained.erase(c)
		name = c.name
		c.global_translate(v)
func _on_area_entered(area):
	if area.is_in_group("Ocean"):
		return
	var a = area.name
	var o = area.owner
	if o == null:
		o = area.get_parent()
	var b = o.name
	if o.is_in_group("Plane") and !o.solo:
		return
	if o.is_in_group("Player"):
		return
	contained[o] = true
func _on_area_exited(area):
	var a = area.owner
	if a == null:
		a = area.get_parent()
	contained.erase(a)
	a.disconnect("tree_exited", Callable(self, "remove"))
func _on_body_entered(body):
	contained[body] = true
	body.connect("tree_exited", Callable(self, "remove"))
func _on_body_exited(body):
	contained.erase(body)
	body.disconnect("tree_exited", Callable(self, "remove"))
func remove(a):
	contained.erase(a)
