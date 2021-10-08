# Pixel Push Football - 2020 Brandon Thacker 

extends Camera2D


var bot_left = Vector2(181,481)
var bot_middle = Vector2(360,481)
var bot_right = Vector2(539,481)
var top_left = Vector2(181,800)
var top_middle = Vector2(360,800)
var top_right = Vector2(539,800)
var action_bot_left = Vector2(181,321)
var action_bot_middle = Vector2(360,321)
var action_bot_right = Vector2(539,321)
var action_top_left = Vector2(181,961)
var action_top_middle = Vector2(360,961)
var action_top_right = Vector2(539,961)
var default_camera = Vector2(360,641)
var default_zoom = Vector2(1,1)
var camera_shake = 0
onready var Main = get_parent()
onready var MenuControl = Main.get_node("MenuControl")
enum CameraPosition {
	DEFAULT,
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
	var local_position
	var camera_zoom = $ZoomAnimation.get_animation("camera_move")
	match location:
		CameraPosition.DEFAULT:
			local_position = default_camera
			camera_zoom.track_set_key_value(0,0, get_zoom())
			camera_zoom.track_set_key_value(0,1,default_zoom)
			$ZoomAnimation.play("camera_move")
			position = local_position
			return
		CameraPosition.SNAP_DEFAULT:
			local_position = default_camera
			camera_zoom.track_set_key_value(1,0,default_zoom)
			camera_zoom.track_set_key_value(0,1,default_zoom)
			$ZoomAnimation.play("camera_move")
			position = local_position
			return
		CameraPosition.CAMERA_BALL:
			local_position = Main.current_touch.position
			camera_zoom.track_set_key_value(0,0, get_zoom())
			camera_zoom.track_set_key_value(0,1, get_zoom()*.8)
			$ZoomAnimation.play("camera_move")
			position = local_position
			return
		CameraPosition.BOT_LEFT:
			position = bot_left
			return
		CameraPosition.BOT_MIDDLE:
			position = bot_middle
			return
		CameraPosition.BOT_RIGHT:
			position = bot_right
			return
		CameraPosition.TOP_LEFT:
			position = top_left
			return
		CameraPosition.TOP_MIDDLE:
			position = top_middle
			return
		CameraPosition.TOP_RIGHT:
			position = top_right
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
	camera_zoom.track_set_key_value(0,1,get_zoom()*0.5 )
	$ZoomAnimation.play("camera_move")
	Main.can_action_cam = false

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
