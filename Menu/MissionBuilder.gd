extends Control

var land_bunker = false
var sea_bunker = false
var land_radar = false
var sea_radar = false
var land_cannon = false
var sea_cannon = false

const Goodie = preload("res://Script/Goodie.gd").GoodieType
func _ready():
	$LandBunker.connect("pressed", self, "toggle_land_bunker")
	$SeaBunker.connect("pressed", self, "toggle_sea_bunker")
	$LandRadar.connect("pressed", self, "toggle_land_radar")
	$SeaRadar.connect("pressed", self, "toggle_sea_radar")
	$LandCannon.connect("pressed", self, "toggle_land_cannon")
	$SeaCannon.connect("pressed", self, "toggle_sea_cannon")
	$Exit.scene = load("res://Menu/Title.tscn")
	$Exit.connect("pressed", self, "reset_level")
	$Start.connect("pressed", self, "set_level")
	
	set_alpha($LandBunker, land_bunker)
	set_alpha($SeaBunker, sea_bunker)
	set_alpha($LandRadar, land_radar)
	set_alpha($SeaRadar, sea_radar)
	set_alpha($LandCannon, land_cannon)
	set_alpha($SeaCannon, sea_cannon)
	
func toggle_land_bunker():
	land_bunker = !land_bunker
	set_alpha($LandBunker, land_bunker)
func toggle_sea_bunker():
	sea_bunker = !sea_bunker
	set_alpha($SeaBunker, sea_bunker)
func toggle_land_radar():
	land_radar = !land_radar
	set_alpha($LandRadar, land_radar)
func toggle_sea_radar():
	sea_radar = !sea_radar
	set_alpha($SeaRadar, sea_radar)
func toggle_land_cannon():
	land_cannon = !land_cannon
	set_alpha($LandCannon, land_cannon)
func toggle_sea_cannon():
	sea_cannon = !sea_cannon
	set_alpha($SeaCannon, sea_cannon)
func set_alpha(button, b):
	if b:
		button.modulate.a = 1.0
	else:
		button.modulate.a = 0.4
func reset_level():
	Game.customLevel = null
func set_level():
	var surface = []
	if land_bunker:
		surface.append(preload("res://Surface/LandBunker.tscn"))
	if sea_bunker:
		surface.append(preload("res://Surface/SeaBunker.tscn"))
	if land_radar:
		surface.append(preload("res://Surface/LandRadar.tscn"))
	if sea_radar:
		surface.append(preload("res://Surface/SeaRadar.tscn"))
	if land_cannon:
		surface.append(preload("res://Surface/LandCannon.tscn"))
	if sea_cannon:
		surface.append(preload("res://Surface/SeaCannon.tscn"))
	Game.customLevel = Game.level(null, 0,
		[preload("res://Plane/A/BleriotXIMonoplaneCyan.tscn"),
			preload("res://Plane/A/BleriotXIMonoplaneRed.tscn")],
		[preload("res://Plane/B/WrightBFlyerGreen.tscn"),
			preload("res://Plane/B/WrightBFlyerOrange.tscn")],
		[preload("res://Plane/C/WrightMilitaryFlyerOrange.tscn")],
		preload("res://Plane/Boss1.tscn"),
		surface,
		[Goodie.crewmate, Goodie.crewmate, Goodie.crewmate, Goodie.crewmate, Goodie.fuel, Goodie.fuel, Goodie.fuel, Goodie.fuel, Goodie.shields, Goodie.shields, Goodie.shields, Goodie.star, Goodie.star, Goodie.time, Goodie.weapon],
		[],
		300
		)
	#func level(location, year, A, B, C, boss, surfaceTypes, goodieTypes, misc, time):
