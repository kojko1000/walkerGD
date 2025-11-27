extends Node3D

@onready var sword = $"меч"
@onready var player = $"../.."
@onready var anim = $"меч/AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("git it")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(player.velocity)
	if !anim.is_playing():
		if player.velocity.length()>0.1:
			anim.play("walk")
		if !player.is_sprinting:
			pass
	pass
