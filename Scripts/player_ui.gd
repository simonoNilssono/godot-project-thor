extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hammerReturned.connect(_on_hammer_returned)
	Global.startThrow.connect(_on_start_throw)
	Global.hover.connect(_on_hover)
	Global.startSwing.connect(_on_start_swing)

#Start swing cooldownand start button cooldown (clockwise effect)
#Disable throw button
func _on_start_swing():
	$SwingTimer.start()
	$M1Btn.startTimer()
	$M2Btn.disabled = true
	
# Hammer in air, enable correct buttons
func _on_start_throw():
	$M1Btn.disabled = true
	$M2Btn.disabled = true
	$RabilityBtn.disabled = false
	$EabilityBtn.disabled = false
	$QBtn.disabled = false

# Hovering, disable hover btn
func _on_hover():
	$EabilityBtn.disabled = true
	
# hammer returned from throw, start throw cooldowns and enable swing btn
func _on_hammer_returned():
	throwCooldown()
	$M1Btn.disabled = false
	

#start throw cooldowns, set cooldowns for btns (clockwise effect)
func throwCooldown():
	$ThrowTimer.start()
	$M2Btn.disabled = false
	$RabilityBtn.disabled = false
	$EabilityBtn.disabled = false
	$QBtn.disabled = false
	$QBtn.startTimer()
	$RabilityBtn.startTimer()
	$EabilityBtn.startTimer()
	$M2Btn.startTimer()
	
#Disable abilities after throw is done
func _on_throw_timer_timeout() -> void:
	$RabilityBtn.disabled = true
	$EabilityBtn.disabled = true
	$QBtn.disabled = true
#swing is done, reenable swing btn
func _on_swing_timer_timeout() -> void:
	$M2Btn.disabled = false
