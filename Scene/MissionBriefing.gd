extends Control
func _ready():
	var level = {
		"number": 1,
		"location": "The Baltic Sea, Northern Europe",
		"year": 1909,
		"A": [preload("res://Plane/A/BleriotXIMonoplaneRed.tscn"), preload("res://Plane/A/BleriotXIMonoplaneCyan.tscn") ],
		"B": [preload("res://Plane/B/WrightBFlyerGreen.tscn"), preload("res://Plane/B/WrightBFlyerOrange.tscn")],
		"C": [preload("res://Plane/C/WrightMilitaryFlyerOrange.tscn")]
	}
	$Level.text = "Starting level " + str(level.number) + ". Location: " + level.location + ". Year: " + str(level.year) + "."
	
	pass
