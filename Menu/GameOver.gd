extends Control
func _ready():
	$L2.text = str(int(Game.score))
	$L4.text = str(Game.deaths)
	$L6.text = Game.Difficulty.keys()[Game.difficulty]
	$L8.text = str(Game.currentLevel + 1)
	$L10.text = Game.stats.get_time_taken()
	$L12.text = 'Unranked'
	$L14.text = str(Game.stats.shots)
	$L16.text = str(Game.stats.hits)
	$L18.text = str(int(Game.stats.get_accuracy() * 100)) + "%"
	$L20.text = str(Game.stats.bullets)
	$L22.text = str(Game.stats.bombs)
	$L24.text = str(Game.stats.missiles)
	
	$L27.text = str(Game.destroyed.aircraft)
	$L29.text = str(Game.destroyed.blimps)
	$L31.text = str(Game.destroyed.helicopters)
	$L33.text = str(Game.destroyed.bosses)
	$L35.text = str(Game.destroyed.missiles)
	$L37.text = str(Game.destroyed.mines)
	
	$L40.text = str(Game.destroyed.land)
	$L42.text = str(Game.destroyed.sea)
	$L44.text = str(Game.destroyed.boats)
	
	$L47.text = str(Game.conduct.goodiesDamaged)
	$L49.text = str(Game.conduct.goodiesDestroyed)
	$L51.text = str(Game.conduct.goodiesCollected)
	$L53.text = str(Game.conduct.sailboatsBombed)
	$L55.text = str(Game.conduct.tankersUsed)
	pass
