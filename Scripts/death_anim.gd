extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles2D.emitting = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
