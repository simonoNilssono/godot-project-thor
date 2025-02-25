extends CharacterBody2D

const DEATH_SCENE = preload("res://Scenes/death_anim.tscn")
const SPEED = 100.0
var player : Node2D
var playerDirection : float
var xDirection = Vector2.ZERO

func _ready():
	# make a variable with player node for ez access later
	player = get_parent().get_child(1).get_child(0)

func _physics_process(delta: float) -> void:
	move2wardsPlayer(delta,SPEED)


# Enemy moves toward player from wherever it spawns (flying)
func move2wardsPlayer(delta,speed):

	var direction = global_position.direction_to(player.position)
	velocity = direction * SPEED
	move_and_slide()
	
# death effect
func deathProcess() -> void:
	var death_scene = DEATH_SCENE.instantiate()
	death_scene.position = global_position
	get_tree().root.add_child(death_scene)

#animations, flip sprite depending on x-position relative to player
func updateAnimations():
	#set direction towards the player
	playerDirection = player.position.x - global_position.x
	if playerDirection >= 0:
		xDirection.x = 1
	else:
		xDirection.x = -1	
	#animated_sprite_2d.scale.x = direction.x
	#play anim
