# 2020 Pixel Push Football - Brandon Thacker 

extends RigidBody2D

enum difficulty {
	easy,
	medium,
	hard
}
var can_move = true
var _timer = null
var local_difficulty
var local_force
var local_offset


func start(spawn_position):
	randomize()
	position = spawn_position


func _physics_process(_delta):
	if is_sleeping():
		move()


func move():
	decide_direction()
	apply_impulse(local_offset,local_force)


func decide_direction():
	var offSet = Vector2(0,0)
	var distanceForce = Vector2()
	if self.position.x >= 360:
		distanceForce = Vector2(-450, 0)
	if self.position.x <= 360:
		distanceForce = Vector2(450, 0)
	local_force = distanceForce
	local_offset = offSet
