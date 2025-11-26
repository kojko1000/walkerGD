extends Node3D

@onready var sky:WorldEnvironment = $WorldEnvironment
@onready var sun = $WorldEnvironment/DirectionalLight3D
@onready var day_timer = $WorldEnvironment/DirectionalLight3D/Timer
# Called when the node enters the scene tree for the first time.
var light_intensity = 0.03

func _ready() -> void:
	day_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	sun.rotate_x(deg_to_rad(0.01)) 
	day_timer.start()
	if((rad_to_deg(sun.rotation.x)>8 and rad_to_deg(sun.rotation.x)<168)  ): #заход 12
		if (sun.light_energy > 0.1):
			sun.light_energy =sun.light_energy- light_intensity
		sun.shadow_enabled = false
		#World_Environment.ambient_light_energy -=light_intensity*0.1
		if  sky.environment.background_energy_multiplier>0.1:
			sky.environment.background_energy_multiplier =sky.environment.background_energy_multiplier- 0.01
		if sky.environment.ambient_light_energy > 0.05:
			sky.environment.ambient_light_energy = sky.environment.ambient_light_energy - 0.01
		#ambient_light_energy
		print("заходим")
	if((rad_to_deg(sun.rotation.x)>168 or rad_to_deg(sun.rotation.x)< 8)): #восход 168
		if (sun.light_energy < 1):
			sun.light_energy = sun.light_energy + light_intensity
		sun.shadow_enabled = true
		if  sky.environment.background_energy_multiplier<1.2:
			sky.environment.background_energy_multiplier =sky.environment.background_energy_multiplier+ 0.01
		if sky.environment.ambient_light_energy < 1:
			sky.environment.ambient_light_energy = sky.environment.ambient_light_energy + 0.01
		print("восходим")
	pass # Replace with function body.
