# Pixel Push Football - 2020 Brandon Thacker 

extends RigidBody2D

onready var ChallengeControl = get_parent()
onready var ReceiverTween = $ReceiverTween
var is_off_table = false
var can_sound = true


func start(spawn_position):
	randomize()
	rotation = int(rand_range(0,181))
	position = spawn_position


func _physics_process(_delta):
	if self.position.x > 720 or self.position.x < 0 or self.position.y > 1180 or self.position.y < 100:
		fall_off_table()

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
		var _r_end_size = Vector2(.5,.5)
		var _r_param_end = Vector2(0,0)
		$Sprite.z_index = -1
		var _sprite_material = $Sprite.get_material()
		_sprite_material.set_shader_param("offset", Vector2(16,16))
		var _r_param_start = $Sprite.get_material().get_shader_param("offset")
		ReceiverTween.interpolate_property($Sprite, "scale", _r_start_size, _r_end_size, 1.75, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		ReceiverTween.interpolate_property($Sprite.get_material(), "shader_param/offset", _r_param_start, _r_param_end, 1.75, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		ReceiverTween.start()
