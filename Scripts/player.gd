extends CharacterBody2D



const HAMMER_SCENE = preload("res://Scenes/hammer.tscn")
const ACCELERATION = 30000
const FRICTION = 30000
const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var hammer : Node2D
var hammerLess = false
var time = 0.0

func _ready():
	Global.hammerReturned.connect(_on_hammer_returned)
	
# single input events handled here
func _input(event: InputEvent) -> void:
	if not hammerLess:	
		if event.is_action_pressed("SwingHammer"):
			hammerSwing()
		if event.is_action_pressed("Throw Hammer") and animated_sprite_2d.animation != "swing
		" and $ThrowCooldown.is_stopped():
			hammerThrow()
			
	if event.is_action_pressed("teleport2Hammer") and hammerLess  == true:
		teleport2Hammer()
		
		
# physics dependent events here	(most stuff is)
func _physics_process(delta: float) -> void:
	# Get the input direction/axis
	var inputAxis := Input.get_axis("Left", "Right")
	
	addGravity(delta)
	handleJump()	
	accelOrDeccel(inputAxis, delta)
	updateAnimations(inputAxis)	
	move_and_slide()


#Get mouse x direction relative to player and return as an int	
func getMouseDirX() -> int:
	var mouseDir = 0
	var mousePosX = get_global_mouse_position().x - global_position.x
	if mousePosX >=0:
		mouseDir = 1
	else:
		mouseDir = -1	
	return mouseDir

#-------------MOVEMENT-------------#

#Accel/deccel depending on input or no input	
func accelOrDeccel(inputAxis, delta) -> void:
	if inputAxis != 0:
		velocity.x = move_toward(velocity.x,SPEED*inputAxis, ACCELERATION*delta)	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
		
#Gravity
func addGravity(delta:float)-> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

#High or short jump depending on if key is held
func handleJump()-> void:
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("Up") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY /2

#-----------HAMMER-STUFF-------------#

#Instantiate new hammer scene
func instantiateHammer() -> Node2D:
	var hammerInstance = HAMMER_SCENE.instantiate()
	hammerInstance.position = global_position
	
	#used in hammer.gd
	hammerInstance.direction = getMouseDirX()
	
	get_parent().add_child(hammerInstance)
	return hammerInstance

#Throw hammer from the correct position
#A variable is created of the instance, used in the teleport script
func hammerThrow() -> void:
	hammer = instantiateHammer()
	hammer.position += Vector2(0,-25)
	Global.startThrow.emit()
	hammerLess = true

#Swing hammer left or right depending on mouse dir (+ or - 1)
func hammerSwing() -> void:
	if not hammerLess:
		if $SwingTimer.is_stopped():
			instantiateHammer().position += Vector2(getMouseDirX()*28,-20)
			Global.startSwing.emit()
			animated_sprite_2d.play("swing")
			$SwingTimer.start()

#Teleport to hammer 
func teleport2Hammer() -> void:
	position = hammer.position
	hammer.queue_free()
	Global.hammerReturned.emit()

#Hammer is returned to player
func _on_hammer_returned()-> void:
	$ThrowCooldown.start()
	hammerLess = false

#------ANIMATIONS-------#

#Update anmimations 
func updateAnimations(inputAxis)-> void:
	animated_sprite_2d.scale.x = getMouseDirX()
	if not hammerLess:
		if not (animated_sprite_2d.animation == "swing" and animated_sprite_2d.is_playing()):
			if inputAxis == 0:
				animated_sprite_2d.play("idle")
			else: 
				animated_sprite_2d.scale.x = inputAxis
				animated_sprite_2d.play("run")
			if not is_on_floor():
				animated_sprite_2d.play("jump")		
	else:
		if not (animated_sprite_2d.animation == "swing" and animated_sprite_2d.is_playing()):
			if inputAxis == 0:
				animated_sprite_2d.play("idle_hammerless")
			else: 
				animated_sprite_2d.scale.x = inputAxis
				animated_sprite_2d.play("run_hammerless")
			if not is_on_floor():
				animated_sprite_2d.play("jump_hammerless")

# stop looping hit animation 
func _on_timer_timeout() -> void:
	time +=$SwingTimer.wait_time
	if time > 0.34:
		animated_sprite_2d.stop()
		
