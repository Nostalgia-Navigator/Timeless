extends Spatial

class_name Goodie

enum GoodieType {STAR, TIME, CREWMATE, SHIELDS, WEAPON, BOMB, FUEL}
export(GoodieType) var goodie
export(Material) var color1
export(Material) var color2

const explosion = preload("res://Explosion/Hit.tscn")
signal on_removed
var damaged = false
var vel
func _ready():
	var angle = randf() * PI * 2
	var speed = 3.0 / 15
	vel = Vector3(speed*cos(angle), 0, speed*sin(angle))
func _process(delta):
	transform.origin += vel
	
const debris = preload("res://Effect/Debris.tscn")
const material = preload("res://Blender/ParachuteRed.material")
func damage(projectile):
	
	var e = explosion.instance()
	get_parent().add_child(e)
	e.emitting = true
	e.set_global_transform(projectile.get_global_transform())
	
	var world = projectile.get_parent()
	for i in range(5):
		var d = debris.instance()
		world.add_child(d)
		d.get_node("Body").set_surface_material(0, material)
		d.set_global_transform(projectile.get_global_transform())
		var p = d.get_global_transform().origin
		var angle = randf() * PI * 2
		d.linear_velocity = vel + projectile.vel.normalized() * 2 + 2 * Vector3(cos(angle), 0, sin(angle))
		var m = 90
		d.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
		
	if damaged:
		Game.conduct.goodiesDestroyed += 1
		remove(projectile)
		return
	
	
	Game.conduct.goodiesDamaged += 1
	damaged = true
	$Warning.play("Warn")
	$Flashing.play("Flash")
func remove(source):
	self.emit_signal("on_removed", self, source)
	queue_free()
