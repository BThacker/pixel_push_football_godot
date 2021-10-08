# 2020 Pixel Push Football - Brandon Thacker 

extends RigidBody2D

signal turn_ended

var max_velocity = 4200

enum Turn{AI, BOT, TOP, CHALLENGE_PRACTICE}

onready var Main = get_parent()
onready var ThemeControl = Main.get_node("ThemeControl")
onready var MenuControl = get_parent().get_node("MenuControl")
onready var Ghost = preload("res://ghost.tscn")
onready var TouchZone = $TouchZone
onready var FootballTween = $FootballTween
onready var FallTween = $FallTween
onready var FlyTween = $FlyTween
onready var Instructions = $Instructions
onready var ball_material = $Sprite.get_material()
var current_turn
var new_position = Vector2()
var last_position = Vector2()
var can_emit_sound = true
var can_show_zone = false
var _timer = null
var player_moved = false
var ai_applied_force = false
var ai_moved = false
var turn_ended = false
var far_off_board = false
var off_board = false
var is_tz_alive = false
var is_falling = false
var ball_shadow_offset = Vector2(6,6)
var last_shadow_position
var can_spawn_trail = false
var is_field_goal_kick = false
var is_flying = false
var instructions_alive = false
var spawning = true


func start(ball_position, rotation_degrees):
	randomize()
	var _ball_start_size_y
	var _ball_start_size_x
	var _ball_start_size
	var _fifty_fifty = int(rand_range(1,3))
	match _fifty_fifty:
		1:
			_ball_start_size_x = rand_range(5, 8)
			_ball_start_size_y = rand_range(1, 8)
			_ball_start_size = Vector2(_ball_start_size_x, _ball_start_size_y)
		2:
			_ball_start_size_x = rand_range(1, 8)
			_ball_start_size_y = rand_range(5, 8)
			_ball_start_size = Vector2(_ball_start_size_x, _ball_start_size_y)

	var _ball_end_size = Vector2(1,1)
	var _ball_start_rotation = int(rand_range(1, 360))
	var _ball_end_rotation = rotation_degrees
	# so we can flip the detection zones
	if ThemeControl.selected_ball == ThemeControl.league_ball_pro_round:
		$TriangleCollision.disabled = true
		$RoundCollision.disabled = false
	if ThemeControl.selected_ball == ThemeControl.league_ball_college_round:
		$TriangleCollision.disabled = true
		$RoundCollision.disabled = false
	position = ball_position
	# apply correct ball on start
	$Sprite.set_texture(ThemeControl.selected_ball)
	FallTween.interpolate_property($Sprite, "scale", _ball_start_size, _ball_end_size, .85, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	FallTween.interpolate_property(self, "rotation_degrees", _ball_start_rotation, _ball_end_rotation, .85, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	FallTween.start()
	connect("turn_ended", get_parent(), "_on_turn_ended")
	# we want the instructions to ignore global transform
	Instructions.set_as_toplevel(true)


func _integrate_forces(state):
	if far_off_board:
		state.linear_velocity = Vector2()
		state.angular_velocity = 0
	if abs(get_linear_velocity().x) > max_velocity or abs(get_linear_velocity().y) > max_velocity:
		var _new_velocity = get_linear_velocity().normalized()
		_new_velocity *= max_velocity
		set_linear_velocity(_new_velocity)


func _physics_process(_delta):
	# rotate ball shadow vector math
	var _current_velocity
	var _current_scale = $Sprite.get_scale()
	var _flying_scale
	var _new_scale
	var _new_offset
	_new_offset = ball_shadow_offset
	match is_field_goal_kick:
		true:
			_current_velocity = abs(get_linear_velocity().y)
			if self.position.x < 0 or self.position.x >= 720 or self.position.y >= 1180 or self.position.y <= 100:
				if _current_scale < Vector2(1.2,1.2) and !is_falling:
					fall_off_board()
					off_board = true
			if _current_velocity > 5 and !is_flying:
				_new_scale = 1 + (_current_velocity / 2500)
				# math isn't exact but we need to cap the growth for presentation sake
				if _new_scale > 2.0:
					_new_scale = 2.0
				_flying_scale = Vector2(_new_scale, _new_scale)
				FlyTween.interpolate_property($Sprite, "scale", _current_scale, _flying_scale, .75, Tween.TRANS_QUAD, Tween.EASE_OUT)
				FlyTween.start()
				is_flying = true
			_new_offset = _new_offset * (_current_scale * 3)
		false:
			if self.position.x < 0 or self.position.x > 720 or self.position.y > 1180 or self.position.y < 100:
				if !is_falling:
					fall_off_board()
					off_board = true

	var _ball_rotation = get_rotation()
	_ball_rotation = -1 * _ball_rotation
	var _new_position = _new_offset.rotated(_ball_rotation) * (_current_scale - Vector2(.5,.5))
	ball_material.set_shader_param("offset", _new_position)
	match current_turn:
		Turn.AI:
			max_velocity = 9999
			evaluate_movement_ai()
			$TouchZone.set_texture(null)
		Turn.TOP:
			max_velocity = 3200
			evaluate_movement_2P_practice_challenge()
			$TouchZone.set_texture(ThemeControl.BALL_ZONE)
		Turn.BOT:
			max_velocity = 3200
			evaluate_movement_2P_practice_challenge()
			$TouchZone.set_texture(ThemeControl.BALL_ZONE)
		Turn.CHALLENGE_PRACTICE:
			max_velocity = 3200
			evaluate_movement_2P_practice_challenge()
			$TouchZone.set_texture(ThemeControl.BALL_ZONE)
	if self.position.x < -500 or self.position.x > 1220 or self.position.y > 2280 or self.position.y < -1000:
		far_off_board = true



func _on_FlyTween_tween_all_completed():
	var _original_scale = Vector2(1,1)
	FlyTween.interpolate_property($Sprite, "scale", $Sprite.get_scale(), _original_scale, .75, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	FlyTween.start()


func set_turn(turn):
	current_turn = turn


func evaluate_movement_2P_practice_challenge():
	if !player_moved and !turn_ended:
		can_show_zone = !Main.finger_alive
		Main.player_can_control = true
	match can_show_zone:
		true:
			show_touch_zone()
			position_instructions()
			MenuControl.show_direction_instruction()
		false:
			hide_touch_zone()
			MenuControl.hide_direction_instruction()
	if player_moved and self.is_sleeping():
		player_moved = false
		can_show_zone = false
		Main.player_can_control = false
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout",self, "_on_Timer_timeout")
		_timer.set_wait_time(.75)
		_timer.set_one_shot(true)
		_timer.start()

# logic and animation for the touch zone
func show_touch_zone():
	if !is_tz_alive:
		FootballTween.stop_all()
		var _tz_start_size = $TouchZone.get_scale()
		var _tz_end_size = Vector2(1,1)
		var _instruction_start_size = Instructions.get_scale()
		var _instruction_end_size = Vector2(1,1)
		is_tz_alive = true
		FootballTween.interpolate_property(TouchZone, "scale", _tz_start_size, _tz_end_size, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
		FootballTween.interpolate_property(Instructions, "scale", _instruction_start_size, _instruction_end_size, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
		FootballTween.start()

func hide_touch_zone():
	if is_tz_alive:
		FootballTween.stop_all()
		var _tz_start_size = $TouchZone.get_scale()
		var _tz_end_size = Vector2(0,0)
		var _instruction_start_size = Instructions.get_scale()
		var _instruction_end_size = Vector2(0,0)
		is_tz_alive = false
		FootballTween.interpolate_property(TouchZone, "scale", _tz_start_size, _tz_end_size, 0.2, Tween.TRANS_EXPO, Tween.EASE_IN)
		FootballTween.interpolate_property(Instructions, "scale", _instruction_start_size, _instruction_end_size, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
		FootballTween.start()

func player_ball_contact():
	if !player_moved:
		#Input.vibrate_handheld(50)
		player_moved = true
		Main.last_impact_velocity = self.get_linear_velocity()
		MenuControl.hide_score()
		turn_ended = true
		if can_emit_sound:
			play_ball_sound()
			can_emit_sound = false


func play_ball_sound():
	var _current_velocity = get_linear_velocity()
	var _current_velocity_x = abs(_current_velocity.x)
	var _current_velocity_y = abs(_current_velocity.y)
	$BallImpactLayerLow.volume_db = -20
	$BallImpactLayer.volume_db = -20
	if _current_velocity_x > 1000 or _current_velocity_y > 1000:
		$BallImpactLayerLow.volume_db = -15
		$BallImpactLayer.volume_db = -15
	if _current_velocity_x > 1600 or _current_velocity_y > 1600:
		$BallImpactLayerLow.volume_db = -10
		$BallImpactLayer.volume_db = -10
	if _current_velocity_x > 1600 or _current_velocity_y > 2200:
		$BallImpactLayerLow.volume_db = -5
		$BallImpactLayer.volume_db = -5
	if _current_velocity_x > 2800 or _current_velocity_y > 2800:
		$BallImpactLayerLow.volume_db = 0
		$BallImpactLayer.volume_db = 0
	$BallImpactLayerLow.play()
	$BallImpactLayer.play()


func evaluate_movement_ai():
	var local_velocity = self.get_linear_velocity()
	local_velocity = abs(local_velocity.y) + abs(local_velocity.x)
	Main.player_can_control = false
	match current_turn:
			Turn.AI:
				can_show_zone = false
				if ai_moved and local_velocity < 3:
					ai_applied_force = false
					ai_moved = false
					ai_applied_force = false
					_timer = Timer.new()
					add_child(_timer)
					_timer.connect("timeout",self, "_on_Timer_timeout")
					_timer.set_wait_time(.75)
					_timer.set_one_shot(true)
					_timer.start()
				if ai_applied_force and local_velocity > 3:
					ai_moved = true
					if can_emit_sound:
						$BallImpactSound.play()
						play_ball_sound()
						can_emit_sound = false

	match can_show_zone:
		true:
			show_touch_zone()
			position_instructions()
		false:
			hide_touch_zone()


func _on_Timer_timeout():
	player_moved = false
	can_emit_sound = true
	can_show_zone = true
	turn_ended = false
	emit_signal("turn_ended")


# this might be expensive, dunno, refactor
func position_instructions():
	var _instruction_offset = 165
	var ball_position = self.get_global_position()
	if ball_position.x <= 360 and ball_position.y <= 640:
		Instructions.position.y = ball_position.y + _instruction_offset
		Instructions.position.x = ball_position.x + _instruction_offset
	if ball_position.x >= 361 and ball_position.y <= 640:
		Instructions.position.y = ball_position.y + _instruction_offset
		Instructions.position.x = ball_position.x - _instruction_offset
	if ball_position.x <= 360 and ball_position.y >= 640:
		Instructions.position.y = ball_position.y - _instruction_offset
		Instructions.position.x = ball_position.x + _instruction_offset
	if ball_position.x >= 361 and ball_position.y >= 640:
		Instructions.position.y = ball_position.y - _instruction_offset
		Instructions.position.x = ball_position.x - _instruction_offset
	match current_turn:
		Turn.TOP:
			Instructions.set_rotation_degrees(180)
		Turn.BOT, Turn.CHALLENGE_PRACTICE:
			Instructions.set_rotation_degrees(0)


# ghost effect trial
func _on_GhostTimer_timeout():
	if !off_board and can_spawn_trail:
		var _local_ghost = Ghost.instance()
		_local_ghost.position = self.position
		_local_ghost.rotation_degrees = get_rotation_degrees()
		_local_ghost.set_texture($Sprite.get_texture())
		_local_ghost.set_as_toplevel(true)
		_local_ghost.set_draw_behind_parent(true)
		_local_ghost.set_z_as_relative(true)
		_local_ghost.z_index = 0
		add_child(_local_ghost)


func fall_off_board():
	FlyTween.remove_all()
	is_falling = true
	is_field_goal_kick = false
	var _ball_start_size = $Sprite.get_scale()
	var _ball_end_size = Vector2(.6,.6)

	$Sprite.z_index = -1
	ball_shadow_offset = ball_shadow_offset * 8
	if ThemeControl.gamefield_main == ThemeControl.RETRO_GAMEFIELD:
		_ball_end_size = Vector2(0,0)
		FallTween.interpolate_property($Sprite, "scale", _ball_start_size, _ball_end_size, .75, Tween.TRANS_EXPO, Tween.EASE_IN)
		play_random_warp_sound()
	else:
		FallTween.interpolate_property($Sprite, "scale", _ball_start_size, _ball_end_size, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	FallTween.start()


func play_random_warp_sound():
	randomize()
	var _selection = int(rand_range(1,5))
	match _selection:
		1:
			Main.get_node("BallWarp1").play()
		2:
			Main.get_node("BallWarp2").play()
		3:
			Main.get_node("BallWarp3").play()
		4:
			Main.get_node("BallWarp4").play()


func _on_FallTween_tween_all_completed():
	can_spawn_trail = true
	spawning = false

