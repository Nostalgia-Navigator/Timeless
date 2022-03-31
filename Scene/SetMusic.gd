extends Node
export(AudioStream) var stream
func _ready():
	Bgm.stream = stream
	Bgm.play()
	queue_free()
