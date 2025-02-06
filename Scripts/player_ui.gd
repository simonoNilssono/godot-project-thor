extends Control

var throwTime = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hammerReturned.connect(_on_hammer_returned)
	$ThrowCooldown.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
# hammer returned from throw, start cooldown	
func _on_hammer_returned():
	throwCooldown()
	
#start timer, set ui element to visible	
func throwCooldown():
	$ThrowTimer.start()
	$ThrowCooldown.visible = true
	


#set UI to countdown, reset after reaching 0
func _on_throw_timer_timeout() -> void:
	$ThrowCooldown.text = "%.1f" % throwTime
	throwTime -= $ThrowTimer.wait_time
	
	if throwTime < 0:
		$ThrowCooldown.visible = false
		$ThrowTimer.stop()
		throwTime = 3.0
