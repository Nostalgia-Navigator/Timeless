extends Node

const Goodie = preload("res://Script/Goodie.gd").GoodieType

var levels = [
	level("The Baltic Sea, Northern Europe", 1909,
		[preload("res://Plane/A/BleriotXIMonoplaneCyan.tscn"),
			preload("res://Plane/A/BleriotXIMonoplaneRed.tscn")],
		[preload("res://Plane/B/WrightBFlyerGreen.tscn"),
			preload("res://Plane/B/WrightBFlyerOrange.tscn")],
		[preload("res://Plane/C/WrightMilitaryFlyerOrange.tscn")],
		preload("res://Plane/Boss1.tscn"),
		[],
		[Goodie.crewmate, Goodie.crewmate, Goodie.crewmate, Goodie.crewmate, Goodie.fuel, Goodie.fuel, Goodie.fuel, Goodie.fuel, Goodie.shields, Goodie.shields, Goodie.shields, Goodie.star, Goodie.star, Goodie.time, Goodie.weapon],
		[line("Initial aircraft supplied: J35A Draken", preload("res://Plane/Player.tscn"))],
		300
		),
	level("The Frisian Islands, Germany", 1916,
		[preload("res://Plane/A/Fokker EIII Green.tscn"), preload("res://Plane/A/Fokker EIII White.tscn")],
		[preload("res://Plane/B/Junkers CLI MintGreen.tscn"), preload("res://Plane/B/Junkers CLI YellowGreen.tscn")],
		[preload("res://Plane/C/WrightMilitaryFlyerOrange.tscn")], #placeholder
		preload("res://Plane/Boss1.tscn"),
		[],
		[],
		[],
		300
		)
]

var customLevel = null
func line(desc, scene):
	return {
		"desc": desc,
		"scene": scene
	}
func level(location, year, A, B, C, boss, surfaceTypes, goodieTypes, misc, time):
	return {
		"location": location,
		"year": year,
		"A": A,
		"B": B,
		"C": C,
		"boss": boss,
		"surfaceTypes": surfaceTypes,
		"goodieTypes": goodieTypes,
		"misc": misc,
		"time": time
	}

func get_current_level_desc():
	if customLevel:
		return customLevel
	return levels[currentLevel]

var paused = null

enum Difficulty {
	Trivial, Easy, Medium, Challenging, Diabolical
}

const playerSpeed = {
	Difficulty.Trivial: 12,
	Difficulty.Easy: 16,
	Difficulty.Medium: 20,
	Difficulty.Challenging: 24,
	Difficulty.Diabolical: 28,
}
const planeSpeed = {
	Difficulty.Trivial: 8,
	Difficulty.Easy: 12,
	Difficulty.Medium: 16,
	Difficulty.Challenging: 20,
	Difficulty.Diabolical: 24,
}
const surfaceHP = {
	Difficulty.Trivial: 20,
	Difficulty.Easy: 20,
	Difficulty.Medium: 20,
	Difficulty.Challenging: 20,
	Difficulty.Diabolical: 20,
}

const bulletMinDamageTable = {
	Difficulty.Trivial: 100,
	Difficulty.Easy: 50,
	Difficulty.Medium: 25,
	Difficulty.Challenging: 10,
	Difficulty.Diabolical: 1
	
}

var currentLevel = 0
var difficulty = Difficulty.Diabolical

class Stats:
	var time = 0
	
	var shots = 0
	var hits = 0
	var bullets = 0
	var bombs = 0
	var missiles = 0
	
	func get_accuracy() -> float:
		return float(hits) / shots
	func get_time_taken() -> String:
		var m = int(time / 60)
		var s = int(time - m * 60)
		
		return str(m) + ":" + str(s).pad_zeros(2)
class Destroyed:
	var aircraft = 0
	var blimps = 0
	var helicopters = 0
	var bosses = 0
	var missiles = 0
	var mines = 0
	var land = 0
	var sea = 0
	var boats = 0
class Conduct:
	var goodiesDamaged = 0
	var goodiesDestroyed = 0
	var goodiesCollected = 0
	var sailboatsBombed = 0
	var tankersUsed = 0
var stats = Stats.new()
var destroyed = Destroyed.new()
var conduct = Conduct.new()

var score = 0
var lives = 3
var deaths = 0

func reset_current_stats():
	var l = get_current_level_desc()
	current = Current.new()
	current.timeLeft = l.time
	current.maxTime = l.time
var current = Current.new()
class Current:
	
	var crewmatesSaved = 0
	var shots = 0
	var hits = 0
	var timeLeft = 0
	var maxTime = 300
	var tankerUsed = false
	
	func get_accuracy():
		return float(hits) / shots
		
var allowGunshot = true
func play_sound(stream : AudioStream, soundType):
	
	if soundType == Sounds.Gunshot:
		if !allowGunshot:
			return
		allowGunshot = false
		get_tree().create_timer(0.2).connect("timeout", self, "set", ["allowGunshot", true])
		
	var s := AudioStreamPlayer.new()
	s.stream = stream
	s.volume_db = {
		Sounds.Gunshot: -15,
		Sounds.Hit: -15,
		Sounds.Explosion: -15,
		Sounds.Music: -10,
		Sounds.Menu: -20,
	}[soundType]
	Bgm.add_child(s)
	s.play()
	s.connect("finished", s, "queue_free")

enum Sounds {
	Gunshot, Hit, Explosion, Music, Menu
}
