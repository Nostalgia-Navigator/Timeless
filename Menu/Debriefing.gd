extends Control

func _ready():
	
	var accuracy = 0.5
	var bonus = accuracy * 2000
	Game.score += bonus
	
	var y = 130
	entry(y, "Bonus for shooting accuracy", str(accuracy * 100) + "%", bonus)
	y += 40
	
	var timeLeft = 274
	bonus = 25 * timeLeft
	Game.score += bonus
	entry(y, "Bonus for time remaining", str(timeLeft) + " seconds", bonus)
	y += 40
	
	var crewSaved = 4
	bonus = 250 * crewSaved
	Game.score += bonus
	entry(y, "Bonus for crewmembers saved", crewSaved, bonus)
	
	var tanker = true
	if tanker:
		bonus = 750
		entry(y, "Bonus for not using tanker", "Awarded", bonus)
		Game.score += bonus
	else:
		entry(y, "Bonus for not using tanker", "Rejected", 0)
	
func entry(y, desc, value, points):
	label(90, y, desc)
	label(150, y, str(value))
	label(210, y, str(points))
func label(x, y, text):
	var l = $Label.duplicate()
	l.show()
	add_child(l)
