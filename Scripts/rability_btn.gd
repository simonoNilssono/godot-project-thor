extends TextureButton
@onready var cooldown: TextureProgressBar = $Cooldown
@export var text: String
@onready var timer: Timer = $Timer

var time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Key.text = text
	cooldown.max_value = timer.wait_time
	set_process(false)

func startTimer():
	timer.start()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cooldown.value = timer.time_left
