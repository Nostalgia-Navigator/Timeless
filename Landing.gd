extends Spatial

const wraparound = 288
var player
var d=0
func _ready():
	player = get_tree().get_root().get_node("Main/Player")
func _process(delta):
	d += delta
	if d > 1:
		var dx = transform.origin.x - player.transform.origin.x
		if dx < -wraparound:
			transform.origin.x += 2 * wraparound
		elif dx > wraparound:
			transform.origin.x -= 2 * wraparound
		var dz = transform.origin.z - player.transform.origin.z
		if dz < -wraparound:
			transform.origin.z += 2 * wraparound
		elif dz > wraparound:
			transform.origin.z -= 2 * wraparound
		d = 0
func _on_area_entered(area):
	var n = area.get_parent()
	
	if n.is_in_group("Player") and n.playing:
		n.playing = false
		var p = n.get_parent()
		p.remove_child(n)
		$PlayerHolder.add_child(n)
		
		#var pos = n.get_global_transform().origin
		#var pos2 = $PlayerHolder.get_global_transform().origin
		#n.transform.origin = pos2
		n.rotation = Vector3(0, PI, 0)
		n.transform.origin = Vector3(0, 0, 0)
		n.exhaust.emitting = false
		n.get_node("AnimationPlayer").play("RESET")
		$Animation.play("Landing")
	pass # Replace with function body.
