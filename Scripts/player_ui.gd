extends Control

var throwTime : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hammerReturned.connect(_on_hammer_returned)
	$ThrowCooldown.visible = false


# hammer returned from throw, start cooldown	
func _on_hammer_returned():
	throwCooldown()
	
#start timer, set ui element to visible	
func throwCooldown():
	$ThrowTimer.start()
	$ThrowCooldown.visible = true
	throwTime = 1.0
	$ThrowCooldown.text = "%.1f" % throwTime
	


#set UI to countdown, reset after reaching 0
func _on_throw_timer_timeout() -> void:
	throwTime -= $ThrowTimer.wait_time
	$ThrowCooldown.text = "%.1f" % throwTime
	
	if throwTime < 0.0:
		$ThrowCooldown.visible = false
		$ThrowTimer.stop()
		$ThrowCooldown.text = ""
