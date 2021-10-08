# 2020 Pixel Push Football - Brandon Thacker 

extends RigidBody2D

enum Directions {
	LEFT
	RIGHT
}


var final_force
var off_set = Vector2(0,0)
var is_off_table = false
var shadow_offset = Vector2(5,5)

onready var FatBoyTween = $FatBoyTween
onready var fb_material = $Sprite.get_material()


func start(spawn_position):
	randomize()
	position = spawn_position
	rotation = int(rand_range(0,181))


func _physics_process(_delta):
	if self.position.x > 720 or self.position.x < 0 or self.position.y > 1180 or self.position.y < 100:
		fall_off_table()
	if is_sleeping():
		move()
	var _current_scale = $Sprite.get_scale()
	var _fb_rotation = get_rotation()
	_fb_rotation = -1 * _fb_rotation
	var _new_position = shadow_offset.rotated(_fb_rotation) * (_current_scale - Vector2(.5,.5))
	fb_material.set_shader_param("offset", _new_position)


func move():
	decide_direction()
	apply_impulse(off_set,final_force)


func decide_direction():
	randomize()
	var fiftyFifty = int(rand_range(1,3))
	match fiftyFifty:
		1: left_right(Directions.LEFT)
		2: left_right(Directions.RIGHT)


# based on the current damping and configuration
# we can assume 2250 is half the field, or 360 pixels
# so we can add more complex logic below
# however if the damping, weight, etc every changes......

# based on those settins above, we can convert pixels to force at roughly
# 1 pixel = 6.0 force
# pixels * force = movement

func left_right(direction):
	randomize()
	var distance_available
	var local_force_available
	match direction:
		Directions.LEFT:
			distance_available = self.position.x - 50
			local_force_available = -6.0 * distance_available
		Directions.RIGHT:
			distance_available = 670 - self.position.x
			local_force_available = 6.0 * distance_available
	final_force = Vector2(rand_range(local_force_available, 0), 0)


func _on_fat_boy_body_entered(_body):
	$ImpactSound.play()


func fall_off_table():
	if !is_off_table:
		is_off_table = true
		var _fb_start_size = $Sprite.get_scale()
		var _fb_end_size = Vector2(.6,.6)
		var _fb_param_end = Vector2(0,0)
		$Sprite.z_index = -1
		var _sprite_material = $Sprite.get_material()
		shadow_offset = shadow_offset * 4
		FatBoyTween.interpolate_property($Sprite, "scale", _fb_start_size, _fb_end_size, 1.75, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		FatBoyTween.start()
