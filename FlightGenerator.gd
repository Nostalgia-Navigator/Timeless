extends Spatial
onready var planeTypes = get_parent().planeTypes
# Called when the node enters the scene tree for the first time.
func _ready():
	var flight = preload("res://Flight.tscn").instance()
	var formations = preload("res://Formations.tscn").instance()
	var form = formations.get_random_formation()
	get_parent().call_deferred("add_child", flight)
	flight.transform.origin = transform.origin
	for f in form:
		var plane = planeTypes[randi()%len(planeTypes)].instance()
		flight.add_child(plane)
		plane.transform.origin = f.transform.origin
	
	flight.register_planes()
	flight.behavior = flight.BehaviorType.meander
	
	flight.rotation.y = randf() * PI * 2
	queue_free()
