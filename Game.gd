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
		[line("Initial aircraft supplied: J35A Draken", preload("res://Plane/Player.tscn"))]
		),
]
func line(desc, scene):
	return {
		"desc": desc,
		"scene": scene
	}
func level(location, year, A, B, C, boss, surfaceTypes, goodieTypes, misc):
	return {
		"location": location,
		"year": year,
		"A": A,
		"B": B,
		"C": C,
		"boss": boss,
		"surfaceTypes": surfaceTypes,
		"goodieTypes": goodieTypes,
		"misc": misc
	}

func get_current_level_desc():
	return levels[currentLevel]

enum Difficulty {
	Trivial, Easy, Medium, Challenging, Diabolical
}
var planeSpeed = {
	Difficulty.Trivial: 45,
	Difficulty.Easy: 45,
	Difficulty.Medium: 45,
	Difficulty.Challenging: 45,
	Difficulty.Diabolical: 45,
}
var surfaceHP = {
	Difficulty.Trivial: 20,
	Difficulty.Easy: 20,
	Difficulty.Medium: 20,
	Difficulty.Challenging: 20,
	Difficulty.Diabolical: 20,
}
var currentLevel = 0
var difficulty = Difficulty.Trivial

class Stats:
	var time = 0
	
	var shots = 0
	var hits = 0
	var bullets = 0
	var bombs = 0
	var missiles = 0
	
	func get_accuracy():
		return hits / shots
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