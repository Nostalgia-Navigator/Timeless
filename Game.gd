extends Node
var levels = [
	level("The Baltic Sea, Northern Europe", 1909,
		[preload("res://Plane/A/BleriotXIMonoplaneCyan.tscn"),
			preload("res://Plane/A/BleriotXIMonoplaneRed.tscn")],
		[preload("res://Plane/B/WrightBFlyerGreen.tscn"),
			preload("res://Plane/B/WrightBFlyerOrange.tscn")],
		[preload("res://Plane/C/WrightMilitaryFlyerOrange.tscn")],
		preload("res://Plane/Boss1.tscn"),
		[],
		[],
		[line("Initial aircraft supplied: J35A Draken", preload("res://Plane/Player.tscn"))],
		300
		),
]
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
	return levels[currentLevel]

var paused = null

enum Difficulty {
	Trivial, Easy, Medium, Challenging, Diabolical
}
const planeSpeed = {
	Difficulty.Trivial: 45,
	Difficulty.Easy: 45,
	Difficulty.Medium: 45,
	Difficulty.Challenging: 45,
	Difficulty.Diabolical: 45,
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


