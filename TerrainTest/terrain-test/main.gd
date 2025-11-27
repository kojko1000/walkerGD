extends Node3D

@onready var sky:WorldEnvironment = $WorldEnvironment
@onready var sun = $WorldEnvironment/DirectionalLight3D
@onready var day_timer = $WorldEnvironment/DirectionalLight3D/Timer
@onready var fog_timer = $WorldEnvironment/DirectionalLight3D/fogChanceTimer
# Called when the node enters the scene tree for the first time.
var light_intensity = 0.03
var is_fog = false
var fog_duration = 0
var fog_duration_now = 0
var fog_strenge = 0

func _ready() -> void:
	day_timer.start()
	fog_timer.start()
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
			sky.environment.background_energy_multiplier =sky.environment.background_energy_multiplier- 0.001
		if sky.environment.ambient_light_energy > 0.25:
			sky.environment.ambient_light_energy = sky.environment.ambient_light_energy - 0.001
		#ambient_light_energy
		#print("заходим")
	if((rad_to_deg(sun.rotation.x)>168 or rad_to_deg(sun.rotation.x)< 8)): #восход 168
		if (sun.light_energy < 1):
			sun.light_energy = sun.light_energy + light_intensity
		sun.shadow_enabled = true
		if  sky.environment.background_energy_multiplier<1.2:
			sky.environment.background_energy_multiplier =sky.environment.background_energy_multiplier+ 0.001
		if sky.environment.ambient_light_energy < 1:
			sky.environment.ambient_light_energy = sky.environment.ambient_light_energy + 0.001
		#print("восходим")
	pass # Replace with function body.


func _on_fog_chance_timer_timeout() -> void:
	print(is_fog)
	print(fog_strenge)
	print(fog_duration)
	sky.environment.volumetric_fog_enabled = is_fog
	if !is_fog:
		if sky.environment.volumetric_fog_density>0:
			sky.environment.volumetric_fog_density = sky.environment.volumetric_fog_density - 0.001
		if randf_range(-20,80000) <0:
			is_fog = true
			fog_duration = randi_range(1,1000)
			fog_strenge = randf_range(1,150)/1000
	elif is_fog:
		if fog_duration_now<fog_duration:
			fog_duration_now=fog_duration_now+1
		elif fog_duration<=fog_duration_now:
			is_fog = false
			fog_duration_now = 0
		if sky.environment.volumetric_fog_density<fog_strenge:
			sky.environment.volumetric_fog_density = sky.environment.volumetric_fog_density + 0.001
	pass # Replace with function body.
