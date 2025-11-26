extends Node3D

@onready var World_Environment = $WorldEnvironment
@onready var sun = $WorldEnvironment/DirectionalLight3D
@onready var day_timer = $WorldEnvironment/DirectionalLight3D/Timer
# Called when the node enters the scene tree for the first time.
var light_intensity = 0.1

func _ready() -> void:
	day_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(rad_to_deg( sun.rotation.x))
	pass


func _on_timer_timeout() -> void:
	sun.rotate_x(0.01) 
	day_timer.start()
	if(rad_to_deg(sun.rotation.x)>12 and sun.light_energy > 0): #заход
		sun.light_energy -= light_intensity
		print("zahod")
	#if(rad_to_deg(sun.rotation.x)>-168 and sun.light_energy < 10): #восход
		sun.light_energy += light_intensity
	pass # Replace with function body.
