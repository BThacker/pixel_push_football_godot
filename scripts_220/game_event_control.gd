# 2020 Pixel Push Football - Brandon Thacker 

extends Node2D

onready var Main = get_parent()
onready var PracticeControl = get_parent().get_node("PracticeControl")
onready var ChallengeControl = get_parent().get_node("ChallengeControl")
onready var Rubick = Main.get_node("Rubick")
onready var ThemeControl = Main.get_node("ThemeControl")
onready var MenuControl = Main.get_node("MenuControl")
onready var StatControl = Main.get_node("StatControl")
onready var TeamTop20Yd = Main.get_node("TeamTop20Yd")
onready var TeamBot20Yd = Main.get_node("TeamBot20Yd")
onready var OobMarker = Main.get_node("OobMarker")
onready var FiftyYdMarker = Main.get_node("FiftyYdMarker")
onready var bot_stats = StatControl.bot_stats
onready var top_stats = StatControl.top_stats
onready var red_td = Main.get_node("BotTd")
onready var blue_td = Main.get_node("TopTd")

var ball_spawn_pos = Vector2()
var ball_rotation = 0
var current_game_event

enum GameEvent{
	TOP_KICKOFF,
	BOT_KICKOFF,
	TOP_POSSESSION,
	BOT_POSSESSION,
	NEW_GAME,
	TOP_TD,
	BOT_TD,
	TOP_TB,
	BOT_TB,
	TOP_SAFETY,
	BOT_SAFETY,
	TOP_OOB,
	BOT_OOB,
	TOP_FG_ATTEMPT,
	BOT_FG_ATTEMPT,
	TOP_FG_SUCCESS,
	BOT_FG_SUCCESS,
	TOP_FG_FAIL,
	BOT_FG_FAIL
	TOP_XTRAPT_ATTEMPT_1,
	BOT_XTRAPT_ATTEMPT_1,
	TOP_XTRAPT_SUCCESS_1,
	BOT_XTRAPT_SUCCESS_1,
	TOP_XTRAPT_ATTEMPT_2,
	BOT_XTRAPT_ATTEMPT_2,
	TOP_XTRAPT_SUCCESS_2,
	BOT_XTRAPT_SUCCESS_2,
	TOP_XTRAPT_FAIL_1,
	BOT_XTRAPT_FAIL_1,
	TOP_XTRAPT_FAIL_2,
	BOT_XTRAPT_FAIL_2,
	PRACTICE_START,
	PRACTICE_TURN,
	TWO_MINUTE_DRILL_START,
	TWO_MINUTE_DRILL_UPDATE,
	SHRED_THE_DEFENSE_START,
	SHRED_THE_DEFENSE_UPDATE,
	FIELD_GOAL_FRENZY_START,
	FIELD_GOAL_FRENZY_UPDATE
	}


func game_event_action(game_action):
	match game_action:
		GameEvent.BOT_KICKOFF:
			# bug fix for older devices, check and then free ball if needed
			if is_instance_valid(Main.current_ball):
				Main.remove_ball()
			MenuControl.show_score()
			Main.can_action_cam = true
			match Main.randomize_kickoff:
				true:
					var _random_x = int(rand_range(-100,100))
					var _random_y = int(rand_range(50,-100))
					var _offset = TeamBot20Yd.position + Vector2(_random_x, _random_y)
					ball_spawn_pos = _offset
				false: ball_spawn_pos = TeamBot20Yd.position
			ball_rotation = 0
			Main.add_ball(ball_spawn_pos,ball_rotation)
			Main.current_ball.set_turn(Main.current_ball.Turn.BOT)
			if Main.random_defender_mode:
				Main.randomize_defense()
			# secondary check to attempt to resolve bug on slower devices
			if !is_instance_valid(Main.current_ball):
				Main.add_ball(ball_spawn_pos,ball_rotation)
				Main.current_ball.set_turn(Main.current_ball.Turn.BOT)

		GameEvent.TOP_KICKOFF:
			# bug fix for older devices, check and then free ball if needed
			if is_instance_valid(Main.current_ball):
				Main.remove_ball()
			match Main.randomize_kickoff:
				true:
					var _random_x = int(rand_range(-100,100))
					var _random_y = int(rand_range(-50,100))
					var _offset = TeamTop20Yd.position + Vector2(_random_x, _random_y)
					ball_spawn_pos = _offset
				false: ball_spawn_pos = TeamTop20Yd.position
			ball_rotation = 180
			Main.add_ball(ball_spawn_pos, ball_rotation)
			MenuControl.show_score()
			Main.can_action_cam = true
			Main.current_ball.set_turn(Main.current_ball.Turn.TOP)
			if Main.random_defender_mode:
				Main.randomize_defense()
			# secondary check to attempt to resolve bug on slower devices
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.current_ball.set_turn(Main.current_ball.Turn.AI)
					Rubick.kickoff_decide()

		GameEvent.BOT_POSSESSION:
			Main.current_ball.set_turn(Main.current_ball.Turn.BOT)
			MenuControl.show_score()
			Main.can_action_cam = true
			Main.validate_ball_location()
			Main.get_ball_current_yardline()
			if Main.random_defender_mode:
				Main.randomize_defense()

			if Main.current_yard_line <22:
				Main.redzone_attempt = true
				StatControl.bot_stats.redzone_attempts += 1
			else: Main.redzone_attempt = false

		GameEvent.TOP_POSSESSION:
			Main.current_ball.set_turn(Main.current_ball.Turn.TOP)
			MenuControl.show_score()
			Main.can_action_cam = true
			Main.validate_ball_location()
			Main.get_ball_current_yardline()
			if Main.random_defender_mode:
				Main.randomize_defense()
			if Main.current_yard_line > 78:
				Main.redzone_attempt = true
				StatControl.top_stats.redzone_attempts += 1
			else: Main.redzone_attempt = false
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.current_ball.set_turn(Main.current_ball.Turn.AI)
					Rubick.move_ball_possession_decide()

		GameEvent.NEW_GAME:
			pass

		GameEvent.TOP_TD:
			Main.remove_ball()
			MenuControl.show_score()
			Main.top_score += 6
			MenuControl.update_score_top(Main.top_score)
			top_stats.touchdowns += 1
			if Main.evaluate_game_over():
				return
			MenuControl.notify_splash(MenuControl.Notifications.TOP_TOUCHDOWN)
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.current_ball.set_turn(Main.current_ball.Turn.AI)
					Rubick.xtra_action_decide()
				Main.GameType.VS_2P:
					Main.present_xtrapt_choice(Main.Turn.TOP, 1)

		GameEvent.BOT_TD:
			Main.remove_ball()
			MenuControl.show_score()
			Main.bot_score += 6
			MenuControl.update_score_bot(Main.bot_score)
			bot_stats.touchdowns += 1
			if Main.evaluate_game_over():
				return
			MenuControl.notify_splash(MenuControl.Notifications.BOT_TOUCHDOWN)
			Main.present_xtrapt_choice(Main.Turn.BOT, 1)

		GameEvent.TOP_SAFETY:
			Main.remove_ball()
			Main.bot_score += 2
			top_stats.safeties += 1
			MenuControl.update_score_bot(Main.bot_score)
			MenuControl.notify_splash(MenuControl.Notifications.TOP_SAFETY)
			if Main.evaluate_game_over():
				return
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_SAFETY:
			Main.remove_ball()
			Main.top_score += 2
			bot_stats.safeties += 1
			MenuControl.update_score_top(Main.top_score)
			MenuControl.notify_splash(MenuControl.Notifications.BOT_SAFETY)
			if Main.evaluate_game_over():
				return
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.TOP_TB:
			Main.remove_ball()
			MenuControl.notify_splash(MenuControl.Notifications.TOP_TOUCHBACK_STRIKE)
			top_stats.touchbacks += 1
			Main.top_current_strikes += 1
			MenuControl.update_strikes_top()
			if Main.evaluate_strikes():
				return
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_TB:
			Main.remove_ball()
			MenuControl.notify_splash(MenuControl.Notifications.BOT_TOUCHBACK_STRIKE)
			bot_stats.touchbacks += 1
			Main.bot_current_strikes += 1
			MenuControl.update_strikes_bot()
			if Main.evaluate_strikes():
				return
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.TOP_OOB:
			Main.remove_ball()
			if OobMarker.position.x > 360:
				OobMarker.position.x = 450
			else:
				OobMarker.position.x = 275
			OobMarker.position.x += 20
			ball_spawn_pos = OobMarker.position
			ball_rotation = 0
			Main.add_ball(ball_spawn_pos, ball_rotation)
			MenuControl.notify_splash(MenuControl.Notifications.TOP_OOB)
			if Main.random_defender_mode:
				Main.randomize_defense()

			top_stats.turns_taken += 1
			top_stats.out_of_bounds += 1
			game_event_action(GameEvent.BOT_POSSESSION)

		GameEvent.BOT_OOB:
			Main.remove_ball()
			if OobMarker.position.x > 360:
				OobMarker.position.x = 450
			else:
				OobMarker.position.x = 275
			OobMarker.position.y -= 20
			ball_spawn_pos = OobMarker.position
			ball_rotation = 180
			Main.add_ball(ball_spawn_pos, ball_rotation)
			MenuControl.notify_splash(MenuControl.Notifications.BOT_OOB)
			if Main.random_defender_mode:
				Main.randomize_defense()

			bot_stats.turns_taken += 1
			bot_stats.out_of_bounds += 1
			game_event_action(GameEvent.TOP_POSSESSION)

		GameEvent.TOP_FG_ATTEMPT:
			Main.can_action_cam = false
			top_stats.fg_attempts += 1
			MenuControl.show_score()
			MenuControl.update_strikes_bot()
			ball_spawn_pos = TeamTop20Yd.position
			ball_rotation = -90
			Main.fg_attempt(Main.Turn.TOP)
			Main.add_ball(ball_spawn_pos, ball_rotation)
			Main.current_ball.is_field_goal_kick = true
			Main.current_ball.set_turn(Main.current_ball.Turn.TOP)
			Main.current_game_state = Main.GameState.FGATTEMPT
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.current_ball.set_turn(Main.current_ball.Turn.AI)
					Rubick.kick_fg_decide()

		GameEvent.BOT_FG_ATTEMPT:
			Main.can_action_cam = false
			bot_stats.fg_attempts += 1
			MenuControl.show_score()
			MenuControl.update_strikes_top()
			ball_spawn_pos = TeamBot20Yd.position
			ball_rotation = 90
			Main.fg_attempt(Main.Turn.BOT)
			Main.add_ball(ball_spawn_pos, ball_rotation)
			Main.current_ball.is_field_goal_kick = true
			Main.current_ball.set_turn(Main.current_ball.Turn.BOT)
			Main.current_game_state = Main.GameState.FGATTEMPT

		GameEvent.TOP_FG_SUCCESS:
			Main.remove_ball()
			Main.top_score += 3
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.update_score_top(Main.top_score)
			MenuControl.notify_splash(MenuControl.Notifications.TOP_KICK_SUCCESS)
			top_stats.fg_successes += 1
			if Main.evaluate_game_over():
				return
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_FG_SUCCESS:
			Main.remove_ball()
			Main.bot_score += 3
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.update_score_bot(Main.bot_score)
			MenuControl.notify_splash(MenuControl.Notifications.BOT_KICK_SUCCESS)
			bot_stats.fg_successes += 1
			if Main.evaluate_game_over():
				return
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.TOP_FG_FAIL:
			Main.remove_ball()
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.notify_splash(MenuControl.Notifications.TOP_KICK_FAILURE)
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_FG_FAIL:
			Main.remove_ball()
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.notify_splash(MenuControl.Notifications.BOT_KICK_FAILURE)
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.TOP_XTRAPT_ATTEMPT_1:
			Main.can_action_cam = false
			top_stats.pat_attempts += 1
			MenuControl.show_score()
			ball_spawn_pos = TeamTop20Yd.position
			ball_rotation = -90
			Main.xtra_pt_attempt_1(Main.Turn.TOP)
			Main.add_ball(ball_spawn_pos, ball_rotation)
			Main.current_ball.is_field_goal_kick = true
			Main.current_ball.set_turn(Main.current_ball.Turn.TOP)
			Main.current_game_state = Main.GameState.XTRAPT1
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.current_ball.set_turn(Main.current_ball.Turn.AI)
					Rubick.kick_pat_decide()

		GameEvent.BOT_XTRAPT_ATTEMPT_1:
			Main.can_action_cam = false
			bot_stats.pat_attempts += 1
			MenuControl.show_score()
			ball_spawn_pos = TeamBot20Yd.position
			ball_rotation = 90
			Main.xtra_pt_attempt_1(Main.Turn.BOT)
			Main.add_ball(ball_spawn_pos,ball_rotation)
			Main.current_ball.is_field_goal_kick = true
			Main.current_ball.set_turn(Main.current_ball.Turn.BOT)
			Main.current_game_state = Main.GameState.XTRAPT1

		GameEvent.TOP_XTRAPT_SUCCESS_1:
			Main.remove_ball()
			Main.top_score += 1
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.notify_splash(MenuControl.Notifications.TOP_KICK_SUCCESS)
			MenuControl.update_score_top(Main.top_score)
			top_stats.pat_successes += 1
			if Main.evaluate_game_over():
				return
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_XTRAPT_SUCCESS_1:
			Main.remove_ball()
			Main.bot_score += 1
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.update_score_bot(Main.bot_score)
			MenuControl.notify_splash(MenuControl.Notifications.BOT_KICK_SUCCESS)
			bot_stats.pat_successes += 1
			if Main.evaluate_game_over():
				return
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.TOP_XTRAPT_ATTEMPT_2:
			top_stats.two_pt_attempts += 1
			ball_spawn_pos = FiftyYdMarker.position
			ball_spawn_pos.y -= 28
			ball_rotation = 180
			Main.xtra_pt_attempt_2()
			Main.add_ball(ball_spawn_pos,ball_rotation)
			Main.current_ball.set_turn(Main.current_ball.Turn.TOP)
			Main.current_game_state = Main.GameState.XTRAPT2
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.current_ball.set_turn(Main.current_ball.Turn.AI)
					Rubick.attempt_2pt_decide()

		GameEvent.BOT_XTRAPT_ATTEMPT_2:
			bot_stats.two_pt_attempts += 1
			ball_spawn_pos = FiftyYdMarker.position
			ball_spawn_pos.y += 28
			ball_rotation = 0
			Main.xtra_pt_attempt_2()
			Main.add_ball(ball_spawn_pos,ball_rotation)
			Main.current_ball.set_turn(Main.current_ball.Turn.BOT)
			Main.current_game_state = Main.GameState.XTRAPT2

		GameEvent.TOP_XTRAPT_SUCCESS_2:
			Main.remove_ball()
			Main.top_score += 2
			MenuControl.update_score_top(Main.top_score)
			MenuControl.notify_splash(MenuControl.Notifications.TOP_2PT_SUCCESS)
			top_stats.two_pt_successes += 1
			if Main.evaluate_game_over():
				return
			Main.show_td_hide_extra()
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_XTRAPT_SUCCESS_2:
			Main.remove_ball()
			Main.bot_score += 2
			MenuControl.update_score_bot(Main.bot_score)
			MenuControl.notify_splash(MenuControl.Notifications.BOT_2PT_SUCCESS)
			bot_stats.two_pt_successes += 1
			if Main.evaluate_game_over():
				return
			Main.show_td_hide_extra()
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.TOP_XTRAPT_FAIL_1:
			Main.remove_ball()
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.notify_splash(MenuControl.Notifications.TOP_KICK_FAILURE)
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_XTRAPT_FAIL_1:
			Main.remove_ball()
			Main.field_goal.queue_free()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.notify_splash(MenuControl.Notifications.BOT_KICK_FAILURE)
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.TOP_XTRAPT_FAIL_2:
			Main.remove_ball()
			Main.show_td_hide_extra()
			MenuControl.notify_splash(MenuControl.Notifications.TOP_KICK_FAILURE)
			ThemeControl.apply_gamefield()
			game_event_action(GameEvent.BOT_KICKOFF)

		GameEvent.BOT_XTRAPT_FAIL_2:
			Main.remove_ball()
			Main.show_td_hide_extra()
			ThemeControl.apply_gamefield()
			MenuControl.notify_splash(MenuControl.Notifications.BOT_KICK_FAILURE)
			game_event_action(GameEvent.TOP_KICKOFF)

		GameEvent.PRACTICE_START:
			MenuControl.practice_stats_show()
			ball_spawn_pos = TeamBot20Yd.position
			ball_rotation = 0
			Main.add_ball(ball_spawn_pos,ball_rotation)
			Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)

		GameEvent.PRACTICE_TURN:
			Main.remove_ball()
			var practicePosition = PracticeControl.randomize_practice_spawn()
			ball_spawn_pos = practicePosition[0]
			ball_rotation = practicePosition[1]
			Main.add_ball(ball_spawn_pos,ball_rotation)
			Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)

		GameEvent.TWO_MINUTE_DRILL_START:
			ChallengeControl.current_challenge_type = ChallengeControl.ChallengeType.TWO_MINUTE_DRILL
			ChallengeControl.start_two_minute_drill()

		GameEvent.TWO_MINUTE_DRILL_UPDATE:
			randomize()
			Main.remove_ball()
			ChallengeControl.update_two_minute_drill()

		GameEvent.SHRED_THE_DEFENSE_START:
			ChallengeControl.current_challenge_type = ChallengeControl.ChallengeType.SHRED_THE_DEFENSE
			ChallengeControl.start_shred_the_defense()

		GameEvent.SHRED_THE_DEFENSE_UPDATE:
			randomize()
			ChallengeControl.update_shred_the_defense()

		GameEvent.FIELD_GOAL_FRENZY_START:
			ChallengeControl.current_challenge_type = ChallengeControl.ChallengeType.FGF
			ChallengeControl.start_field_goal_frenzy()

		GameEvent.FIELD_GOAL_FRENZY_UPDATE:
			randomize()
			Main.remove_ball()
			ChallengeControl.update_field_goal_frenzy()
