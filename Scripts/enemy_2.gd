extends CharacterBody2D

const DEATH_SCENE = preload("res://Scenes/death_anim.tscn")
const SPEED = 50.0
var player : Node2D
var playerDirection : float
var direction = Vector2.ZERO

func _ready():
	# make a variable with player node for ez access later
	player = get_parent().get_child(1).get_child(0)

func _physics_process(delta: float) -> void:
	move2wardsPlayer(delta,SPEED)


# Enemy moves toward player from wherever it spawns (flying)
func move2wardsPlayer(delta,speed):
	#always move toward player	
	look_at(player.position)
	position += (transform.x * speed * delta)

# death effect
func deathProcess() -> void:
	var death_scene = DEATH_SCENE.instantiate()
	death_scene.position = global_position
	get_tree().root.add_child(death_scene)

func updateAnimations():
	#set direction towards the player
	playerDirection = player.position.x - global_position.x
	if playerDirection >= 0:
		direction.x = 1
	else:
		direction.x = -1	
	#animated_sprite_2d.scale.x = direction.x
	#play anim
