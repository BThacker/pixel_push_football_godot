# 2020 Pixel Push Football - Brandon Thacker 

extends KinematicBody2D

const GAMEPLAY_SPEED = 350

var frenzy_speed
var frenzy_randomness
var velocity = Vector2()
var current_position = Vector2()
var start_direction = TYPE_INT
var field_goal_frenzy = false
var can_field_goal_frenzy_timer = true
var is_second_hit = false
var fgf_timer = null
var fgf_timer_wait = 3
# default to false, only flag if we have a successful kick
var successful_kick = false
var is_initial_check_passed = false
onready var Main = get_tree().get_root().get_node("Main")


func _physics_process(delta):
	var _current_ball_scale = Main.current_ball.get_node("Sprite").get_scale()
	move_and_collide(velocity * delta)
	match field_goal_frenzy:
		true: determine_movement_challenge()
		false: determine_movement_gameplay()
	# Removing the height disable on the field goal to increase difficulty
		#if _current_ball_scale > Vector2(1.75, 1.75):
	#	$CollisionShape2D.set_disabled(true)
	#	$CollisionShape2D2.set_disabled(true)
	#	$SoundDetection/CollisionShape2D.set_disabled(true)
	#	$SoundDetection/CollisionShape2D.set_disabled(true)
	#if _current_ball_scale < Vector2(1.75, 1.75):
	#	$CollisionShape2D.set_disabled(false)
	#	$CollisionShape2D2.set_disabled(false)
	#	$SoundDetection/CollisionShape2D.set_disabled(false)
	#	$SoundDetection/CollisionShape2D2.set_disabled(false)


func start(level):
	match field_goal_frenzy:
		true: challenge(level)
		false: start_gameplay()


func challenge(level):
	randomize()
	velocity = Vector2()
	match level:
		1:
			frenzy_speed = 350
			frenzy_randomness = 0
		2:
			frenzy_speed = 425
			frenzy_randomness = 0

		3:
			frenzy_speed = 500
			frenzy_randomness = 1
		4:
			frenzy_speed = 675
			frenzy_randomness = 2
		5:
			frenzy_speed = 750
			frenzy_randomness = 3

	start_direction = int(rand_range(1,3))
	start_direction = int(rand_range(1,3))
	match start_direction:
		1:
			velocity.x += 1
		2:
			velocity.x -= 1
	velocity = velocity.normalized() * frenzy_speed

func start_gameplay():
	randomize()
	start_direction = int(rand_range(1,3))
	match start_direction:
		1:
			velocity.x += 1
		2:
			velocity.x -= 1
	velocity = velocity.normalized() * GAMEPLAY_SPEED



func determine_movement_challenge():
	current_position = self.position
	# hard limit the sides of the constraint
	if current_position.x > 565:
		velocity = Vector2()
		velocity.x -= 1
	if current_position.x < 155:
		velocity = Vector2()
		velocity.x += 1
	velocity = velocity.normalized() * frenzy_speed
	match frenzy_randomness:
		1:	fgf_timer_wait = rand_range(2,3)
		2:	fgf_timer_wait = rand_range(1,2)
		3: 	fgf_timer_wait = rand_range(0.1, 1.5)
	if can_field_goal_frenzy_timer:
		fgf_timer = Timer.new()
		add_child(fgf_timer)
		fgf_timer.connect("timeout",self, "fgf_randomize_movement")
		fgf_timer.set_wait_time(fgf_timer_wait)
		fgf_timer.set_one_shot(true)
		fgf_timer.start()
		can_field_goal_frenzy_timer = false


func fgf_randomize_movement():
	randomize()
	var randomize_direction = int(rand_range(1,5))
	match randomize_direction:
		1:
			# to prevent repeat instances of a stop condition
			# increase challenge
			if velocity.x == 0:
				velocity = Vector2()
				var _new_direction = int(rand_range(1,3))
				match _new_direction:
					1:
						velocity.x += 1
					2:
						velocity.x -= 1
			else:
				velocity = Vector2()
				velocity.x = 0
		2:
			if velocity.x > 1:
				velocity = Vector2()
				velocity.x -= 1
			if velocity.x < 1:
				velocity = Vector2()
				velocity.x += 1
			if velocity.x == 0:
				velocity = Vector2()
				var rand_decision = int(rand_range(1,3))
				match rand_decision:
					1: velocity.x -= 1
					2: velocity.x += 1
		3, 4:
			if velocity.x == 0:
				var _new_direction = int(rand_range(1,3))
				match _new_direction:
					1:
						velocity.x += 1
					2:
						velocity.x -= 1
			else:
				velocity.x = velocity.x
	velocity = velocity.normalized() * frenzy_speed
	can_field_goal_frenzy_timer = true


func determine_movement_gameplay():
	current_position = self.position
	if current_position.x > 565:
		velocity = Vector2()
		velocity.x -= 1
	if current_position.x < 155:
		velocity = Vector2()
		velocity.x += 1
	velocity = velocity.normalized() * GAMEPLAY_SPEED


func _on_successArea_body_entered(body):
	if is_initial_check_passed and body.is_in_group("football"):
		#$GoalPostTop.set_z_index(10)
		successful_kick = true
		var _movement_timer
		var _delay_time = 1
		_movement_timer = Timer.new()
		_movement_timer.connect("timeout",self, "force_stop_movement")
		_movement_timer.set_wait_time(_delay_time)
		_movement_timer.set_one_shot(true)
		add_child(_movement_timer)
		_movement_timer.start()

func _on_InitialCheck_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("football"):
		is_initial_check_passed = true

func _on_soundDetection_body_entered(body):
	if is_second_hit:
		$SoundGoalPost.volume_db = -15
	if body.is_in_group("football"):
		$SoundGoalPost.play()
		is_second_hit = true
		var _movement_timer
		var _delay_time = 1
		_movement_timer = Timer.new()
		_movement_timer.connect("timeout",self, "force_stop_movement")
		_movement_timer.set_wait_time(_delay_time)
		_movement_timer.set_one_shot(true)
		add_child(_movement_timer)
		_movement_timer.start()

func force_stop_movement():
	velocity = Vector2()



