extends CharacterBody2D

#WIP
const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")

const HAMMER_SCENE = preload("res://hammer.tscn")
const ACCELERATION = 30000
const FRICTION = 30000
const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# single input events handled here
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Spawn Enemy"):
		spawnEnemy()	
	if event.is_action_pressed("SwingHammer"):
		hammerSwing(mouseDirX())
	if event.is_action_pressed("Throw Hammer"):
		hammerThrow(mouseDirX())
	
# physics dependent events here	(most stuff is)
func _physics_process(delta: float) -> void:
	addGravity(delta)
	handleJump(delta)
	# Get the input direction/axis
	var direction := Input.get_axis("Left", "Right")
	# Accel or deccel in desired direction depending on input
	accelOrDeccel(direction, delta)
	updateAnimations(direction)
	
	
	move_and_slide()

#for testing
func spawnEnemy():
	var enemy = ENEMY_SCENE.instantiate()
	enemy.position = global_position - Vector2(0,100)
	get_tree().root.add_child(enemy)	


		
		
#Get mouse x pos relative to player	and return as an int	
func mouseDirX() -> float:
	var mouseDir = 0
	var mousePos = get_global_mouse_position().x - global_position.x
	if mousePos >=0:
		mouseDir = 1
	else:
		mouseDir = -1	
	return mouseDir

#Acceleration depending on input or no input	
func accelOrDeccel(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x,SPEED*direction, ACCELERATION*delta)	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
		
#gravity
func addGravity(delta:float)-> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

#High or short jump depending on if key is held 		
func handleJump(delta:float)-> void:
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("Up") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY /2
			
#Instantiate new hammer scene(hitbox)
func instantiateHammer(mouseDirX):
	#flip player if needed	
	animated_sprite_2d.scale.x = mouseDirX	# move to updateAnimations, remove reduntancies 
	
	#instantiate the swing hitbox at correct position away from player
	var hammer = HAMMER_SCENE.instantiate()
	hammer.position = global_position + Vector2(mouseDirX*32,0)
	get_parent().add_child(hammer)	
	return hammer

#Throw hammer	
func hammerThrow(mouseDirX) -> void:
		instantiateHammer(mouseDirX()).hammerThrow()		
		Global.startThrow.emit()


#Swing hammer left or right depending on mouse pos
func hammerSwing(mouseDirX):	
	instantiateHammer(mouseDirX())
	Global.startSwing.emit()
	
#Animations					
func updateAnimations(direction):
		if direction !=0:
			animated_sprite_2d.scale.x = direction
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
		if not is_on_floor():
			animated_sprite_2d.play("jump")	
				
