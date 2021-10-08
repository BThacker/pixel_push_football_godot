# Pixel Push Football - 2020 Brandon Thacker 

extends Node

const SCORING_POSITION = 1180
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
	SMALL
}
onready var Main = get_parent()
onready var MenuControl = Main.get_node("MenuControl")
# easter egg
onready var ChaosMonkeySound = Main.get_node("ChaosMonkeySound")
var _timer
var current_distance
var distance_to_score
var yards_to_score
var current_force_offset
var action_to_take

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
	print("we chaos monkey now")
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
	action_to_take = null
	clear_variables()


func evaluate_scoring_distance():
	randomize()
	var _miss_seed = int(rand_range(0, 100))
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
	match current_distance:
		Distances.VERY_CLOSE:
			# miss chance 16%
			if _miss_seed >= 84:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.CLOSE:
			# miss chance 40%
			if _miss_seed >= 60:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.MEDIUM:
			# miss chance 65%
			if _miss_seed >= 35:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.FAR:
			# miss chance 80%
			if _miss_seed >= 20:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL
		Distances.VERY_FAR:
			# miss chance 90%
			if _miss_seed >= 10:
				current_force_offset = ForceOffsets.LARGE
			else:
				current_force_offset = ForceOffsets.SMALL


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
			# we set the range between -
			if _exact_force < 1250:
				var bot_range = -_exact_force
				_applied_offset = int(rand_range(bot_range,750))
			else:
				_applied_offset = int(rand_range(-1250,750))
			_final_force = _exact_force + _applied_offset
			return _final_force
		ForceOffsets.SMALL:
			if _exact_force < 600:
				var bot_range = -_exact_force
				_applied_offset = int(rand_range(bot_range, 500))
			else:
				_applied_offset = int(rand_range(-600, 500))
			_final_force = _exact_force + _applied_offset
			return _final_force


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
	var _left_right_force
	var _current_goal_post_position = Main.current_fg.position
	_current_goal_post_position = int(_current_goal_post_position.x)
	var current_goal_post_velocity = Main.current_fg.velocity
	current_goal_post_velocity = int(current_goal_post_velocity.x)
	# goal post is left of center, moving left
	if _current_goal_post_position <=360 and current_goal_post_velocity <= 0:
		_left_right_force = int(rand_range(-550, 0))
		return _left_right_force
	# left of center, moving right
	if _current_goal_post_position <= 360 and current_goal_post_velocity >= 1:
		_left_right_force = int(rand_range(-350, 100))
		return _left_right_force
	#right of center, moving left
	if _current_goal_post_position >= 360 and current_goal_post_velocity <= 0:
		_left_right_force = int(rand_range(0, 550))
		return _left_right_force
	#right of center, moving right
	if _current_goal_post_position >= 360 and current_goal_post_velocity >= 1:
		_left_right_force = int(rand_range(100, 350))
		return _left_right_force


func pat_distance_force():
	randomize()
	var _final_force = int(rand_range(3500,4000))
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
