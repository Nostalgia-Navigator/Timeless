extends AnimationPlayer
func intro_done(a):
	if a == "Takeoff":
		play("CarrierLeave")
	else:
		queue_free()
