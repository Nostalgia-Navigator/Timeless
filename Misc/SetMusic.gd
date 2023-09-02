extends Node
@export var stream: AudioStream
func _ready():
	Bgm.stream = stream
	Bgm.volume_db = -10
	Bgm.play()
	queue_free()
