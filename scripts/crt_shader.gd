# Pixel Push Football - 2020 Brandon Thacker  

extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func start():
	var shader_material = load ("res://shaders/crt_material.tres")
	self.set_material(shader_material)

	# this is used to make up for the lack of precision on mobile TIME methods within the shaders
	# the idea is that by attaching it to a cpu cycle instead of a gpu cycle, the shader will not pixelize
	# and end up looking corrupted after a short amount of time
	# check the shader code for crt_material to refrence the changes within tween_timer
	$Tween.interpolate_property(shader_material,
						   "shader_param/tween_timer",
						   0, 999999, 999999,
						   Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()


func end():
	$Tween.stop_all()
	self.set_material(null)
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass