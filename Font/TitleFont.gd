extends FontFile

func _ready():
	var texture = load("res://Font/OGLS.17100.dat.png")
	var chars = "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
	add_texture(texture)
	for i in range (0, chars.length()):
		add_char(chars.ord_at(i), 0, Rect2(32 * (i % 8), 32 * floor(i / 8), 32, 32), Vector2(0, 0), 10)
