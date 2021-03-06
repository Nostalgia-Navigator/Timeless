extends Spatial
export(bool) var active = true
onready var planeTypes = get_parent().planeTypes
# Called when the node enters the scene tree for the first time.
func _ready():
	if !active:
		return
	var flight = preload("res://Plane/Flight.tscn").instance()
	var form = Formations.get_random_formation()
	for f in form:
		var plane = planeTypes[randi()%len(planeTypes)].instance()
		flight.add_child(plane)
		plane.transform.origin = f.transform.origin
	
	
	get_parent().call_deferred("add_child", flight)
	flight.transform.origin = transform.origin
	
	#flight.register_planes()
	flight.behavior = flight.BehaviorType.meander
	
	flight.rotation.y = randf() * PI * 2
	queue_free()
