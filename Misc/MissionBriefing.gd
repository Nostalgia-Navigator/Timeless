extends Control


const PlaneHolder = preload("res://Misc/PlaneHolder.tscn")
func _ready():
	var level = Game.get_current_level_desc()
	$Level.text = "Starting level " + str(Game.currentLevel + 1) + ". Location: " + level.location + ". Year: " + str(level.year) + "."
	
	var tp = Vector2(120, 280)
	
	var inc = 90
	displayPlanes(tp, level.A)
	tp.y += inc
	
	displayPlanes(tp, level.B)
	tp.y += inc
	
	displayPlanes(tp, level.C)
	tp.y += inc
	tp.x = 90
	for entry in level.misc:
		var desc = $PlaneDesc.duplicate()
		desc.position = tp
		desc.text = entry.desc
		desc.show()
		add_child(desc)
		display(Vector2(645, tp.y - 120), entry.scene.instantiate().get_body())
		tp.y += inc
		
func displayPlanes(tp, planes):
	
	var desc = $PlaneDesc.duplicate()
	desc.position = tp
	desc.text = planes[0].instantiate().planeName
	desc.show()
	add_child(desc)
	var dy = 120
	if len(planes) == 2:
		display(Vector2(570, tp.y - dy), planes[0].instantiate().get_body())
		display(Vector2(720, tp.y - dy), planes[1].instantiate().get_body())
	else:
		display(Vector2(645, tp.y - dy), planes[0].instantiate().get_body())
func display(tp, body):
	var holder = PlaneHolder.instantiate()
	holder.show()
	holder.position = tp
	holder.get_node("SubViewport/Rig").transform.origin = Vector3(tp.x, 0, tp.y)
	body.get_parent().remove_child(body)
	holder.get_node("SubViewport/Rig/Holder").add_child(body)
	add_child(holder)
