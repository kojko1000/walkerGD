extends Node3D

@onready var World_Environment = $WorldEnvironment
@onready var sun = $WorldEnvironment/DirectionalLight3D
@onready var day_timer = $WorldEnvironment/DirectionalLight3D/Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	day_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_timer_timeout() -> void:
	sun.rotate_x(0.001) 
	day_timer.start()
	pass # Replace with function body.
