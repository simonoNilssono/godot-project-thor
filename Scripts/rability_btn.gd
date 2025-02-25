extends TextureButton
@onready var cooldown: TextureProgressBar = $Cooldown
@export var text: String
@export var timer: float

var time = 1.0

#set up variables so that they can be exported and changed in the editor 
#in the future. 
#disable process.
func _ready() -> void:
	$Key.text = text
	$Timer.wait_time = timer
	cooldown.max_value = $Timer.wait_time
	set_process(false)

#start process (cooldown timer / animation)
func startTimer():
	$Timer.start()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cooldown.value = $Timer.time_left
