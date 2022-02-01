extends Spatial

enum GoodieType {STAR, TIME, CREWMATE, SHIELDS, WEAPON, BOMB, FUEL}
export(GoodieType) var goodie
export(Material) var color1
export(Material) var color2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
