# 2020 Pixel Push Football - Brandon Thacker 

extends Node2D
export (PackedScene) var football
export (PackedScene) var touch_force
export (PackedScene) var customize
export (PackedScene) var coin_toss
export (PackedScene) var field_goal_kick
export (PackedScene) var xtra_pt_choice
export (PackedScene) var DefenseControl
export (PackedScene) var tournament


onready var MenuSignalControl = get_node("MenuLayer/MenuSignalControl")
onready var GameOver = get_node("MenuLayer/GameOver")
onready var RetroMode = get_node("MenuLayer/RetroMode")
onready var	RetroModeRect = get_node("MenuLayer/RetroMode/RetroCanvas/RetroModeRect")
onready var glow_material = preload("res://shaders/ball_glow.tres")
onready var ball_fall_material = preload("res://shaders/ball_shadow.tres")
onready var ThemeControl = $ThemeControl
onready var MenuControl = $MenuControl


enum FirstMove{TOP, BOT}

# a duplicate of Football enum below
# need to rewrite logic on some of the more complex choices

enum GameState{POSSESSION, XTRAPT1, XTRAPT2, FGATTEMPT}
enum Turn{TOP, BOT, CHALLENGE_PRACTICE}
# enum GameDifficulty{EASY, MEDIUM, HARD}


enum GameType{PRACTICE, VS_AI, VS_2P, CHALLENGE, NONE}

enum DeadZone {
	BOT_TOUCHBACK,
	TOP_TOUCHBACK,
	BOT_SAFETY,
	TOP_SAFETY
	}

# we initialize the last gameplay music out of range to show
# that its the first time the game is being played
# see the function for a better understanding


var current_game_type
var current_game_state
var bot_current_strikes = 0
var top_current_strikes = 0
var current_game_theme
var current_game_difficulty
var current_defense
var randomize_kickoff
var tournament_mode = false
# game difficulty default 2 for medium, 1 easy, 3 hard
var current_difficulty = 2
var player_can_control = false
var can_pause = false
var can_action_cam = true
var can_glow = true
var random_defender_mode = false
var defender_array = []
var current_touch
var dead_zone_result
var field_goal
var ball_spawn_pos = Vector2()
var ball_rotation = 0
var current_ball
var current_yard_line
var current_fg
var begin_yard
var end_yard
var last_distance_moved
var last_impact_velocity
var turn_start_yard
var redzone_attempt = false
var practice_oob = false
var challenge_oob = false
var finger_alive = false
var winning_score = 14
var top_score = 0
var bot_score = 0
var did_ball_oob = false
var last_coin_toss_winning_player = 0





func _process(_delta):
	evaluate_ball_camera()
	#td_check_ball_glow()
	draw_touch_trail()
	#if can_pause:
	#	if Input.is_action_pressed("go_back"):
	#		pause_game()


func _ready():
	MenuSignalControl.connect("start_button_2P", self, "start_button_2p")
	MenuSignalControl.connect("start_button_AI", self, "start_button_ai")
	MenuSignalControl.connect("start_button_practice", self, "start_button_practice")
	MenuSignalControl.connect("start_button_challenge", self, "start_button_challenge")
	MenuSignalControl.connect("start_button_tournament", self, "start_button_tournament")
	MenuSignalControl.connect("show_two_minute", self, "start_button_two_minute")
	MenuSignalControl.connect("start_two_minute", self, "start_action_two_minute")
	MenuSignalControl.connect("show_shred_the_defense", self, "start_button_beat_the_defense")
	MenuSignalControl.connect("start_action_beat_the_defense", self, "start_action_beat_the_defense")
	MenuSignalControl.connect("show_fgf", self, "start_button_fgf")
	MenuSignalControl.connect("start_fgf", self, "start_action_fgf")
	# we don't need to show the title screen each time game is reset
	randomize()
	$MenuControl.show_play()
	$MenuControl.hide_game_over()
	$MenuControl.hide_pause()
	current_game_type = GameType.NONE
	match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
		true: unlock_full_game()
		false: pass
	SaveSettings.increment_reset_times()


func start_button_2p():
	current_game_type = GameType.VS_2P
	$MenuControl.hide_main_menu()
	top_current_strikes = 0
	bot_current_strikes = 0
	bot_score = 0
	top_score = 0
	$MenuControl.update_strikes_bot()
	$MenuControl.update_strikes_top()
	show_td_hide_extra()
	apply_retro_mode()
	var _cust
	_cust = customize.instance()
	add_child(_cust)

func start_coin_toss_2p():
	$MenuControl.start_game_transition()
	var _ct
	_ct = coin_toss.instance()
	add_child(_ct)
	_ct.start_2P()


func start_action_2p(to_start):
	current_game_type = GameType.VS_2P
	top_score = 0
	bot_score = 0
	top_current_strikes = 0
	bot_current_strikes = 0
	$MenuControl.update_strikes_bot()
	$MenuControl.update_strikes_top()
	$StatControl.reset_stats()
	$MenuControl.update_score_top(top_score)
	$MenuControl.update_score_bot(bot_score)
	$MenuControl.hide_menu_background()
	current_game_state = GameState.POSSESSION
	$GameStartSound.play()
	if SaveSettings.pixel_push_save_data.gameplay_music:
		play_gameplay_music()
	can_pause = true
	match to_start:
		FirstMove.BOT:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_KICKOFF)
		FirstMove.TOP:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_KICKOFF)
	player_can_control = true
	$MenuControl.show_score()


func start_button_practice():
	current_game_type = GameType.PRACTICE
	$ThemeControl.apply_practice_theme()
	start_action_practice()


func start_action_practice():
	$MenuControl.hide_menu_background()
	$MenuControl.hide_main_menu()
	can_pause = true
	player_can_control = true
	can_action_cam = true
	current_game_type = GameType.PRACTICE
	apply_retro_mode()
	$GameEventControl.game_event_action($GameEventControl.GameEvent.PRACTICE_START)


func start_button_ai():
	current_game_type = GameType.VS_AI
	apply_retro_mode()
	$MenuControl.hide_main_menu()
	bot_current_strikes = 0
	top_current_strikes = 0
	bot_score = 0
	top_score = 0
	show_td_hide_extra()
	var _cust
	_cust = customize.instance()
	add_child(_cust)


func start_coin_toss_ai():
	$MenuControl.start_game_transition()
	var _ct
	_ct = coin_toss.instance()
	add_child(_ct)
	_ct.start_AI()


func start_action_ai(to_start):
	current_game_type = GameType.VS_AI
	top_score = 0
	bot_score = 0
	top_current_strikes = 0
	bot_current_strikes = 0
	$MenuControl.update_strikes_bot()
	$MenuControl.update_strikes_top()
	$StatControl.reset_stats()
	$MenuControl.update_score_top(top_score)
	$MenuControl.update_score_bot(bot_score)
	$MenuControl.hide_menu_background()
	current_game_state = GameState.POSSESSION
	$GameStartSound.play()
	can_pause = true
	if SaveSettings.pixel_push_save_data.gameplay_music:
		play_gameplay_music()
	match to_start:
		FirstMove.BOT:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_KICKOFF)
			player_can_control = true
		FirstMove.TOP:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_KICKOFF)
	$MenuControl.show_score()


func start_button_tournament():
	var _tournament
	_tournament = tournament.instance()
	add_child(_tournament)
	_tournament.start(1)

func tournament_return():
	can_action_cam = false
	var _tournament
	_tournament = tournament.instance()
	add_child(_tournament)
	_tournament.return_from_game()

func start_button_challenge():
	current_game_type = GameType.CHALLENGE
	ThemeControl.apply_challenge_theme()
	$MenuControl.show_challenge_list()
	$MenuControl.hide_main_menu()
	show_td_hide_extra()


func start_button_two_minute():
	$MenuControl.hide_menu_background()
	$MenuControl.hide_challenge_list()
	$MenuControl.show_two_minute_drill_start()


func start_action_two_minute():
	apply_retro_mode()
	$MenuControl.two_minute_drill_gameplay()
	player_can_control = true
	can_pause = true
	$GameEventControl.game_event_action($GameEventControl.GameEvent.TWO_MINUTE_DRILL_START)


func start_button_beat_the_defense():
	apply_retro_mode()
	$MenuControl.hide_menu_background()
	$MenuControl.hide_challenge_list()
	$MenuControl.show_shred_the_defense_start()


func start_action_beat_the_defense():
	$MenuControl.shred_the_defense_gameplay()
	player_can_control = true
	can_pause = true
	$GameEventControl.game_event_action($GameEventControl.GameEvent.SHRED_THE_DEFENSE_START)


func start_button_fgf():
	apply_retro_mode()
	$MenuControl.hide_menu_background()
	$MenuControl.hide_challenge_list()
	$MenuControl.show_fgf_start()


func start_action_fgf():
	$MenuControl.show_fgf_gameplay()
	player_can_control = true
	can_pause = false
	$GameEventControl.game_event_action($GameEventControl.GameEvent.FIELD_GOAL_FRENZY_START)


func return_button_Main_menu():
	get_tree().reload_current_scene()


func add_ball(ball_position, rotation):
	var _f = football.instance()
	add_child(_f)
	_f.start(ball_position, rotation)
	current_ball = _f


# attempting better ways of cleaning up the items
func remove_ball():
	var footballs = get_tree().get_nodes_in_group("football")
	for fb in footballs:
		fb.queue_free()


func start_game_2p(possession):
	match possession:
		FirstMove.BOT:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_KICKOFF)
		FirstMove.TOP:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_KICKOFF)


# Main flow logic is here, it's bit, messy, but seems to be fast enough
func _on_turn_ended():
	cleanup_defense()
	$Gamefield/BotFgMachine.hide()
	$Gamefield/TopFgMachine.hide()
	$GameCamera.camera_action_move($GameCamera.CameraPosition.DEFAULT)
	end_yard = current_ball.position.y
	last_distance_moved = calculate_distance_moved()
	match current_game_type:
		GameType.VS_2P:
			turn_end_game_flow()
		GameType.VS_AI:
			turn_end_game_flow()
		GameType.PRACTICE:
			$PracticeControl.update_practice()
			$GameEventControl.game_event_action($GameEventControl.GameEvent.PRACTICE_TURN)
		GameType.CHALLENGE:
			var ChallengeType = $ChallengeControl.ChallengeType
			match $ChallengeControl.current_challenge_type:
				ChallengeType.TWO_MINUTE_DRILL:
					$GameEventControl.game_event_action($GameEventControl.GameEvent.TWO_MINUTE_DRILL_UPDATE)
				ChallengeType.FOUR_DOWN_LADDER:
					pass
				ChallengeType.SHRED_THE_DEFENSE:
					$GameEventControl.game_event_action($GameEventControl.GameEvent.SHRED_THE_DEFENSE_UPDATE)
				ChallengeType.FGF:
					$GameEventControl.game_event_action($GameEventControl.GameEvent.FIELD_GOAL_FRENZY_UPDATE)


func turn_end_game_flow():
	remove_touch_trail()
	match current_game_state:
		GameState.POSSESSION:
	# we have to check gamestate for turn stats here as touchdowns
	# and extra points are not technically "turns" and can't be stored in GameEventControl
			if did_ball_oob:
				out_of_bounds()
				return
			can_action_cam = true
			match current_ball.current_turn:
				current_ball.Turn.BOT:
					$StatControl.bot_stats.turns_taken += 1
				current_ball.Turn.TOP, current_ball.Turn.AI:
					$StatControl.top_stats.turns_taken += 1
			$StatControl.update_stats()
			match evaluate_touchdown():
				true:
					play_touchdown_sound()
					play_ref_touchdown_sound()
					$MenuControl.animate_ref_cam(1)
					touchdown()
					return
				false:
					$MenuControl.animate_ref_cam(2)
			if evaluate_touchback_safety():
				touchback_safety()
				return
			get_ball_current_yardline()
			match current_ball.current_turn:
				current_ball.Turn.BOT:
					var _local_miss = 0 + current_yard_line
					$StatControl.bot_stats.miss_turns += 1
					$StatControl.bot_stats.miss_distance_total += _local_miss
					$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_POSSESSION)
				current_ball.Turn.TOP, current_ball.Turn.AI:
					var _local_miss = 100 - current_yard_line
					$StatControl.top_stats.miss_turns += 1
					$StatControl.top_stats.miss_distance_total += _local_miss
					$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_POSSESSION)
		GameState.XTRAPT1:
			var _xtra_point_action = evaluate_xtrapt1()
			current_game_state = GameState.POSSESSION
			match _xtra_point_action:
				11:
					$RefItsGoodSound.play()
					play_touchdown_sound()
					$MenuControl.animate_ref_cam(1)
					$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_XTRAPT_SUCCESS_1)
				21:
					$RefItsGoodSound.play()
					play_touchdown_sound()
					$MenuControl.animate_ref_cam(1)
					$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_XTRAPT_SUCCESS_1)
				0:
					$FailSound.play()
					$MenuControl.animate_ref_cam(2)
					match current_ball.current_turn:
						current_ball.Turn.BOT:
							$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_XTRAPT_FAIL_1)
						current_ball.Turn.TOP, current_ball.Turn.AI:
							$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_XTRAPT_FAIL_1)
		GameState.XTRAPT2:
			var _xtra_point_action = evaluate_xtrapt2()
			current_game_state = GameState.POSSESSION
			match _xtra_point_action:
				12:
					$RefItsGoodSound.play()
					play_touchdown_sound()
					$MenuControl.animate_ref_cam(1)
					$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_XTRAPT_SUCCESS_2)
				22:
					$RefItsGoodSound.play()
					play_touchdown_sound()
					$MenuControl.animate_ref_cam(1)
					$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_XTRAPT_SUCCESS_2)
				0:
					$FailSound.play()
					$MenuControl.animate_ref_cam(2)
					match current_ball.current_turn:
						current_ball.Turn.BOT:
							$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_XTRAPT_FAIL_2)
						current_ball.Turn.TOP, current_ball.Turn.AI:
							$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_XTRAPT_FAIL_2)
		GameState.FGATTEMPT:
			var _fg_action = evaluate_fg()
			current_game_state = GameState.POSSESSION
			if bot_current_strikes == 3:
				bot_current_strikes = 0
				$MenuControl.update_strikes_bot()
			if top_current_strikes == 3:
				top_current_strikes = 0
				$MenuControl.update_strikes_top()
			match _fg_action:
				13:
					play_touchdown_sound()
					$RefItsGoodSound.play()
					$MenuControl.animate_ref_cam(1)
					$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_FG_SUCCESS)
				23:
					play_touchdown_sound()
					$RefItsGoodSound.play()
					$MenuControl.animate_ref_cam(1)
					$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_FG_SUCCESS)
				0:
					$FailSound.play()
					$MenuControl.animate_ref_cam(2)
					match current_ball.current_turn:
						current_ball.Turn.BOT:
							$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_FG_FAIL)
						current_ball.Turn.TOP, current_ball.Turn.AI:
							$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_FG_FAIL)


# touchdown logic // messy
func evaluate_touchdown():
	var _top_zone_bodies = $TopTd.get_overlapping_bodies()
	var _bottom_zone_bodies = $BotTd.get_overlapping_bodies()
	if _top_zone_bodies.size() > 0 and current_ball.position.y > 100:
		for body in _top_zone_bodies:
			if body.is_in_group("football"):
				match current_ball.current_turn:
					current_ball.Turn.BOT:
						$CelebrationControl.celebrate_touchdown()
						return true
	if _bottom_zone_bodies.size() > 0 and current_ball.position.y < 1180:
		for body in _bottom_zone_bodies:
			if body.is_in_group("football"):
				match current_ball.current_turn:
					current_ball.Turn.TOP, current_ball.Turn.AI:
						$CelebrationControl.celebrate_touchdown()
						return true
	return false


func touchdown():
	match current_ball.current_turn:
		current_ball.Turn.BOT:
			if redzone_attempt:
				$StatControl.bot_stats.redzone_successes += 1
			$StatControl.bot_stats.last_touchdown_distance = last_distance_moved
			$StatControl.bot_stats.total_touchdown_distance += last_distance_moved
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_TD)
		current_ball.Turn.TOP, current_ball.Turn.AI:
			if redzone_attempt:
				$StatControl.top_stats.redzone_successes += 1
			$StatControl.top_stats.last_touchdown_distance = last_distance_moved
			$StatControl.top_stats.total_touchdown_distance += last_distance_moved
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_TD)


func evaluate_touchback_safety():
	var _top_dead_zone_bodies = $TopDeadZone.get_overlapping_bodies()
	var _bot_dead_zone_bodies = $BotDeadZone.get_overlapping_bodies()
	if _top_dead_zone_bodies.size() > 0:
		for body in _top_dead_zone_bodies:
			if body.is_in_group("football"):
				match current_ball.current_turn:
					current_ball.Turn.BOT:
						dead_zone_result = DeadZone.BOT_TOUCHBACK
						$MenuControl.animate_ref_cam(3)
						return true
					current_ball.Turn.TOP, current_ball.Turn.AI:
						dead_zone_result = DeadZone.TOP_SAFETY
						return true
	if _bot_dead_zone_bodies.size() > 0:
		for body in _bot_dead_zone_bodies:
			if body.is_in_group("football"):
				match current_ball.current_turn:
					current_ball.Turn.BOT:
						dead_zone_result = DeadZone.BOT_SAFETY
						return true
					current_ball.Turn.TOP, current_ball.Turn.AI:
						dead_zone_result = DeadZone.TOP_TOUCHBACK
						$MenuControl.animate_ref_cam(4)
						return true
	return false


func touchback_safety():
	match dead_zone_result:
		DeadZone.TOP_TOUCHBACK:
			$TBSound.play()
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_TB)
		DeadZone.BOT_TOUCHBACK:
			$TBSound.play()
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_TB)
		DeadZone.TOP_SAFETY:
			$FailSound.play()
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_SAFETY)
		DeadZone.BOT_SAFETY:
			$FailSound.play()
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_SAFETY)


func play_touchdown_sound():
	randomize()
	var _selection = int(rand_range(1,4))
	match _selection:
		1:
			$TouchdownSound.play()
		2:
			$TouchdownSound1.play()
		3:
			$TouchdownSound2.play()


func play_gameplay_music():
	# breakpoints at 0, 170, 299.5
	randomize()
	var _initialize_seed = int(rand_range(0,3))
	match _initialize_seed:
		0:
			$GameplayMusic.play(0)
		1:
			$GameplayMusic.play(170)
		2:
			$GameplayMusic.play(299.5)


func stop_gameplay_music():
	$GameplayMusic.stop()


func play_ref_touchdown_sound():
	var _fifty_fifty = int(rand_range(1,3))
	match _fifty_fifty:
		1: $RefTouchdownSound.play()
		2: $RefTouchdownSound2.play()

# game over logic
func evaluate_game_over():
	var _winning_player
	if bot_score >= winning_score:
		_winning_player = 1
		player_can_control = false
		$MenuControl.show_game_over(_winning_player)
		return true
	if top_score >= winning_score:
		player_can_control = false
		_winning_player = 2
		$MenuControl.show_game_over(_winning_player)
		return true


func evaluate_strikes():
	var _strike_choice
	if bot_current_strikes == 3:
		match current_game_type:
			GameType.VS_2P:
				present_xtrapt_choice(Turn.TOP, 2)
				return true
			GameType.VS_AI:
				MenuControl.start_game_transition()
				$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_FG_ATTEMPT)
		return true
	if top_current_strikes == 3:
		present_xtrapt_choice(Turn.BOT, 2)
		return true


func bot_fg_event():
	MenuControl.start_game_transition()
	$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_FG_ATTEMPT)

func top_fg_event():
	MenuControl.start_game_transition()
	$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_FG_ATTEMPT)


func fg_attempt(fg_ball_turn):
	var _fg
	var _position_offset
	player_can_control = true
	can_pause = true
	$BotTd.hide()
	$TopTd.hide()
	can_glow = false
	$BotTd.set_process(false)
	$TopTd.set_process(false)
	$OobRight.set_block_signals(true)
	$OobLeft.set_block_signals(true)
	_fg = field_goal_kick.instance()
	current_fg = _fg
	var _fg_sprite = _fg.get_node("GoalPostBottom")
	var _fg_sprite1 = _fg.get_node("GoalPostTop")
	# have to set position here due to some weird race condition
	match fg_ball_turn:
		Turn.BOT:
			_position_offset = $TeamTop20Yd.position
			_position_offset.y -= 25
			_fg.position = _position_offset
			_fg_sprite1.set_texture($ThemeControl.bot_post1)
			_fg_sprite.set_texture($ThemeControl.bot_post2)
			$Gamefield/TopFgMachine.show()
		Turn.TOP:
			_position_offset = $TeamBot20Yd.position
			_position_offset.y += 25
			_fg.position = _position_offset
			_fg.set_rotation_degrees(180)
			_fg_sprite1.set_texture($ThemeControl.top_post1)
			_fg_sprite.set_texture($ThemeControl.top_post2)
			$Gamefield/BotFgMachine.show()
	field_goal = _fg
	add_child(_fg)
	_fg.start(0)


func evaluate_fg():
	if field_goal.successful_kick:
		match current_ball.current_turn:
			current_ball.Turn.BOT:
				if current_ball.position.y < 185:
					return 13
				return 0
			current_ball.Turn.TOP, current_ball.Turn.AI:
				if current_ball.position.y > 1095:
					return 23
				return 0
	else:
		return 0


func present_xtrapt_choice(xtra_ball_color, type):
	var _xtra
	_xtra = xtra_pt_choice.instance()
	# connect to signals to get from menu // I wish I had done this before in code
	_xtra.connect("one_pt", self, "xtra_pt1_game_event")
	_xtra.connect("two_pt", self, "xtra_pt2_game_event")
	match xtra_ball_color:
		Turn.BOT:
			_xtra.connect("field_goal", self, "bot_fg_event")
		Turn.TOP:
			_xtra.connect("field_goal", self, "top_fg_event")
	player_can_control = false
	can_pause = false
	add_child(_xtra)
	_xtra.start(xtra_ball_color, type)


func xtra_pt1_game_event(xtra_ball_color):
	match xtra_ball_color:
		Turn.BOT:
			MenuControl.start_game_transition()
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_XTRAPT_ATTEMPT_1)
		Turn.TOP:
			MenuControl.start_game_transition()
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_XTRAPT_ATTEMPT_1)


func xtra_pt2_game_event(xtra_ball_color):
	match xtra_ball_color:
		Turn.BOT:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_XTRAPT_ATTEMPT_2)
		Turn.TOP:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_XTRAPT_ATTEMPT_2)


func xtra_pt_attempt_1(xtra_ball_color):
	var _fg
	var _position_offset
	player_can_control = true
	can_pause = true
	$BotTd.hide()
	$TopTd.hide()
	$BotTd.set_process(false)
	$TopTd.set_process(false)
	can_glow = false
	$OobRight.set_block_signals(true)
	$OobLeft.set_block_signals(true)
	_fg = field_goal_kick.instance()
	current_fg = _fg
	var _fg_sprite = _fg.get_node("GoalPostBottom")
	var _fg_sprite1 = _fg.get_node("GoalPostTop")
	# have to set position here due to some weird race condition
	match xtra_ball_color:
		Turn.BOT:
			_position_offset = $TeamTop20Yd.position
			_position_offset.y -= 25
			_fg.position = _position_offset
			_fg_sprite1.set_texture($ThemeControl.bot_post1)
			_fg_sprite.set_texture($ThemeControl.bot_post2)
			$Gamefield/TopFgMachine.show()
		Turn.TOP:
			_position_offset = $TeamBot20Yd.position
			_position_offset.y += 25
			_fg.position = _position_offset
			_fg.set_rotation_degrees(180)
			_fg_sprite1.set_texture($ThemeControl.top_post1)
			_fg_sprite.set_texture($ThemeControl.top_post2)
			$Gamefield/BotFgMachine.show()
	#$ThemeControl.apply_fg_background(xtra_ball_color)
	field_goal = _fg
	add_child(_fg)
	_fg.start(0)

func evaluate_xtrapt1():
	if field_goal.successful_kick:
		match current_ball.current_turn:
			current_ball.Turn.BOT:
				if current_ball.position.y < 185:
					return 11
				return 0
			current_ball.Turn.TOP, current_ball.Turn.AI:
				if current_ball.position.y > 1095:
					return 21
				return 0
	else:
		return 0


func xtra_pt_attempt_2():
	$BotTd.hide()
	$TopTd.hide()
	$BotTd.set_process(false)
	$TopTd.set_process(false)
	$Top2Pt.set_process(true)
	$Bot2Pt.set_process(true)
	$Top2Pt.show()
	$Bot2Pt.show()
	player_can_control = true
	can_pause = true


func evaluate_xtrapt2():
	var _top_zone_bodies = $Top2Pt.get_overlapping_bodies()
	var _bottom_zone_bodies = $Bot2Pt.get_overlapping_bodies()
	if _top_zone_bodies.size() > 0 and current_ball.position.y > 100:
		match current_ball.current_turn:
			current_ball.Turn.BOT:
				$CelebrationControl.celebrate_2pt()
				return 12
	if _bottom_zone_bodies.size() > 0 and current_ball.position.y < 1180:
		match current_ball.current_turn:
			current_ball.Turn.TOP, current_ball.Turn.AI:
				$CelebrationControl.celebrate_2pt()
				return 22
	return 0


func show_td_hide_extra():
	$BotTd.show()
	$TopTd.show()
	$BotTd.set_process(true)
	$TopTd.set_process(true)
	$OobLeft.set_block_signals(false)
	$OobRight.set_block_signals(false)
	$Top2Pt.set_process(false)
	$Bot2Pt.set_process(false)
	can_glow = true
	$Top2Pt.hide()
	$Bot2Pt.hide()


# only really necessary if evaluating movement inside of the gamefield
func get_ball_current_yardline():
	var _high_point
	var _low_point
	var _left = current_ball.get_node("LeftPoint").get_global_position()
	var _right = current_ball.get_node("RightPoint").get_global_position()
	var _top = current_ball.get_node("TopPoint").get_global_position()
	_high_point = max(_left.y, _right.y)
	_high_point = max(_high_point, _top.y)
	_low_point = min(_left.y, _right.y)
	_low_point = min(_low_point, _top.y)
	match current_ball.current_turn:
		current_ball.Turn.BOT:
			current_yard_line = convert_to_yard(_low_point)
		current_ball.Turn.TOP, current_ball.Turn.AI:
			current_yard_line = convert_to_yard(_high_point)
		current_ball.Turn.CHALLENGE_PRACTICE:
			current_yard_line = convert_to_yard(_high_point)


func convert_to_yard(global_pos):
	var _top_goal = 100
	var _bot_goal = 1180
	# reference oneYard = float(10.8)
	var _local_yard
	if global_pos > _top_goal and global_pos < _bot_goal:
		_local_yard = global_pos - 100
		_local_yard = _local_yard / 10.8
		return int(round(_local_yard))
	else:
		return 0


func calculate_distance_moved():
	begin_yard = begin_yard / 10.8
	end_yard = end_yard / 10.8
	var _yards_moved = int(round(begin_yard)) - int(round(end_yard))
	_yards_moved = abs(_yards_moved)
	return _yards_moved


func pause_game():
	# need to snap camera back to normal before pausing
	$GameCamera.camera_action_move($GameCamera.CameraPosition.DEFAULT)
	$MenuControl.show_pause()
	get_tree().paused = true


	# OOB Logic
func _on_oobRight_body_entered(body):
	evaluate_out_of_bounds(body)


func _on_oobLeft_body_entered(body):
	evaluate_out_of_bounds(body)


func evaluate_out_of_bounds(body):
	match current_game_type:
		GameType.VS_2P:
			$MenuControl.show_score()
			if body.is_in_group("football") and !did_ball_oob:
				$OobMarker.position = current_ball.position
				if $OobMarker.position.y > 1130:
					$OobMarker.position.y = 1130
				if $OobMarker.position.y < 150:
					$OobMarker.position.y = 150
				did_ball_oob = true
				match current_ball.current_turn:
					current_ball.Turn.BOT:
						$OobMarker/BotOobGraphic.show()
					current_ball.Turn.TOP, current_ball.Turn.AI:
						$OobMarker/TopOobGraphic.show()
		GameType.VS_AI:
			$MenuControl.show_score()
			if body.is_in_group("football") and !did_ball_oob:
				$OobMarker.position = current_ball.position
				if $OobMarker.position.y > 1130:
					$OobMarker.position.y = 1130
				if $OobMarker.position.y < 150:
					$OobMarker.position.y = 150
				match current_ball.current_turn:
					current_ball.Turn.BOT:
						$OobMarker/BotOobGraphic.show()
					current_ball.Turn.TOP, current_ball.Turn.AI:
						$OobMarker/TopOobGraphic.show()
				did_ball_oob = true
		GameType.PRACTICE:
			if body.is_in_group("football"):
				practice_oob = true
		GameType.CHALLENGE:
			if body.is_in_group("football"):
				challenge_oob = true


func out_of_bounds():
	$OobSound.play()
	$OobMarker/TopOobGraphic.hide()
	$OobMarker/BotOobGraphic.hide()
	$MenuControl.hide_ref_cam()
	$GameCamera.camera_action_move($GameCamera.CameraPosition.DEFAULT)
	did_ball_oob = false
	match current_ball.current_turn:
		current_ball.Turn.BOT:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_OOB)
		current_ball.Turn.TOP, current_ball.Turn.AI:
			$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_OOB)
		current_ball.Turn.CHALLENGE_PRACTICE:
			pass


# below are some ball related items which are called often
# to evaluate the camera positioning and ball glow
# this is functional but expensive, may need to refactor later
#func td_check_ball_glow():
#	match current_game_type:
#		GameType.VS_2P: glow_ball()
#		GameType.VS_AI: glow_ball()
#		GameType.PRACTICE: glow_ball()
#		GameType.CHALLENGE:
#			var _challenge_type = $ChallengeControl.ChallengeType
#			match $ChallengeControl.current_challenge_type:
#				_challenge_type.TWO_MINUTE_DRILL:
#					glow_ball()
#				_: return


# edge case function to prevent a ball from being outside the game world
# and preventing gameplay from continuing
func validate_ball_location():
	var _bp = current_ball.position
	if _bp.x > 820 or _bp.x < -100 or _bp.y > 1380 or _bp.y < -100:
		match current_ball.current_turn:
			current_ball.Turn.BOT:
				$GameEventControl.game_event_action($GameEventControl.GameEvent.BOT_KICKOFF)
			current_ball.Turn.TOP, current_ball.Turn.AI:
				$GameEventControl.game_event_action($GameEventControl.GameEvent.TOP_KICKOFF)


#func glow_ball():
#	if is_instance_valid(current_ball):
#		if can_glow:
#			var _bodies_bot = $BotTd.get_overlapping_bodies()
#			var _bodies_top = $TopTd.get_overlapping_bodies()
#			if _bodies_bot.size() > 0:
#				for body in _bodies_bot:
#					if body.is_in_group("football"):
#						if current_ball.current_turn == current_ball.Turn.TOP or current_ball.current_turn == current_ball.Turn.AI:
#							#glow_material.set_shader_param("outline_color", $ThemeControl.top_color_code)
#			#				current_ball.get_node("Sprite").set_material(glow_material)
#							pass
#							return
#			if _bodies_top.size() > 0:
#				for body in _bodies_top:
#					if body.is_in_group("football"):
#						if  current_ball.current_turn == current_ball.Turn.BOT or current_ball.current_turn == current_ball.Turn.CHALLENGE_PRACTICE:
#							#glow_material.set_shader_param("outline_color", $ThemeControl.bot_color_code)
#							#current_ball.get_node("Sprite").set_material(glow_material)
#							#return
#			#current_ball.get_node("Sprite").set_material(null)


# this is so we don't action cam during challenge and practice
func evaluate_ball_camera():
	if can_action_cam and is_instance_valid(current_ball):
		match current_game_type:
			GameType.VS_AI:
				gameplay_action_cam()
			GameType.VS_2P:
				gameplay_action_cam()
			GameType.PRACTICE:
				gameplay_action_cam()
			_: return


# we only care about the y velocity as the
# ball could be spinning on the x axis
# TODO, figure out more camera movements
func gameplay_action_cam():
	var _local_velocity
	var _local_position
	if current_ball.player_moved or current_ball.ai_moved:
		_local_velocity = current_ball.get_linear_velocity()
		_local_position = current_ball.position
		match current_ball.current_turn:
			current_ball.Turn.BOT, current_ball.Turn.CHALLENGE_PRACTICE:
				var _local_velocity_y = abs(_local_velocity.y)
				if _local_position.y < 640 and _local_velocity_y > 420:
					if _local_position.x >= 241 and _local_position.x <= 479:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.BOT_MIDDLE)
					if _local_position.x <= 240:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.BOT_LEFT)
					if _local_position.x >= 480:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.BOT_RIGHT)
				if _local_position.y < 160 and _local_position.y > 100 and _local_velocity_y < 175 and _local_velocity_y > 10:
					if _local_position.x >= 241 and _local_position.x <= 479:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.ACTION_BOT_MIDDLE)
					if _local_position.x >= 0 and _local_position.x <= 240:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.ACTION_BOT_LEFT)
					if _local_position.x >= 480 and _local_position.x <= 720:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.ACTION_BOT_RIGHT)
			current_ball.Turn.TOP, current_ball.Turn.AI:
				if _local_position.y > 640 and _local_velocity.y > 420:
					if _local_position.x >= 241 and _local_position.x <= 479:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.TOP_MIDDLE)
					if _local_position.x <= 240:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.TOP_LEFT)
					if _local_position.x >= 480:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.TOP_RIGHT)
				if _local_position.y > 1120 and _local_position.y < 1180 and _local_velocity.y < 175 and _local_velocity.y > 10:
					if _local_position.x >= 241 and _local_position.x <= 479:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.ACTION_TOP_MIDDLE)
					if _local_position.x <= 240:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.ACTION_TOP_LEFT)
					if _local_position.x >= 480 and _local_position.x <= 720:
						$GameCamera.camera_action_move($GameCamera.CameraPosition.ACTION_TOP_RIGHT)



func draw_touch_trail():
	if current_touch != null and is_instance_valid(current_touch):
		$MoverTrail.show()
		$MoverTrail.position = current_touch.position
		$MoverTrail.emitting = true
		if is_instance_valid(current_ball):
			match current_ball.current_turn:
				current_ball.Turn.BOT: $MoverTrail.color = ThemeControl.bot_color_code
				current_ball.Turn.TOP, current_ball.Turn.AI: $MoverTrail.color = ThemeControl.top_color_code
				current_ball.Turn.CHALLENGE_PRACTICE: ThemeControl.bot_color_code
	else:
		$MoverTrail.emitting = false
		$MoverTrail.position = Vector2(-60,-60)


func remove_touch_trail():
	$MoverTrail.hide()


# came up with this idea from the challenge control, expanded on it here
# defender mode
func cleanup_defense():
	for defender in get_tree().get_nodes_in_group("defenders"):
		defender.kill()

func randomize_defense():
	var _defense = DefenseControl.instance()
	current_defense = _defense
	add_child(_defense)
	_defense.add_to_group("defenders")
	match current_ball.current_turn:
		current_ball.Turn.TOP:
			_defense.start(2)
		current_ball.Turn.BOT:
			_defense.start(1)


# intercept mobile goback signal

#func _notification(what):
	#if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		# if can_pause:
			#pause_game()

func apply_retro_mode():
	match SaveSettings.pixel_push_save_data["is_retro_mode"]:
		true:
			if current_game_type != GameType.NONE and current_game_type != GameType.PRACTICE and current_game_type != GameType.CHALLENGE:
				var _retro_material = RetroModeRect.get_material()
				var _retro_grid = get_viewport().get_visible_rect().size / 4
				_retro_material.set_shader_param("screen_size",_retro_grid)
				var _retro_mode_position = RetroMode.position - RetroMode.get_global_transform_with_canvas().origin
				RetroMode.position = _retro_mode_position
				RetroModeRect.rect_size = get_viewport().get_visible_rect().size
				RetroModeRect.show()
		false: RetroModeRect.hide()

# related to IAP, unlocking and locking
func unlock_full_game():
	var _UnlockFull = $MenuLayer/PlayMenu/UnlockFullButton
	_UnlockFull.hide()


func lock_game():
	var _UnlockFull = $MenuLayer/PlayMenu/UnlockFullButton
	_UnlockFull.show()
	SaveSettings.pixel_push_save_data["theme"] = 1
	SaveSettings.pixel_push_save_data["is_retro_mode"] = false
	apply_retro_mode()
	SaveSettings.close_settings_save()

