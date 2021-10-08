# Pixel Push Football - 2020 Brandon Thacker 

extends Area2D

onready var Main = get_parent()

var can_spawn_mover = false

func _on_gamefield_input_event(_viewport, event, _shape_idx):
	if is_instance_valid(Main.current_ball) and Main.player_can_control and event.is_action_pressed('mouse_click'):
		mover_spawn(event)
	if Main.player_can_control and event is InputEventScreenTouch:
		mover_spawn(event)


func mover_spawn(event):
		var _mover_offset = Vector2()
		var _spawn_position
		if is_instance_valid(Main.current_ball):
			var _click_position = get_global_mouse_position() #event.position
			var _input_distance = Main.current_ball.position.distance_to(_click_position)
			# we don't want the player touching too close, could cause unintended impact to the ball
			if _input_distance > 195:
				# normalized math to follow the ball correctly
				# https://forum.unity.com/threads/find-a-point-on-a-line-between-two-vector3.140700/
				var _ball_difference = Main.current_ball.position - _click_position
				_mover_offset = _ball_difference.normalized()
				_spawn_position = (_click_position + (120 * _mover_offset))
				_mover_offset = _click_position - _spawn_position
				can_spawn_mover = true
				match Main.current_ball.current_turn:
					Main.current_ball.Turn.BOT:
						match SaveSettings.pixel_push_save_data["is_red_pointer_offset"]:
							true: _mover_offset = _mover_offset
							false:
								_mover_offset = Vector2(0, 70)
								_spawn_position = _click_position
					Main.current_ball.Turn.TOP:
						match SaveSettings.pixel_push_save_data["is_blue_pointer_offset"]:
							true: _mover_offset = _mover_offset
							false:
								_mover_offset = Vector2(0, -70)
								_spawn_position = _click_position
					Main.current_ball.Turn.CHALLENGE_PRACTICE:
						match SaveSettings.pixel_push_save_data["is_red_pointer_offset"]:
							true: _mover_offset = _mover_offset
							false:
								_mover_offset = Vector2(0, 70)
								_spawn_position = _click_position
			else:
				can_spawn_mover = false
			if !Main.finger_alive and can_spawn_mover and !Main.current_ball.player_moved:
				var _tf = Main.touch_force.instance()
				Main.add_child(_tf)
				Main.current_touch = _tf
				_tf.start(_spawn_position, _mover_offset)
				_mover_offset = Vector2()
				Main.finger_alive = true

