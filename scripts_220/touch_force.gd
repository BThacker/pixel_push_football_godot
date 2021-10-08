# 2020 Pixel Push Football - Brandon Thacker 

extends RigidBody2D

signal ball_contact
const MAX_VELOCITY = 3500
const hard_touch_strength = .25
const medium_touch_strength = .60
const soft_touch_strength = .95

onready var Main = get_parent()
onready var GameCamera = Main.get_node("GameCamera")
onready var ChallengeControl = Main.get_node("ChallengeControl")
onready var MenuControl = Main.get_node("MenuControl")

var is_held = false
# how fast the rigidbody follows the touch input
# can be tuned for different devices but this number seems solid as a general rule
var mouse_drag_scale = 20
var collision_occured = false
var begin_position = Vector2()
var mover_offset = Vector2()
var can_exist = true
var mat
var bot_pointer
var top_pointer
var practice_pointer
var ball_contact


func _physics_process(_delta):
	pass
	#if abs(get_linear_velocity().x) > MAX_VELOCITY or abs(get_linear_velocity().y) > MAX_VELOCITY:
	#	var _new_velocity = get_linear_velocity().normalized()
	#	_new_velocity *= MAX_VELOCITY
	#	set_linear_velocity(_new_velocity)

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		is_held = true
	else:
		is_held = false
		delete_controller()
	var bodies = get_colliding_bodies()
	if bodies.size() > 0 and !ball_contact:
		collision_occured = true
		ball_contact = true
		delete_controller()


func start(spawn_position, mover_difference):
	connect("ball_contact", Main.current_ball, "player_ball_contact")
	connect("ball_contact", Main.get_node("MenuControl"), "field_goal_ref_cam")
	Main = get_parent()
	var _touch_strength
	match Main.current_ball.current_turn:
		Main.current_ball.Turn.BOT:
			match SaveSettings.pixel_push_save_data["red_touch_force"]:
				1: _touch_strength = soft_touch_strength
				2: _touch_strength = medium_touch_strength
				3: _touch_strength = hard_touch_strength
		Main.current_ball.Turn.TOP:
			match SaveSettings.pixel_push_save_data["blue_touch_force"]:
				1: _touch_strength = soft_touch_strength
				2: _touch_strength = medium_touch_strength
				3: _touch_strength = hard_touch_strength
		Main.current_ball.Turn.CHALLENGE_PRACTICE:
			match SaveSettings.pixel_push_save_data["red_touch_force"]:
				1: _touch_strength = soft_touch_strength
				2: _touch_strength = medium_touch_strength
				3: _touch_strength = hard_touch_strength
	self.mass = _touch_strength
	bot_pointer = Main.get_node("ThemeControl").bot_pointer
	top_pointer = Main.get_node("ThemeControl").top_pointer
	practice_pointer = Main.get_node("ThemeControl").practice_pointer
	MenuControl.fade_score(2)
	mat = $Sprite.get_material()
	var _top_offset = Vector2(-10, -5)
	var _bot_offset = Vector2(10, 5)
	if can_exist:
		match Main.current_ball.current_turn:
			Main.current_ball.Turn.TOP:
				self.set_rotation_degrees(180)
				$Sprite.set_texture(top_pointer)
				mat.set_shader_param("offset",_top_offset)
			Main.current_ball.Turn.BOT:
				self.set_rotation_degrees(0)
				$Sprite.set_texture(bot_pointer)
				mat.set_shader_param("offset", _bot_offset)
			Main.current_ball.Turn.CHALLENGE_PRACTICE:
				self.set_rotation_degrees(0)
				$Sprite.set_texture(practice_pointer)
				mat.set_shader_param("offset", _bot_offset)
		position = spawn_position
		begin_position = spawn_position
		mover_offset = mover_difference
		Main.finger_alive = true
		Main.get_ball_current_yardline()
		Main.turn_start_yard = Main.current_yard_line
		Main.begin_yard = Main.current_ball.position.y
		connect("ball_contact", ChallengeControl, "delete_timer_ball_contact")
		$Label.text = str(position.y)
		# required for fast moving screens


func delete_controller():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var _timer = null
	var _impact_timer
	if collision_occured:
		can_exist = false
		_timer = Timer.new()
		_impact_timer = Timer.new()
		add_child(_timer)
		add_child(_impact_timer)
		_timer.connect("timeout",self, "_on_Timer_timeout")
		_impact_timer.connect("timeout",self, "_on_Impact_Timer_timeout")
		# how soon we should delete the object after collision (prevents exploit)
		_timer.set_wait_time(.05)
		_impact_timer.set_wait_time(.05)
		_impact_timer.set_one_shot(true)
		_timer.set_one_shot(true)
		_impact_timer.start()
		_timer.start()
	if !is_held:
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout",self, "_on_Timer_timeout")
		#how soon we should delete the object after collision (prevents exploit)
		_timer.set_wait_time(.15)
		_timer.set_one_shot(true)
		_timer.start()


func _on_Timer_timeout():
	MenuControl.fade_score(1)
	Main.finger_alive = false
	# null out the value as other items may inherit the object ID
	# could cause a trail bug
	Main.current_touch = null
	queue_free()

func _on_Impact_Timer_timeout():
	emit_signal("ball_contact")


# drag and move functionality
func _integrate_forces(state):
	if is_held and can_exist:
		set_can_sleep(false)
		state.linear_velocity = get_global_mouse_position() - (global_position + mover_offset)
		state.linear_velocity *= mouse_drag_scale
