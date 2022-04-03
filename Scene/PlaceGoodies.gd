extends Spatial

export(Array, Goodie.GoodieType) var goodies

#STAR, TIME, CREWMATE, SHIELDS, WEAPON, BOMB, FUEL
var map = {
	Goodie.GoodieType.STAR: preload("res://Goodies/ParachuteStar.tscn"),
	Goodie.GoodieType.TIME: preload("res://Goodies/ParachuteTime.tscn"),
	Goodie.GoodieType.CREWMATE: preload("res://Goodies/ParachuteCrewmate.tscn"),
	Goodie.GoodieType.SHIELDS: preload("res://Goodies/ParachuteShields.tscn"),
	#Goodie.GoodieType.WEAPON: preload("res://Goodies/ParachuteGun.tscn"),
	#Goodie.GoodieType.BOMB: preload("res://Goodies/ParachuteBomb.tscn"),
	Goodie.GoodieType.FUEL: preload("res://Goodies/ParachuteFuel.tscn")
	
}

export(int) var extent

# Called when the node enters the scene tree for the first time.
func _ready():

	var p = extent * extent
	for type in goodies:
		var goodie = map[type].instance()
		add_child(goodie)

		var r = randi()%p
		var x = (r / extent) - extent/2
		var y = (r % extent) - extent/2
		goodie.transform.origin = Vector3(x, 40, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
