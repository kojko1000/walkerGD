extends Node3D

@onready var sword = $"меч"
@onready var player = $".."
@onready var anim = $"меч/AnimationPlayer"

var atackSwordAnimations = ["atack1","atack2"]
# Called when the node enters the scene tree for the first time.
var runAnimStarted = false
var swordSelect = false
func _ready() -> void:
	sword.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !swordSelect and Input.is_action_just_pressed("1"):
		swordSelect = true
		sword.visible = true
		anim.play("git it")
	elif swordSelect and Input.is_action_just_pressed("1"):
		swordSelect = false
		anim.play_backwards("git it")
		
		
	if swordSelect:
		if runAnimStarted and !player.is_sprinting:
			anim.play_backwards("run")
			runAnimStarted = false
			#--------------------------------
		elif !player.is_sprinting:
			if !anim.is_playing():
				print("aaa")
				if Input.is_action_just_pressed("lkm"):
					var random_index = randi() % atackSwordAnimations.size()
					anim.play(atackSwordAnimations[random_index])
					pass
			#-----------------------------
		elif anim.current_animation!="run" and player.is_sprinting and !runAnimStarted:
			anim.play("run")
			runAnimStarted = true

	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if !swordSelect:
		sword.visible = false
	pass # Replace with function body.
