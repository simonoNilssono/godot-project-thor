extends CharacterBody2D

const DEATH_SCENE = preload("res://Scenes/death_anim.tscn")
const SPEED = 3000.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var player : Node2D

var playerDirection : float
var direction = Vector2.ZERO
func _ready():
	# make a variable with player node for ez access later
	player = get_parent().get_child(1).get_child(0)
	
	
func _process(_delta) ->void:
	updateAnimations()


func _physics_process(delta: float) -> void:
	addGravity(delta)
	move2wardsPlayer(delta)
	move_and_slide()
	
	
#play death explosion 	
func deathProcess() -> void:
	var death_scene = DEATH_SCENE.instantiate()
	death_scene.position = global_position
	get_tree().root.add_child(death_scene)
	
	
# Enemy moves toward player along the floor
func move2wardsPlayer(delta) -> void:
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
func addGravity(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
func updateAnimations() -> void:
	animated_sprite_2d.play("run")	
