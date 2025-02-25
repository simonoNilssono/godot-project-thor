extends Node2D
@onready var ground: Polygon2D = $ground/CollisionPolygon2D/Polygon2D
@onready var groundCollision: CollisionPolygon2D = $ground/CollisionPolygon2D
const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
const BIRD_SCENE = preload("res://Scenes/enemy_2.tscn")
var spawnPos1: Vector2
var time: float

#left or right, will be flipped between -1 and 1 in spawn logic for goblin
#to change spawn location
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets ground sprite to be same as collision box
	ground.polygon = groundCollision.polygon
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	$SpawnTimer.start()
	$SpawnBird.start()
	
# single input events handled here
func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()	
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
# spawn goblin enemy	
func spawnEnemy1(spawnDirection):
	var enemy = ENEMY_SCENE.instantiate()
	if spawnDirection > 0:
		enemy.position = $Marker1.position
	else:
		enemy.position = $Marker2.position
	get_tree().root.add_child(enemy)

# spawn goblin enemy	
func spawnEnemy2():
	var enemy = BIRD_SCENE.instantiate()
	enemy.position = $Marker3.position
	get_tree().root.add_child(enemy)

	
# every second flip spawn location, spawn enemy
func _on_spawn_timer_timeout() -> void:
	direction *= -1
	spawnEnemy1(direction)
	

# spawn bird, direciton used for animation flipping
func _on_spawn_bird_timeout() -> void:
	spawnEnemy2()
