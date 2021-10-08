# 2020 Pixel Push Football - Brandon Thacker 

extends Node

signal start_button_2P
signal start_button_AI
signal start_button_practice
signal start_button_tournament
signal start_button_challenge
signal start_two_minute
signal show_two_minute
signal start_action_beat_the_defense
signal show_shred_the_defense
signal start_fgf
signal show_fgf


onready var Main = get_tree().get_root().get_node("Main")
onready var GameCamera = Main.get_node("GameCamera")
onready var MenuControl = Main.get_node("MenuControl")
onready var MenuSelectSound = get_parent().get_node("MenuSelectSound")
onready var HowToPlay = get_parent().get_node("PlayMenu/HowToPlayButton")
onready var HowToPlayInfo = HowToPlay.get_node("HowToPlayInfo")
onready var HowToPlayBack = HowToPlay.get_node("HowToPlayBack")
onready var ThemeControl = Main.get_node("ThemeControl")
onready var AndroidIAPControl = Main.get_node("AndroidIAPControl")
onready var StatControl = Main.get_node("StatControl")
onready var ChallengeControl = Main.get_node("ChallengeControl")
onready var BlockInput = Main.get_node("MenuLayer/BlockInput/BlockInput")
onready var MainMusic = Main.get_node("MenuLayer/PlayMenu/TitleMusic")




# beat the defense specific
func _on_start__beat_the_defense_challenge_pressed():
	emit_signal("start_action_beat_the_defense")
	MenuSelectSound.play()


func _on_restart_beat_the_defense_challenge_pressed():
	emit_signal("start_action_beat_the_defense")
	MenuSelectSound.play()


func _on_beat_the_defense_return_to_main_pressed():
	get_tree().reload_current_scene()
	MenuSelectSound.play()


func _on_ShredTheDefenseShowLeaderboard_pressed():
	GPGS.show_leaderboard(GPGS.shred_the_defense_leaderboard)
	MenuSelectSound.play()

# GPGS specific
func _on_GPGSSubmit_pressed():
	match ChallengeControl.current_challenge_type:
		ChallengeControl.ChallengeType.FGF:
			GPGS.gpgs_submit_leaderboard_score(GPGS.fgf_leaderboard, int(StatControl.challenge_stats.fgf_score))
			GPGS.show_leaderboard(GPGS.fgf_leaderboard)
		ChallengeControl.ChallengeType.SHRED_THE_DEFENSE:
			GPGS.gpgs_submit_leaderboard_score(GPGS.shred_the_defense_leaderboard, int(StatControl.challenge_stats.shred_the_defense_score))
			GPGS.show_leaderboard(GPGS.shred_the_defense_leaderboard)
		ChallengeControl.ChallengeType.TWO_MINUTE_DRILL:
			GPGS.gpgs_submit_leaderboard_score(GPGS.two_minute_drill_leaderboard, int(StatControl.challenge_stats.two_minute_drill_score))
			GPGS.show_leaderboard(GPGS.two_minute_drill_leaderboard)


# field goal frenzy specific
func _on_start_fgf_pressed():
	emit_signal("start_fgf")
	MenuSelectSound.play()


func _on_restart_fgf_pressed():
	emit_signal("start_fgf")
	MenuSelectSound.play()


func _on_fgf_return_to_main_pressed():
	get_tree().reload_current_scene()
	MenuSelectSound.play()


func _on_FgfShowLeaderboard_pressed():
	GPGS.show_leaderboard(GPGS.fgf_leaderboard)
	MenuSelectSound.play()


# two minute drill specific
func _on_RestartChallenge_pressed():
	emit_signal("start_two_minute")
	MenuSelectSound.play()


func _on_ReturnToMain_pressed():
	get_tree().reload_current_scene()
	MenuSelectSound.play()


func _on_StartChallenge_pressed():
	emit_signal("start_two_minute")
	MenuSelectSound.play()


func _on_TwoMinuteShowLeaderboard_pressed():
	GPGS.show_leaderboard(GPGS.two_minute_drill_leaderboard)
	MenuSelectSound.play()

# title music
func _on_titleMusic_stop(object, _key):
	object.stop()


# title screen -----------------------------------
func _on_play_pressed():
	MenuControl.show_main_menu()
	MenuControl.hide_play()
	MenuSelectSound.play()


func _on_HowToPlay_pressed():
	HowToPlayInfo.show()
	HowToPlayBack.show()
	MenuSelectSound.play()

func _on_HowToPlayBack_pressed():
	HowToPlayInfo.hide()
	HowToPlayBack.hide()


func _on_unlockFull_pressed():
	MenuControl.show_unlock_full()
	MenuSelectSound.play()

func _on_Purchase_pressed():
	AndroidIAPControl.purchase_full_game()
	MenuControl.hide_unlock_full()
	MenuSelectSound.play()


func _on_Back_pressed():
	MenuControl.hide_unlock_full()
	MenuSelectSound.play()


func _on_start_2P_pressed():
	MenuControl.start_game_transition()
	emit_signal("start_button_2P")
	MenuSelectSound.play()


func _on_2_Player_Defender_pressed():
	MenuControl.start_game_transition()
	Main.random_defender_mode = true
	emit_signal("start_button_2P")
	MenuSelectSound.play()

func _on_Tournament_pressed():
	MenuControl.hide_main_menu()
	MenuControl.start_game_transition()
	Main.tournament_mode = true
	emit_signal("start_button_tournament")
	MenuSelectSound.play()


func _on_start_practice_pressed():
	MenuControl.start_game_transition()
	emit_signal("start_button_practice")
	MenuSelectSound.play()


func _on_start_AI_pressed():
	MenuControl.start_game_transition()
	emit_signal("start_button_AI")
	MenuSelectSound.play()


func _on_settings_pressed():
	MenuControl.show_settings()
	# hackery to prevent mouse inputs from passing
	MenuSelectSound.play()


func _on_close_settings_pressed():
	MenuControl.hide_settings()
	MenuSelectSound.play()


func _on_exit_game_pressed():
	pass


func _on_startChallenge_pressed():
	emit_signal("start_button_challenge")
	MenuSelectSound.play()


# challenge menu specific
func _on_two_minute_pressed():
	BlockInput.show()
	emit_signal("show_two_minute")
	MenuControl.hide_menu_background()
	MenuSelectSound.play()


func _on_beat_the_defense_pressed():
	BlockInput.show()
	emit_signal("show_shred_the_defense")
	MenuControl.hide_menu_background()
	MenuSelectSound.play()


func _on_field_goal_frenzy_pressed():
	emit_signal("show_fgf")
	MenuControl.hide_menu_background()
	MenuSelectSound.play()


func _on_back_pressed():
	get_tree().reload_current_scene()
	MenuSelectSound.play()


# we have to reset their location to begin the tween again after
func _on_notify_tween_tween_all_completed():
	MenuControl.notify_splash_reset()


func _on_google_on_pressed():
	MenuControl.GoogleOn.set_pressed(MenuControl.GoogleOn.is_pressed())


func _on_theme_standard_pressed():
	MenuControl.ThemeStandard.set_pressed(true)
	MenuControl.ThemeRetroInvader.set_pressed(false)


func _on_theme_retro_invader_pressed():
	MenuControl.ThemeStandard.set_pressed(false)
	MenuControl.ThemeRetroInvader.set_pressed(true)


func _on_retro_mode_pressed():
	MenuControl.RetroMode.set_pressed(MenuControl.RetroMode.is_pressed())


func _on_blue_check_medium_pressed():
	MenuControl.Team2CheckHeavy.set_pressed(false)
	MenuControl.Team2CheckMedium.set_pressed(true)
	MenuControl.Team2CheckLight.set_pressed(false)


func _on_blue_check_heavy_pressed():
	MenuControl.Team2CheckHeavy.set_pressed(true)
	MenuControl.Team2CheckMedium.set_pressed(false)
	MenuControl.Team2CheckLight.set_pressed(false)


func _on_blue_check_light_pressed():
	MenuControl.Team2CheckHeavy.set_pressed(false)
	MenuControl.Team2CheckMedium.set_pressed(false)
	MenuControl.Team2CheckLight.set_pressed(true)


func _on_blue_pointer_offset_pressed():
	MenuControl.Team2PointerOffset.set_pressed(MenuControl.Team2PointerOffset.is_pressed())


func _on_red_check_medium_pressed():
	MenuControl.Team1CheckHeavy.set_pressed(false)
	MenuControl.Team1CheckMedium.set_pressed(true)
	MenuControl.Team1CheckLight.set_pressed(false)


func _on_red_check_heavy_pressed():
	MenuControl.Team1CheckHeavy.set_pressed(true)
	MenuControl.Team1CheckMedium.set_pressed(false)
	MenuControl.Team1CheckLight.set_pressed(false)


func _on_red_check_light_pressed():
	MenuControl.Team1CheckHeavy.set_pressed(false)
	MenuControl.Team1CheckMedium.set_pressed(false)
	MenuControl.Team1CheckLight.set_pressed(true)


func _on_red_pointer_offset_pressed():
	MenuControl.Team1PointerOffset.set_pressed(MenuControl.Team1PointerOffset.is_pressed())



# to prevent double taps on the menu items
func _on_SettingsTween_tween_all_completed():
	BlockInput.hide()

func _on_ChallengeMenuTween_tween_all_completed():
	BlockInput.hide()


func _on_PlayMenuTween_tween_all_completed():
	BlockInput.hide()

func _on_MainMenuTween_tween_all_completed():
	BlockInput.hide()


func _on_ChallengeTwoMinuteTween_tween_all_completed():
	BlockInput.hide()


func _on_ShredTheDefenseTween_tween_all_completed():
	BlockInput.hide()


func _on_FgfTween_tween_all_completed():
	BlockInput.hide()


func _on_AudioTween_tween_all_completed():
	MainMusic.stop() # Replace with function body.

# game over

func _on_MainMenu_pressed():
	get_tree().reload_current_scene()


func _on_Rematch_pressed():
	MenuControl.start_game_transition()
	MenuControl.hide_game_over()
	MenuSelectSound.play()
	match Main.last_coin_toss_winning_player:
		1:
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.start_action_ai(Main.FirstMove.BOT)
				Main.GameType.VS_2P:
					Main.start_action_2p(Main.FirstMove.BOT)
		2:
			match Main.current_game_type:
				Main.GameType.VS_AI:
					Main.start_action_ai(Main.FirstMove.TOP)
				Main.GameType.VS_2P:
					Main.start_action_2p(Main.FirstMove.TOP)


# gameplay pause
func _on_PauseButton_pressed():
	if Main.can_pause:
		GameCamera.camera_action_move(GameCamera.CameraPosition.PAUSE)
		MenuSelectSound.play()
		Main.pause_game()


func _on_STDPause_pressed():
	if Main.can_pause:
		MenuSelectSound.play()
		Main.pause_game()


func _on_TwoMinPause_pressed():
	if Main.can_pause:
		MenuSelectSound.play()
		Main.pause_game()


func _on_FgfPause_pressed():
	if Main.can_pause:
		MenuSelectSound.play()
		Main.pause_game()


# intro camera movement
func _on_ZoomGameIntro_pressed():
	GameCamera.camera_action_move(GameCamera.CameraPosition.DEFAULT)
	Main.get_node("MenuLayer/TitleScreen/ZoomGameIntro").hide()

# practice exit
func _on_PracticeExit_pressed():
	get_tree().reload_current_scene()


func _on_PrivacyPolicy_pressed():
	OS.shell_open("https://www.bltinteractive.io/pixel_push_football/privacy_policy.html")


func _on_GameOverTween_tween_all_completed():
	MenuControl.MainMenuReturn.set_disabled(false)
	MenuControl.TournamentBracket.set_disabled(false)
	MenuControl.Rematch.set_disabled(false)


func _on_TournamentBracket_pressed():
	MenuSelectSound.play()
	MenuControl.start_game_transition()
	if Main.top_score > Main.bot_score:
		SaveSettings.BracketData["last_game_winner_score"] = Main.top_score
		SaveSettings.BracketData["last_game_loser_score"] = Main.bot_score
		SaveSettings.BracketData["last_game_winner"] = ThemeControl.top_text
	if Main.top_score < Main.bot_score:
		SaveSettings.BracketData["last_game_winner_score"] = Main.bot_score
		SaveSettings.BracketData["last_game_loser_score"] = Main.top_score
		SaveSettings.BracketData["last_game_winner"] = ThemeControl.bot_text
	Main.tournament_return()
	MenuControl.hide_game_over()
