extends Node2D
@onready var ground: Polygon2D = $ground/CollisionPolygon2D/Polygon2D
@onready var groundCollision: CollisionPolygon2D = $ground/CollisionPolygon2D
const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
var spawnPos1: Vector2
var time: float
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets ground sprite to be same as collision box
	ground.polygon = groundCollision.polygon
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	$SpawnTimer.start()
	
# single input events handled here
func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()	
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func spawnEnemy1(direction):
	var enemy = ENEMY_SCENE.instantiate()
	enemy.position.y = get_parent().position.y +50
	enemy.position.x = direction *((get_viewport_rect().size / 16).x)
	get_tree().root.add_child(enemy)
	print(((get_viewport_rect().size / 16).x))

func _on_spawn_timer_timeout() -> void:
	#direction *= -1
	spawnEnemy1(direction)
	
