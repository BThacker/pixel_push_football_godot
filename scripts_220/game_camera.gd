# 2020 Pixel Push Football - Brandon Thacker 

extends Camera2D

# previous 481
const bot_left = Vector2(271,541)
const bot_middle = Vector2(360,541)
const bot_right = Vector2(449,541)
const middle_left = Vector2(271, 641)
const middle_right = Vector2(449, 641)
# previous 800
const top_left = Vector2(271,740)
const top_middle = Vector2(360,740)
const top_right = Vector2(449,740)
const action_bot_left = Vector2(181,321)
const action_bot_middle = Vector2(360,321)
const action_bot_right = Vector2(539,321)
const action_top_left = Vector2(181,961)
const action_top_middle = Vector2(360,961)
const action_top_right = Vector2(539,961)
const default_camera = Vector2(360,641)
const default_zoom = Vector2(1,1)
var camera_shake = 0

onready var Main = get_parent()
onready var MenuControl = Main.get_node("MenuControl")
enum CameraPosition {
	DEFAULT,
	PAUSE,
	ACTION_BOT_LEFT,
	BOT_LEFT,
	ACTION_BOT_MIDDLE,
	BOT_MIDDLE,
	ACTION_BOT_RIGHT,
	BOT_RIGHT,
	ACTION_TOP_LEFT,
	TOP_LEFT,
	ACTION_TOP_MIDDLE,
	TOP_MIDDLE,
	ACTION_TOP_RIGHT,
	TOP_RIGHT,
	CAMERA_BALL,
	SNAP_DEFAULT
}


func _process(delta):
	if camera_shake > 0:
		self.set_offset(Vector2( \
			rand_range(-1.0, 1.0) * camera_shake, \
			rand_range(-1.0, 1.0) * camera_shake \
		))


func camera_action_move(location):
	var _timer = null
	for n in self.get_children():
		if n.is_in_group("cameratimers"):
			return

	_timer = Timer.new()
	_timer.connect("timeout",self, "camera_action_move_after_delay", [location])
	_timer.set_wait_time(.1)
	_timer.set_one_shot(true)
	_timer.add_to_group("cameratimers")
	add_child(_timer)
	_timer.start()


func camera_action_move_after_delay(location):
	var local_position
	var camera_zoom = $ZoomAnimation.get_animation("camera_move")

	match location:
		CameraPosition.DEFAULT:
			local_position = default_camera
			if SaveSettings.pixel_push_save_data["is_small_screen"]:
				local_position = check_camera_position()
			camera_zoom.track_set_key_value(0,0, get_zoom())
			camera_zoom.track_set_key_value(0,1,default_zoom)
			$ZoomAnimation.play("camera_move")
			position = local_position
			cleanup_timers()
			return
		CameraPosition.PAUSE:
			local_position = default_camera
			camera_zoom.track_set_key_value(0,0, get_zoom())
			camera_zoom.track_set_key_value(0,1,default_zoom)
			$ZoomAnimation.play("camera_move")
			position = local_position
			cleanup_timers()
			return
		#CameraPosition.SNAP_DEFAULT:
		#	local_position = default_camera
		#	camera_zoom.track_set_key_value(1,0,default_zoom)
		#	camera_zoom.track_set_key_value(0,1,default_zoom)
		#	$ZoomAnimation.play("camera_move")
		#	position = local_position
		#	cleanup_timers()
		#	return
		CameraPosition.CAMERA_BALL:
			local_position = Main.current_touch.position
			camera_zoom.track_set_key_value(0,0, get_zoom())
			camera_zoom.track_set_key_value(0,1, get_zoom()*.8)
			$ZoomAnimation.play("camera_move")
			position = local_position
			cleanup_timers()
			return
		CameraPosition.BOT_LEFT:
			position = bot_left
			cleanup_timers()
			return
		CameraPosition.BOT_MIDDLE:
			position = bot_middle
			cleanup_timers()
			return
		CameraPosition.BOT_RIGHT:
			position = bot_right
			cleanup_timers()
			return
		CameraPosition.TOP_LEFT:
			position = top_left
			cleanup_timers()
			return
		CameraPosition.TOP_MIDDLE:
			position = top_middle
			cleanup_timers()
			return
		CameraPosition.TOP_RIGHT:
			position = top_right
			cleanup_timers()
			return
		CameraPosition.ACTION_BOT_LEFT:
			local_position = action_bot_left
			MenuControl.show_ref_cam()
		CameraPosition.ACTION_BOT_MIDDLE:
			local_position = action_bot_middle
			MenuControl.show_ref_cam()
		CameraPosition.ACTION_BOT_RIGHT:
			local_position = action_bot_right
			MenuControl.show_ref_cam()
		CameraPosition.ACTION_TOP_LEFT:
			local_position = action_top_left
			MenuControl.show_ref_cam()
		CameraPosition.ACTION_TOP_MIDDLE:
			local_position = action_top_middle
			MenuControl.show_ref_cam()
		CameraPosition.ACTION_TOP_RIGHT:
			local_position = action_top_right
			MenuControl.show_ref_cam()
	position = local_position
	camera_zoom.track_set_key_value(0,0,get_zoom() )
	camera_zoom.track_set_key_value(0,1,get_zoom() * .6 )
	$ZoomAnimation.play("camera_move")
	Main.can_action_cam = false
	cleanup_timers()

func cleanup_timers():
	for n in self.get_children():
		if n.is_in_group("cameratimers"):
			n.queue_free()


func shake_camera():
	var _timer = null
	camera_shake = 15
	_timer = Timer.new()
	_timer.connect("timeout",self, "shake_camera_stop")
	_timer.set_wait_time(.8)
	_timer.set_one_shot(true)
	add_child(_timer)
	_timer.start()


func shake_camera_stop():
	camera_shake = 0
	self.set_offset(Vector2(0,0))

# this will help with smaller screens if people turn the mode on
func check_camera_position():
	if is_instance_valid(Main.current_ball):
		var _camera_position = Vector2()
		var _local_position = Main.current_ball.position
		var _current_ball = Main.current_ball
		match Main.current_ball.current_turn:
			_current_ball.Turn.TOP:
				if _local_position.y < 245 and _local_position.y > 100:
					if _local_position.x >= 241 and _local_position.x <= 479:
						return bot_middle
					if _local_position.x <= 240:
						return bot_left
					if _local_position.x >= 480:
						return bot_right
				if _local_position.x < 240:
					return middle_left
				if _local_position.x > 479:
					return middle_right
			_current_ball.Turn.BOT, _current_ball.Turn.CHALLENGE_PRACTICE:
				if _local_position.y > 1035 and _local_position.y < 1180:
					if _local_position.x >= 241 and _local_position.x <= 479:
						return top_middle
					if _local_position.x <= 240:
						return top_left
					if _local_position.x >= 480:
						return top_right
				if _local_position.x < 240:
					return middle_left
				if _local_position.x > 479:
					return middle_right
			_current_ball.Turn.AI:
				return default_camera
	return default_camera
