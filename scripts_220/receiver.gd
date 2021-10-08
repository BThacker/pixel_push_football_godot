# 2020 Pixel Push Football - Brandon Thacker 

extends RigidBody2D

onready var ChallengeControl = get_parent()
onready var ReceiverTween = $ReceiverTween
var is_off_table = false
var can_sound = true
var shadow_offset = Vector2(5,5)
onready var r_material = $Sprite.get_material()

func start(spawn_position):
	randomize()
	rotation = int(rand_range(0,181))
	position = spawn_position


func _physics_process(_delta):
	if self.position.x > 720 or self.position.x < 0 or self.position.y > 1180 or self.position.y < 100:
		fall_off_table()

	var _current_scale = $Sprite.get_scale()
	var _r_rotation = get_rotation()
	_r_rotation = -1 * _r_rotation
	var _new_position = shadow_offset.rotated(_r_rotation) * (_current_scale - Vector2(.5,.5))
	r_material.set_shader_param("offset", _new_position)

func _on_reciever_body_entered(body):
	if body.is_in_group("football"):
		ChallengeControl.shred_the_defense_success = true
		if can_sound:
			$ScoreSound.play()
			can_sound = false

# we are going to duplicate this to try and fix a small bug
# where detections are sometime not picked up by the rigidbody itself
func _on_Area2D_body_entered(body):
	if body.is_in_group("football"):
		ChallengeControl.shred_the_defense_success = true
		if can_sound:
			$ScoreSound.play()
			can_sound = false

func fall_off_table():
	if !is_off_table:
		is_off_table = true
		var _r_start_size = $Sprite.get_scale()
		var _r_end_size = Vector2(.6,.6)
		var _r_param_end = Vector2(0,0)
		$Sprite.z_index = -1
		var _r_param_start = $Sprite.get_material().get_shader_param("offset")
		shadow_offset = shadow_offset * 4
		ReceiverTween.interpolate_property($Sprite, "scale", _r_start_size, _r_end_size, 1.75, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		ReceiverTween.start()
