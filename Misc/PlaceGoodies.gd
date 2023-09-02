extends Node3D

@export var debug: bool = false
const Goodie = preload("res://Script/Goodie.gd").GoodieType
@export var goodies # (Array, Goodie)

#STAR, TIME, CREWMATE, SHIELDS, WEAPON, BOMB, FUEL
var map = {
	Goodie.star: preload("res://Goodies/ParachuteStar.tscn"),
	Goodie.time: preload("res://Goodies/ParachuteTime.tscn"),
	Goodie.crewmate: preload("res://Goodies/ParachuteCrewmate.tscn"),
	Goodie.shields: preload("res://Goodies/ParachuteShields.tscn"),
	Goodie.weapon: preload("res://Goodies/ParachuteGun.tscn"),
	#Goodie.GoodieType.BOMB: preload("res://Goodies/ParachuteBomb.tscn"),
	Goodie.fuel: preload("res://Goodies/ParachuteFuel.tscn"),
	Goodie.mystery: preload("res://Goodies/ParachuteMystery.tscn")
	
}

@export var extent: int

# Called when the node enters the scene tree for the first time.
func _ready():
	if !debug:
		goodies = Game.get_current_level_desc().goodieTypes
	if len(goodies) == 0:
		return
	var p = extent * extent
	for type in goodies:
		var goodie = map[type].instantiate()
		add_child(goodie)

		var r = randi()%p
		var x = (r / extent) - extent/2
		var y = (r % extent) - extent/2
		goodie.transform.origin = Vector3(x, 40, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
