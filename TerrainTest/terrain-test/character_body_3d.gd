extends CharacterBody3D

# Настройки движения
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var crouch_speed = 2.5
@export var jump_velocity = 4.5

# Настройки мыши
@export var mouse_sensitivity = 0.002

# Наклон камеры
@export var tilt_intensity = 0.1
@export var tilt_smoothness = 8.0
@export var mouse_tilt_decay = 5.0 # Скорость возврата наклона мыши в центр

# Тряска камеры при движении
@export var bob_frequency = 2.0
@export var bob_amplitude = 0.08
var bob_time = 0.0

# Переменные для управления
var current_speed = 5.0
var is_sprinting = false
var is_crouching = false

# Высота персонажа
var normal_height = 2.0
var crouch_height = 1.0
var base_camera_y = 0.0

# наклон от мыши
var mouse_input_tilt = 0.0 

@onready var camera = $Camera3D
@onready var collision_shape = $CollisionShape3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	normal_height = collision_shape.shape.height
	crouch_height = normal_height * 0.5
	base_camera_y = normal_height - 0.2

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		if is_crouching:
			uncrouch()

	if Input.is_action_pressed("crouch"):
		crouch()
	else:
		uncrouch()
	
	is_sprinting = Input.is_action_pressed("sprint") and is_on_floor() and not is_crouching
	current_speed = sprint_speed if is_sprinting else walk_speed
	if is_crouching:
		current_speed = crouch_speed

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	var target_base_y = (crouch_height - 0.2) if is_crouching else (normal_height - 0.2)
	base_camera_y = lerp(base_camera_y, target_base_y, 10.0 * delta)
	
	# Тряска камеры
	var bob_offset = 0.0
	if is_on_floor() and input_dir != Vector2.ZERO:
		var bob_speed = current_speed
		bob_time += delta * bob_speed
		bob_offset = sin(bob_time * bob_frequency) * bob_amplitude
		var speed_factor = 1.0 if is_sprinting else 0.5
		bob_offset *= speed_factor
	else:
		bob_time = 0.0
	
	camera.position.y = base_camera_y + bob_offset
	
	handle_camera_tilt(input_dir, delta)
	
	move_and_slide()

func handle_camera_tilt(input_dir, delta):
	var move_tilt = 0.0
	if input_dir.x != 0:
		move_tilt = -input_dir.x * tilt_intensity
	
	if is_sprinting and input_dir != Vector2.ZERO:
		move_tilt *= 1.5
	mouse_input_tilt = lerp(mouse_input_tilt, 0.0, mouse_tilt_decay * delta)
	var target_tilt = move_tilt + mouse_input_tilt
	target_tilt = clamp(target_tilt, -0.3, 0.3)
	camera.rotation.z = lerp(camera.rotation.z, target_tilt, tilt_smoothness * delta)

func crouch():
	is_crouching = true
	collision_shape.shape.height = crouch_height

func uncrouch():
	is_crouching = false
	collision_shape.shape.height = normal_height

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)
		
		mouse_input_tilt += -event.relative.x * tilt_intensity * 0.05
		mouse_input_tilt = clamp(mouse_input_tilt, -0.3, 0.3)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
