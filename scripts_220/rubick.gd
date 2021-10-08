# 2020 Pixel Push Football - Brandon Thacker 

extends Node

const SCORING_POSITION = 1180
# difficulty specific
const EASY_OFFSET_UPPER_LARGE = 750
const EASY_OFFSET_LOWER_LARGE = -1250
const EASY_OFFSET_UPPER_SMALL = 500
const EASY_OFFSET_LOWER_SMALL = -600

const MEDIUM_OFFSET_UPPER_LARGE = 550
const MEDIUM_OFFSET_LOWER_LARGE = -800
const MEDIUM_OFFSET_UPPER_SMALL = 350
const MEDIUM_OFFSET_LOWER_SMALL = -400

const HARD_OFFSET_UPPER_LARGE = 400
const HARD_OFFSET_LOWER_LARGE = -650
const HARD_OFFSET_UPPER_SMALL = 250
const HARD_OFFSET_LOWER_SMALL = -250


enum Distances {
	VERY_FAR,
	FAR,
	MEDIUM,
	CLOSE,
	VERY_CLOSE
}
enum Actions{
	KICKOFF,
	POSSESSION_MOVE,
	DECIDE_XTRA,
	ATTEMPT_PAT,
	ATTEMPT_2PT,
	ATTEMPT_FG
}
enum ForceOffsets {
	LARGE,
	SMALL,
	EXACT
}

onready var Main = get_parent()
onready var MenuControl = Main.get_node("MenuControl")
# easter egg
onready var ChaosMonkeySound = Main.get_node("ChaosMonkeySound")

var offset_upper_large
var offset_lower_large
var offset_upper_small
var offset_lower_small
var miss_chance_very_close
var miss_chance_close
var miss_chance_medium
var miss_chance_far
var miss_chance_very_far

var _timer
var current_distance
var distance_to_score
var yards_to_score
var current_force_offset
var action_to_take
var current_difficulty

# some notes
# 1 yard is roughly 10.8 yards
# 216 pixels = 450 force = 20 yards
# with modified 4 damping, double the numbers

func _ready():
	Main = get_parent()
	MenuControl = Main.get_node("MenuControl")


func delay_decision():
	randomize()
	var _delay_time = rand_range(2.0,4.25)
	_timer = Timer.new()
	_timer.connect("timeout",self, "make_decision")
	_timer.set_wait_time(_delay_time)
	_timer.set_one_shot(true)
	add_child(_timer)
	_timer.start()


func kickoff_decide():
	action_to_take = Actions.KICKOFF
	delay_decision()


func move_ball_possession_decide():
	action_to_take = Actions.POSSESSION_MOVE
	delay_decision()


func xtra_action_decide():
	action_to_take = Actions.DECIDE_XTRA
	delay_decision()


func kick_pat_decide():
	action_to_take = Actions.ATTEMPT_PAT
	delay_decision()


func attempt_2pt_decide():
	action_to_take = Actions.ATTEMPT_2PT
	delay_decision()


func kick_fg_decide():
	action_to_take = Actions.ATTEMPT_FG
	delay_decision()


# all logic goes here based on action_to_take
func make_decision():
	match  Main.current_difficulty:
		1:
			offset_upper_large = EASY_OFFSET_UPPER_LARGE
			offset_lower_large = EASY_OFFSET_LOWER_LARGE
			offset_upper_small = EASY_OFFSET_UPPER_SMALL
			offset_lower_small = EASY_OFFSET_LOWER_SMALL
		2:
			offset_upper_large = MEDIUM_OFFSET_UPPER_LARGE
			offset_lower_large = MEDIUM_OFFSET_LOWER_LARGE
			offset_upper_small = MEDIUM_OFFSET_UPPER_SMALL
			offset_lower_small = MEDIUM_OFFSET_LOWER_SMALL
		3:
			offset_upper_large = HARD_OFFSET_UPPER_LARGE
			offset_lower_large = HARD_OFFSET_LOWER_LARGE
			offset_upper_small = HARD_OFFSET_UPPER_SMALL
			offset_lower_small = HARD_OFFSET_LOWER_SMALL
	_timer = null
	match action_to_take:
		Actions.KICKOFF:
			Main.turn_start_yard = Main.current_yard_line
			Main.begin_yard = Main.current_ball.position.y
			Main.get_ball_current_yardline()
			decide_movement_possession()
		Actions.POSSESSION_MOVE:
			Main.get_ball_current_yardline()
			Main.begin_yard = Main.current_ball.position.y
			decide_movement_possession()
		Actions.DECIDE_XTRA:
			var _should_I = decide_2pt_action_bool()
			match _should_I:
				false:
					Main.xtra_pt1_game_event(Main.Turn.TOP)
					action_to_take = Actions.ATTEMPT_PAT
					delay_decision()
				true:
					Main.xtra_pt2_game_event(Main.Turn.TOP)
					action_to_take = Actions.ATTEMPT_2PT
					delay_decision()
		Actions.ATTEMPT_PAT:
			Main.begin_yard = Main.current_ball.position.y
			decide_movement_pat()
		Actions.ATTEMPT_2PT:
			Main.begin_yard = Main.current_ball.position.y
			decide_movement_possession()
		Actions.ATTEMPT_FG:
			Main.begin_yard = Main.current_ball.position.y
			decide_movement_pat()
		_:
			pass


func decide_movement_possession():
	randomize()
	evaluate_scoring_distance()
	var _spin = final_spin()
	var _left_right = final_left_right()
	var _distance_force = final_distance_force(distance_to_score, current_force_offset)
	var _offset = Vector2(_spin,0)
	var _impulse = Vector2(_left_right, _distance_force)
	# chaos monkey easter egg, kinda fun
	var _chance_chaos_monkey = int(rand_range(1,101))
	if _chance_chaos_monkey >= 2:
		Main.current_ball.apply_impulse(_offset,_impulse)
	if _chance_chaos_monkey <= 1:
		randomize()
		Main.current_ball.apply_impulse(_offset,chaos_monkey())
		ChaosMonkeySound.play()
	MenuControl.hide_score()
	Main.current_ball.ai_applied_force = true
	action_to_take = null
	clear_variables()


# adding a bit of human error
func chaos_monkey():
	var _fifty_fifty = int(rand_range(1,3))
	match _fifty_fifty:
		1:
			# may hit ball into oblivion, may not *shrug
			var _left_right = rand_range(-900,900)
			var _distance_force = rand_range(-3500,3500)
			var _impulse = Vector2(_left_right, _distance_force)
			return _impulse
		2:
			# mishit
			var _left_right = rand_range(-500,500)
			var _distance_force = rand_range(-500,500)
			var _impulse = Vector2(_left_right, _distance_force)
			return _impulse


func decide_movement_pat():
	randomize()
	var _spin = final_spin()
	var _left_right = pat_left_right()
	var _distance_force = pat_distance_force()
	var _offset = Vector2(_spin, 0)
	var _impulse = Vector2(_left_right, _distance_force)
	Main.current_ball.apply_impulse(_offset, _impulse)
	Main.current_ball.ai_applied_force = true
	MenuControl.show_ref_cam()
	action_to_take = null
	clear_variables()


func evaluate_scoring_distance():
	randomize()
	var _miss_seed = int(rand_range(0, 100))
	var _exact_chance_seed = int(rand_range(0,101))
	var _ball_position = Main.current_ball.position
	_ball_position = int(_ball_position.y)
	distance_to_score = SCORING_POSITION - _ball_position
	distance_to_score = convert_distance_to_yards(distance_to_score)
	yards_to_score = distance_to_score
	if distance_to_score < 20:
		current_distance =  Distances.VERY_CLOSE
	if distance_to_score >= 20:
		current_distance =  Distances.CLOSE
	if distance_to_score >= 40:
		current_distance =  Distances.MEDIUM
	if distance_to_score >= 60:
		current_distance =  Distances.FAR
	if distance_to_score >= 80:
		current_distance =  Distances.VERY_FAR
	# these numbers are inverted, so 84 = 16% miss chance
	match Main.current_difficulty:
		1:
			miss_chance_very_close = 78
			miss_chance_close = 60
			miss_chance_medium = 40
			miss_chance_far = 25
			miss_chance_very_far = 15

		2:
			miss_chance_very_close = 85
			miss_chance_close = 73
			miss_chance_medium = 50
			miss_chance_far = 30
			miss_chance_very_far = 23

		3:
			miss_chance_very_close = 95
			miss_chance_close = 80
			miss_chance_medium = 60
			miss_chance_far = 40
			miss_chance_very_far = 30

	match current_distance:

		Distances.VERY_CLOSE:
			if _miss_seed >= miss_chance_very_close:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.CLOSE:
			if _miss_seed >= miss_chance_close:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.MEDIUM:
			if _miss_seed >= miss_chance_medium:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.FAR:
			if _miss_seed >= miss_chance_far:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.VERY_FAR:
			if _miss_seed >= miss_chance_very_far:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		# add a chance for exact distance
	match Main.current_difficulty:
		1:
			if _exact_chance_seed > 92:
				current_force_offset = ForceOffsets.EXACT
		2:
			if _exact_chance_seed > 87:
				current_force_offset = ForceOffsets.EXACT
		3:
			if _exact_chance_seed > 82:
				current_force_offset = ForceOffsets.EXACT


func convert_distance_to_yards(distance_pixels):
	var _converted = distance_pixels / 10.8
	_converted = int(round(_converted))
	return _converted


func convert_yards_to_force(yards):
	var _one_yard_force = 45
	return yards * _one_yard_force


func final_distance_force(distance, offset):
	randomize()
	var _exact_force = convert_yards_to_force(distance)
	var _applied_offset
	var _final_force
	match offset:
		ForceOffsets.LARGE:
			# to prevent ball from being hit backwards
			# we set the range between the distance calculation and 0.
			if _exact_force < offset_lower_large:
				var bot_range = -_exact_force
				_applied_offset = int(rand_range(bot_range,offset_upper_large))
			else:
				_applied_offset = int(rand_range(offset_lower_large,offset_upper_large))
			_final_force = _exact_force + _applied_offset
			return _final_force
		ForceOffsets.SMALL:
			if _exact_force < offset_lower_small:
				var bot_range = -_exact_force
				_applied_offset = int(rand_range(bot_range, offset_upper_small))
			else:
				_applied_offset = int(rand_range(offset_lower_small, offset_upper_small))
			_final_force = _exact_force + _applied_offset
			return _final_force
		ForceOffsets.EXACT:
				return _exact_force


func final_spin():
	var _spin1
	var _spin2
	var _fifty_fifty
	randomize()
	_spin1 = int(rand_range(-10, -1))
	_spin2 = int(rand_range(1,10))
	_fifty_fifty = int(rand_range(1,3))
	match _fifty_fifty:
		1: return _spin1
		2: return _spin2


func final_left_right():
	randomize()
	var _left_right_force
	var current_hor_position = Main.current_ball.position
	current_hor_position = int(current_hor_position.x)
	if current_hor_position <= 240:
		_left_right_force = int(rand_range(-25, 640))
		_left_right_force = convert_distance_to_yards(_left_right_force)
		_left_right_force = convert_yards_to_force(_left_right_force)
		return _left_right_force
	if current_hor_position >= 241 and current_hor_position <= 479:
		_left_right_force = int(rand_range(-320,320))
		_left_right_force = convert_distance_to_yards(_left_right_force)
		_left_right_force = convert_yards_to_force(_left_right_force)
		return _left_right_force
	if current_hor_position >= 480:
		_left_right_force = int(rand_range(-640,-25))
		_left_right_force = convert_distance_to_yards(_left_right_force)
		_left_right_force = convert_yards_to_force(_left_right_force)
		return _left_right_force


func pat_left_right():
	randomize()
	var _moving_right_upper
	var _moving_right_lower
	var _moving_left_upper
	var _moving_left_lower
	var _moving_middle_upper
	var _moving_middle_lower
	var _moving_right_right_upper
	var _moving_right_right_lower
	var _moving_left_left_upper
	var _moving_left_left_lower
	match Main.current_difficulty:
		1:
			_moving_right_upper = 550
			_moving_right_lower = 0
			_moving_left_upper = -550
			_moving_left_lower = 0
			_moving_right_right_upper = 350
			_moving_right_right_lower = 0
			_moving_left_left_upper = -350
			_moving_left_left_lower = 0
			_moving_middle_upper = 300
			_moving_middle_lower = -300
		2:
			_moving_right_upper = 450
			_moving_right_lower = 100
			_moving_left_upper = -450
			_moving_left_lower = -100
			_moving_right_right_upper = 350
			_moving_right_right_lower = 100
			_moving_left_left_upper = -350
			_moving_left_left_lower = -100
			_moving_middle_upper = 250
			_moving_middle_lower = -250
		3:
			_moving_right_upper = 350
			_moving_right_lower = 175
			_moving_left_upper = -350
			_moving_left_lower = -175
			_moving_right_right_upper = 300
			_moving_right_right_lower = 150
			_moving_left_left_upper = -300
			_moving_left_left_lower = -150
			_moving_middle_upper = 200
			_moving_middle_lower = -200
	var _left_right_force
	var _current_goal_post_position = Main.current_fg.position
	_current_goal_post_position = int(_current_goal_post_position.x)
	var current_goal_post_velocity = Main.current_fg.velocity
	current_goal_post_velocity = int(current_goal_post_velocity.x)
	# goal post is left of center, moving left
	if _current_goal_post_position <=360 and current_goal_post_velocity <= 0:
		_left_right_force = int(rand_range(_moving_left_left_lower, _moving_left_left_upper))
		return _left_right_force
	# left of center, moving right
	if _current_goal_post_position <= 360 and current_goal_post_velocity >= 1:
		_left_right_force = int(rand_range(_moving_right_lower, _moving_right_upper))
		return _left_right_force
	#right of center, moving left
	if _current_goal_post_position >= 360 and current_goal_post_velocity <= 0:
		_left_right_force = int(rand_range(_moving_left_lower, _moving_left_upper))
		return _left_right_force

	#right of center, moving right
	if _current_goal_post_position >= 360 and current_goal_post_velocity >= 1:
		_left_right_force = int(rand_range(_moving_right_right_lower, _moving_right_right_upper))
		return _left_right_force


func pat_distance_force():
	randomize()
	var _final_force = int(rand_range(3700,4250))
	return _final_force


func clear_variables():
	yards_to_score = null
	current_force_offset = null
	action_to_take = null


func decide_2pt_action_bool():
	var _to_winning_score = Main.winning_score - Main.top_score
	var _player_ahead = Main.bot_score - Main.top_score
	match _to_winning_score:
		2: return true
		5: return true
		9: return true
		12: return true
		16: return true
		18: return true
		23: return true
	if _player_ahead > 16:
		return true
	return false
