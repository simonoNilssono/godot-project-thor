extends Control

var throwTime : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hammerReturned.connect(_on_hammer_returned)
	Global.startThrow.connect(_on_start_throw)
	Global.hover.connect(_on_hover)
	
# Hammer in air, enable buttons
func _on_start_throw():
	$RabilityBtn.disabled = false
	$EabilityBtn.disabled = false

func _on_hover():
	$EabilityBtn.disabled = true
	
# hammer returned from throw, start cooldown
func _on_hammer_returned():
	throwCooldown()
	#cooldown on buttons
	

#start cooldowns, set right texture for buttons
func throwCooldown():
	$ThrowTimer.start()
	$RabilityBtn.disabled = false
	$EabilityBtn.disabled = false
	$RabilityBtn.startTimer()
	$EabilityBtn.startTimer()
	throwTime = 1.0
	
#set UI to countdown, reset after reaching 0
func _on_throw_timer_timeout() -> void:
	
	$RabilityBtn.disabled = true
	$EabilityBtn.disabled = true
