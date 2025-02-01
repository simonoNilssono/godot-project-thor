extends Area2D
@export var hitpoints = 3
@export var pickup_scene: PackedScene
@export var power_pickup_drop_rate = 0
@export var max_drops = 0
@export var speed = 0
@export var speed_variation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = "Idle"
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.speed_scale = randf_range(1.5, 2.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


"""
func _on_visible_on_screen_notifier_2d_screen_exited():
	print("exited, culled")
	queue_free()
"""
func damage():
	$HitFlashTimer.start()
	$HitSound.play()
	$AnimatedSprite2D.material.set_shader_parameter("onoff", 1)

func kill(body):
	
	#linear_velocity = Vector2(0, -linear_velocity.y/2)
	$AnimatedSprite2D.animation = "Death"
	$AnimatedSprite2D.play()
	$KillSound.play()
	$HurtBox.set_deferred("disabled", true)
	
	# Roll for pickups
	for n in max_drops:
		var r1 = (randf_range(0, 100) + randf_range(0,100))/2
		if r1 < power_pickup_drop_rate:
			var pickup = pickup_scene.instantiate()
			pickup.position = body.position
			
			get_parent().call_deferred("add_child", pickup)


	# Play effect
	
	$Kill.emitting = true
	#var effect = kill_effect.instantiate()
	#effect.position = body.position
	#get_parent()._play_effect(effect)


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Death":
		$AnimatedSprite2D.hide()


func _on_hit_flash_timer_timeout():
	$AnimatedSprite2D.material.set_shader_parameter("onoff", 0)


func _on_kill_finished():
	print("kill finished, culled")
	queue_free()
