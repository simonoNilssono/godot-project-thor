extends CharacterBody2D

const DEATH_SCENE = preload("res://Scenes/death_anim.tscn")
const SPEED = 3000.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var player : Node2D

var playerDirection : float
var direction = Vector2.ZERO
func _ready():
	player = get_parent().get_child(1).get_child(0)
	
	
	
func _process(delta):
	updateAnimations()
	
func deathProcess():
	var death_scene = DEATH_SCENE.instantiate()
	death_scene.position = global_position
	get_tree().root.add_child(death_scene)
	

func _physics_process(delta: float) -> void:
	addGravity(delta)
	move2wardsPlayer(delta)
	move_and_slide()

# Enemy moves toward player along the floor
func move2wardsPlayer(delta):
	if is_on_floor():	
		#set direction towards the player
		playerDirection = player.position.x - global_position.x
		if playerDirection >= 0:
			direction.x = 1
		else:
			direction.x = -1	
		animated_sprite_2d.scale.x = direction.x
		
		#move	
		velocity = direction * SPEED * delta

#add gravity	
func addGravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
func updateAnimations():
	animated_sprite_2d.play("run")	
