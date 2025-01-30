extends CharacterBody2D

const ACCELERATION = 30000
const FRICTION = 30000
const SPEED = 100.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("Up") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY /2
	# Get the input direction and handle the movement/deceleration.	
	var direction := Input.get_axis("Left", "Right")
	if direction != 0:
		velocity.x = move_toward(velocity.x,SPEED*direction, ACCELERATION*delta)	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)

	move_and_slide()
