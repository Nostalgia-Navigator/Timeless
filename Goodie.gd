extends Spatial

enum GoodieType {STAR, TIME, CREWMATE, SHIELDS, WEAPON, BOMB, FUEL}
export(GoodieType) var goodie
export(Material) var color1
export(Material) var color2

var vel
func _ready():
	var angle = randf() * PI * 2
	var speed = 3.0 / 15
	vel = Vector3(speed*cos(angle), 0, speed*sin(angle))
func _process(delta):
	transform.origin += vel
