extends Control

func next_level():
	if Game.customLevel:
		return
	if Game.currentLevel + 1 < len(Game.levels):
		Game.currentLevel += 1
func _ready():
	if Game.customLevel:
		$Continue.scene = preload("res://Menu/CustomLevel.tscn")
	
	var accuracy = Game.current.get_accuracy()
	var bonus = accuracy * 2000
	Game.score += bonus
	
	var y = 200
	entry(y, "Bonus for shooting accuracy", str(int(accuracy * 100)) + "%", int(bonus))
	y += 80
	
	var timeLeft = Game.current.timeLeft
	bonus = 25 * timeLeft
	Game.score += bonus
	entry(y, "Bonus for time remaining", str(int(timeLeft)) + " seconds", int(bonus))
	y += 80
	
	var crewSaved = Game.current.crewmatesSaved
	bonus = 250 * crewSaved
	Game.score += bonus
	entry(y, "Bonus for crewmembers saved", crewSaved, bonus)
	y += 80
	var tanker = !Game.current.tankerUsed
	if tanker:
		bonus = 750
		entry(y, "Bonus for not using tanker", "Awarded", bonus)
		Game.score += bonus
	else:
		entry(y, "Bonus for not using tanker", "Rejected", 0)
	y += 80
	label(90, y, "Total score: ")
	label(90 + 450, y, str(int(Game.score)))
func entry(y, desc, value, points):
	label(90, y, desc)
	label(90 + 450, y, str(value))
	label(90 + 450 + 250, y, str(points))
func label(x, y, text):
	var l = $Label.duplicate()
	l.rect_position = Vector2(x, y)
	l.text = text
	l.show()
	add_child(l)
