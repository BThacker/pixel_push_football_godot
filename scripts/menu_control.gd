# Pixel Push Football - 2020 Brandon Thacker 

extends Node2D


const CrtShader = preload("res://CrtShader.tscn")

const	FORMAT_HOURS = 1 << 0
const	FORMAT_MINUTES = 1 << 1
const	FORMAT_SECONDS = 1 << 2
const	FORMAT_DEFAULT = FORMAT_HOURS | FORMAT_MINUTES | FORMAT_SECONDS
enum Notifications {
	BOT_TOUCHDOWN,
	BOT_KICK_SUCCESS,
	BOT_KICK_FAILURE,
	BOT_TOUCHBACK_STRIKE,
	BOT_2PT_SUCCESS,
	BOT_OOB,
	BOT_SAFETY,
	TOP_TOUCHDOWN,
	TOP_KICK_SUCCESS,
	TOP_KICK_FAILURE,
	TOP_TOUCHBACK_STRIKE,
	TOP_2PT_SUCCESS
	TOP_OOB,
	TOP_SAFETY
}
onready var Main = get_parent()
onready var MenuBackgroundOpt1 = preload("res://images/aap_64/main_background_pixel.png")
onready var MenuBackgroundOpt2 = preload("res://images/aap_64/main_background_pixel2.png")
onready var DropShadow = preload("res://shaders/score_back.tres")
onready var DropShadowFlipped = preload("res://shaders/score_back_flipped.tres")
# we use this to prevent double taps on the buttons
onready var BlockInput = Main.get_node("MenuLayer/BlockInput/BlockInput")
onready var MenuBorder = Main.get_node("Border/MenuBorder")
onready var StatControl = Main.get_node("StatControl")
onready var AudioTween = Main.get_node("MenuLayer/AudioTween")
onready var NotifyTween = Main.get_node("MenuLayer/NotifyTween")
onready var NotifyTweenResetBot = Main.get_node("MenuLayer/NotifyTweenResetBot")
onready var NotifyTweenResetTop = Main.get_node("MenuLayer/NotifyTweenResetTop")
onready var MainTransition = Main.get_node("MenuLayer/MainTransition/Transition/AnimationPlayer")
onready var MainTransitionGraphic = Main.get_node("MenuLayer/MainTransition/Transition")
onready var Title = Main.get_node("MenuLayer/PlayMenu/Title")
onready var Play = Main.get_node("MenuLayer/PlayMenu/PlayButton")
onready var GPGSCheck = Main.get_node("MenuLayer/PlayMenu/PlayButton/GPGSCheck")
onready var InsertCoin = Main.get_node("MenuLayer/PlayMenu/PlayMenuBackground/InsertCoin")
onready var HowToPlayInfo = Main.get_node("MenuLayer/PlayMenu/HowToPlayButton/HowToPlayInfo")
onready var HowToPlayBack = Main.get_node("MenuLayer/PlayMenu/HowToPlayButton/HowToPlayBack")
onready var HowToPlay = Main.get_node("MenuLayer/PlayMenu/HowToPlayButton")
onready var PlayMenuTween = Main.get_node("MenuLayer/PlayMenu/PlayMenuTween")
onready var UnlockFullButton = Main.get_node("MenuLayer/PlayMenu/UnlockFullButton")
onready var UnlockFullInfo = Main.get_node("MenuLayer/PlayMenu/UnlockFullButton/UnlockPopUp/Info")
onready var UnlockFullPurchase = Main.get_node("MenuLayer/PlayMenu/UnlockFullButton/UnlockPopUp/Purchase")
onready var UnlockFullBack = Main.get_node("MenuLayer/PlayMenu/UnlockFullButton/UnlockPopUp/Back")
onready var TitleMusic = Main.get_node("MenuLayer/PlayMenu/TitleMusic")
onready var PlayMenuBackground = Main.get_node("MenuLayer/PlayMenu/PlayMenuBackground")
onready var MenuBackground = Main.get_node("MenuLayer/PlayMenu/PlayMenuBackground/MenuBackground1")
onready var MenuBackground2 = Main.get_node("MenuLayer/PlayMenu/PlayMenuBackground/MenuBackground2")
onready var MainMenuTween = Main.get_node("MenuLayer/MainMenu/MainMenuTween")
onready var MainMenuBackground = Main.get_node("MenuLayer/MainMenu/MainMenuBackground")
onready var TitleScreen = Main.get_node("MenuLayer/TitleScreen")
onready var StartChallenge = Main.get_node("MenuLayer/MainMenu/StartChallenge")
onready var Start2P = Main.get_node("MenuLayer/MainMenu/Start2P")
onready var Start2PDefender = Main.get_node("MenuLayer/MainMenu/2PlayerDefender")
onready var Start2PDefenderButton = Main.get_node("MenuLayer/MainMenu/2PlayerDefender/2PlayerDefender")
onready var StartAI = Main.get_node("MenuLayer/MainMenu/StartAI")
onready var StartPractice = Main.get_node("MenuLayer/MainMenu/StartPractice")
onready var Settings = Main.get_node("MenuLayer/MainMenu/Settings")
onready var ExitGame = Main.get_node("MenuLayer/MainMenu/ExitGame")
onready var SettingsTween = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/SettingsTween")
onready var SettingsMenu = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu")
onready var Team2CheckHeavy = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/Team2CheckHeavy")
onready var Team2CheckMedium = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/Team2CheckMedium")
onready var Team2CheckLight = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/Team2CheckLight")
onready var Team2PointerOffset = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/Team2PointerOffset")
onready var Team1CheckHeavy = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/Team1CheckHeavy")
onready var Team1CheckMedium = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/Team1CheckMedium")
onready var Team1CheckLight = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/Team1CheckLight")
onready var RedPointerOffset = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/RedPointerOffset")
onready var GoogleOn = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/GoogleOn")
onready var CloseSettings = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/CloseSettings")
onready var RetroMode = Main.get_node("MenuLayer/MainMenu/SettingsCanvas/SettingsMenu/RetroMode")
onready var ChallengeMenuTween = Main.get_node("MenuLayer/ChallengeMenu/ChallengeMenuTween")
onready var ChallengeMenuBackButton = Main.get_node("MenuLayer/ChallengeMenu/Back")
onready var ChallengeMenuBackground = Main.get_node("MenuLayer/ChallengeMenu/ChallengeMenuBackground")
onready var ChallengeMenuTwoMinute = Main.get_node("MenuLayer/ChallengeMenu/TwoMinute")
onready var ChallengeMenuShredTheDefense = Main.get_node("MenuLayer/ChallengeMenu/ShredTheDefense")
onready var ChallengeMenuFgf = Main.get_node("MenuLayer/ChallengeMenu/FieldGoalFrenzy")
onready var ChallengeMenuFgfButton = Main.get_node("MenuLayer/ChallengeMenu/FieldGoalFrenzy/FieldGoalFrenzy")
onready var DirectionTween = Main.get_node("MenuLayer/DirectionTween")
onready var LeftDirection = Main.get_node("MenuLayer/LeftDirection")
onready var LeftDirectionSprite = Main.get_node("MenuLayer/LeftDirection/LeftDirection")
onready var LeftDirectionSpriteOuter = Main.get_node("MenuLayer/LeftDirection/LeftDirection/LeftDirectionOuter")
onready var RightDirection = Main.get_node("MenuLayer/RightDirection")
onready var RightDirectionSprite = Main.get_node("MenuLayer/RightDirection/RightDirection")
onready var RightDirectionSpriteOuter = Main.get_node("MenuLayer/RightDirection/RightDirection/RightDirectionOuter")
onready var ScoreTweenTop = Main.get_node("MenuLayer/TopScoreboard/ScoreTweenTop")
onready var ScoreTweenBot = Main.get_node("MenuLayer/BotScoreboard/ScoreTweenBot")
onready var TopScoreboard = Main.get_node("MenuLayer/TopScoreboard")
onready var BotScoreboard = Main.get_node("MenuLayer/BotScoreboard")
onready var BotScoreLabelTop = Main.get_node("MenuLayer/TopScoreboard/BotScoreLabelTop")
onready var BotScoreTeam1 = Main.get_node("MenuLayer/BotScoreboard/BotScoreTeam1")
onready var BotScoreTeam2 = Main.get_node("MenuLayer/BotScoreboard/BotScoreTeam2")
onready var BotScoreLabelBot = Main.get_node("MenuLayer/BotScoreboard/BotScoreLabelBot")
onready var TopScoreLabelTop = Main.get_node("MenuLayer/TopScoreboard/TopScoreLabelTop")
onready var TopScoreLabelBot = Main.get_node("MenuLayer/BotScoreboard/TopScoreLabelBot")
onready var TopScoreTeam1 = Main.get_node("MenuLayer/TopScoreboard/TopScoreTeam1")
onready var TopScoreTeam2 = Main.get_node("MenuLayer/TopScoreboard/TopScoreTeam2")
onready var BotStrikesLabel = Main.get_node("MenuLayer/BotScoreboard/BotStrikes")
onready var TopStrikesLabel = Main.get_node("MenuLayer/TopScoreboard/TopStrikes")
onready var GameStatusLabelTop = Main.get_node("MenuLayer/TopScoreboard/GameStatusLabelTop")
onready var GameStatusLabelBot = Main.get_node("MenuLayer/BotScoreboard/GameStatusLabelBot")
onready var MainMenuReturn = Main.get_node("MenuLayer/GameOver/MainMenu")
onready var GameOverTween = Main.get_node("MenuLayer/GameOver/GameOverTween")
onready var GameOverMusic = Main.get_node("MenuLayer/GameOverMusic")
onready var BotWins = Main.get_node("MenuLayer/GameOver/BotWins")
onready var BotWinsOuter = Main.get_node("MenuLayer/GameOver/BotWins/BotWinsOuter")
onready var TopWins = Main.get_node("MenuLayer/GameOver/TopWins")
onready var TopWinsOuter = Main.get_node("MenuLayer/GameOver/TopWins/TopWinsOuter")
onready var BotStats = Main.get_node("MenuLayer/GameOver/BotStats")
onready var TopStats = Main.get_node("MenuLayer/GameOver/TopStats")
onready var StatBox = Main.get_node("MenuLayer/GameOver/StatBox")
onready var PauseBack = Main.get_node("MenuLayer/PauseMenu/CanvasPause/PauseBack")
onready var ResumeButton = Main.get_node("MenuLayer/PauseMenu/CanvasPause/Resume")
onready var QuitMainMenu = Main.get_node("MenuLayer/PauseMenu/CanvasPause/QuitMainMenu")
onready var PauseSettings = Main.get_node("MenuLayer/PauseMenu/CanvasPause/PauseSettings")
onready var PracticeStats = Main.get_node("MenuLayer/Practice/PracticeStats")
onready var ChallengeControl = Main.get_node("ChallengeControl")
onready var ChallengeTwoMinute = Main.get_node("MenuLayer/ChallengeTwoMinute")
onready var ChallengeTwoMinuteTween = Main.get_node("MenuLayer/ChallengeTwoMinute/ChallengeTwoMinuteTween")
onready var ChallengeTwoMinuteTitle = Main.get_node("MenuLayer/ChallengeTwoMinute/Title")
onready var ChallengeTwoMinuteScoreboard = Main.get_node("MenuLayer/ChallengeTwoMinute/ChallengeTwoMinuteScoreboard")
onready var ChallengeTwoMinuteCurrentScore = Main.get_node("MenuLayer/ChallengeTwoMinute/CurrentScore")
onready var ChallengeTwoMinuteCurrentTime = Main.get_node("MenuLayer/ChallengeTwoMinute/CurrentTime")
onready var ChallengeTwoMinuteStart = Main.get_node("MenuLayer/ChallengeTwoMinute/StartChallenge")
onready var ChallengeTwoMinuteInfo = Main.get_node("MenuLayer/ChallengeTwoMinute/Info")
onready var ChallengeTwoMinuteRestart = Main.get_node("MenuLayer/ChallengeTwoMinute/RestartChallenge")
onready var ChallengeTwoMinuteResults = Main.get_node("MenuLayer/ChallengeTwoMinute/Results")
onready var ChallengeTwoMinuteReturnToMain = Main.get_node("MenuLayer/ChallengeTwoMinute/ReturnToMain")
onready var ChallengeTwoMinuteScoreLabel = Main.get_node("MenuLayer/ChallengeTwoMinute/ScoreLabel")
onready var ChallengeTwoMinuteShowLeaderboard = Main.get_node("MenuLayer/ChallengeTwoMinute/ShowLeaderboard")
onready var ShredTheDefenseTween = Main.get_node("MenuLayer/ShredTheDefense/ShredTheDefenseTween")
onready var ShredTheDefenseTitle = Main.get_node("MenuLayer/ShredTheDefense/Title")
onready var ShredTheDefense = Main.get_node("MenuLayer/ShredTheDefense")
onready var ShredTheDefenseScoreboard = Main.get_node("MenuLayer/ShredTheDefense/ShredTheDefenseScoreboard")
onready var ShredTheDefenseCurrentScore = Main.get_node("MenuLayer/ShredTheDefense/CurrentScore")
onready var ShredTheDefenseCurrentDown = Main.get_node("MenuLayer/ShredTheDefense/CurrentDown")
onready var ShredTheDefenseStart = Main.get_node("MenuLayer/ShredTheDefense/StartChallenge")
onready var ShredTheDefenseInfo = Main.get_node("MenuLayer/ShredTheDefense/Info")
onready var ShredTheDefenseRestart = Main.get_node("MenuLayer/ShredTheDefense/RestartChallenge")
onready var ShredTheDefenseResults = Main.get_node("MenuLayer/ShredTheDefense/Results")
onready var ShredTheDefenseReturnToMain = Main.get_node("MenuLayer/ShredTheDefense/ReturnToMain")
onready var ShredTheDefenseScoreLabel = Main.get_node("MenuLayer/ShredTheDefense/ScoreLabel")
onready var ShredTheDefensePlayClock = Main.get_node("MenuLayer/ShredTheDefense/PlayClock")
onready var ShredTheDefenseShowLeaderboard = Main.get_node("MenuLayer/ShredTheDefense/ShowLeaderboard")
onready var GPGSSubmit = Main.get_node("MenuLayer/GPGSSubmit")
onready var Fgf = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy")
onready var FgfTween = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/FgfTween")
onready var FgfTitle = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/Title")
onready var FgfScoreboard = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/FgfScoreboard")
onready var FgfCurrentScore = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/CurrentScore")
onready var FgfScoreLabel = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/ScoreLabel")
onready var FgfInfo = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/Info")
onready var FgfStart = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/StartFgf")
onready var FgfRestart = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/RestartFgf")
onready var FgfReturntoMain = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/FgfReturnToMain")
onready var FgfResults = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/FgfResults")
onready var FgfShowLeaderboard = Main.get_node("MenuLayer/ChallengeFieldGoalFrenzy/ShowLeaderboard")
onready var StartGameTransition = Main.get_node("MenuLayer/StartGameTransition")
onready var StartGameTransitionAnimate = Main.get_node("MenuLayer/StartGameTransition/StartGameTransition/AnimationPlayer")
onready var TopNotifySprite = Main.get_node("MenuLayer/TopNotify/NotifySprite")
onready var TopNotifySpriteOuter = Main.get_node("MenuLayer/TopNotify/NotifySprite/NotifySpriteOuter")
onready var BotNotifySprite = Main.get_node("MenuLayer/BotNotify/NotifySprite")
onready var BotNotifySpriteOuter = Main.get_node("MenuLayer/BotNotify/NotifySprite/NotifySpriteOuter")
onready var RefCam = Main.get_node("MenuLayer/RefCam")
onready var RefCamTween = Main.get_node("MenuLayer/RefCam/RefCamTween")
onready var RefCamMain = Main.get_node("MenuLayer/RefCam/RefCam")
onready var RefCamGood = Main.get_node("MenuLayer/RefCam/RefCam/RefCamGood")
onready var RefCamBad = Main.get_node("MenuLayer/RefCam/RefCam/RefCamBad")
onready var RefAnimation = Main.get_node("MenuLayer/RefCam/RefAnimation")
onready var ThemeControl = Main.get_node("ThemeControl")

var notification_reset_bot
var notification_reset_top
var menu_movement = -0.5
var current_crt_shader
var is_ref_alive = false
# audio
var Transition_duration = 3
var Transition_type = 1 # TRANS_SINE



func _ready():
	randomize()
	var _fifty_fifty = int(rand_range(1,3))
	print(_fifty_fifty)
	match _fifty_fifty:
		1:
			MenuBackground.set_texture(MenuBackgroundOpt1)
			MenuBackground2.set_texture(MenuBackgroundOpt1)
			print("set option 1")
			print(MenuBackground.get_texture())
		2:
			MenuBackground.set_texture(MenuBackgroundOpt2)
			MenuBackground2.set_texture(MenuBackgroundOpt2)
			print("set option 2")
			print(MenuBackground.get_texture())



func _process(_delta):
	if MenuBackground.is_visible():
		if MenuBackground.position.y <= -1770:
			MenuBackground.position.y = 2360
		if MenuBackground2.position.y <= -1770:
			MenuBackground2.position.y = 2360
	MenuBackground.position.y += menu_movement
	MenuBackground2.position.y += menu_movement

func show_play():
	BlockInput.show()
	var Title_start = Title.position
	var Title_end = Vector2(-10,430)
	var play_start = Play.position
	var play_end = Vector2(0,0)
	var how_to_play_start = HowToPlay.position
	var how_to_play_end = Vector2(0, 0)
	var unlock_full_start = UnlockFullButton.position
	var unlock_full_end = Vector2(0, 0)
	match SaveSettings.pixel_push_save_data["is_google_play"]:
		true:
			GPGSCheck.set_pressed(true)
		false:
			GPGSCheck.set_pressed(false)
	Main.player_can_control = false
	Main.can_pause = false
	Main.current_game_type = Main.GameType.NONE
	HowToPlay.show()
	UnlockFullButton.show()
	Title.show()
	Play.show()
	MenuBackground.show()
	MenuBackground2.show()
	 #Make instance
	var local_crt = CrtShader.instance()
	current_crt_shader = local_crt
	PlayMenuBackground.add_child(local_crt)
	local_crt.start()
	MainTransition.play("transition_title")
	MainTransitionGraphic.show()
	TitleMusic.play()
	PlayMenuTween.interpolate_property(Title, "position", Title_start, Title_end, 2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	PlayMenuTween.interpolate_property(HowToPlay, "position", how_to_play_start, how_to_play_end, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	PlayMenuTween.interpolate_property(Play, "position", play_start, play_end, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	PlayMenuTween.interpolate_property(UnlockFullButton, "position", unlock_full_start, unlock_full_end, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	PlayMenuTween.start()


func hide_play():
	BlockInput.show()
	var Title_start = Title.position
	var Title_end = Vector2(-1080, 430)
	var play_start = Play.position
	var play_end = Vector2(-1080,0)
	var unlock_full_start = UnlockFullButton.position
	var unlock_full_end = Vector2(-1080, 0)
	var how_to_play_start = HowToPlay.position
	var how_to_play_end = Vector2(-1080, 0)
	PlayMenuTween.interpolate_property(Title, "position", Title_start, Title_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	PlayMenuTween.interpolate_property(Play, "position", play_start, play_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	PlayMenuTween.interpolate_property(UnlockFullButton, "position", unlock_full_start, unlock_full_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	PlayMenuTween.interpolate_property(HowToPlay, "position", how_to_play_start, how_to_play_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	PlayMenuTween.start()


func hide_menu_background():
	InsertCoin.hide()
	MenuBackground.hide()
	MenuBackground2.hide()
	MenuBorder.hide()
	if PlayMenuBackground.has_node("CrtShader"):
		PlayMenuBackground.remove_child(current_crt_shader)
		current_crt_shader.end()
	#TitleCrtShader.hide()
	if TitleMusic.is_playing():
		fade_out(TitleMusic)
	TitleScreen.hide()


func start_game_transition():
	StartGameTransition.show()
	StartGameTransitionAnimate.play("start_game_animation")


func show_main_menu():
	BlockInput.show()
	# once the play menu is selected, we need to check the status of the GPGS button
	match GPGSCheck.is_pressed():
		true:
			GPGS.gpgs_sign_in()
			SaveSettings.pixel_push_save_data["is_google_play"] = true
		false:
			GPGS.gpgs_sign_out()
			SaveSettings.pixel_push_save_data["is_google_play"] = false
	SaveSettings.close_settings_save()

	hide_play()
	# all positions are relative to the parent node in this case for Main menu
	match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
		true: Start2PDefenderButton.set_disabled(false)
		false: Start2PDefenderButton.set_disabled(true)
	var main_menu_back_start = MainMenuBackground.position
	var main_menu_back_end = Vector2(0, 640)
	var start_2P_start = Start2P.position
	var start_2P_end = Vector2(0,0)
	var start_2P_defender_start = Start2PDefender.position
	var start_2P_defender_end = Vector2(0,0)
	var start_ai_start = StartAI.position
	var start_ai_end = Vector2(0, 0)
	var start_practice_start = StartPractice.position
	var start_practice_end = Vector2(0, 0)
	var start_challenge_start = StartChallenge.position
	var start_challenge_end = Vector2(0, 0)
	var settings_start = Settings.position
	var settings_end = Vector2(0, 0)
	MainMenuTween.interpolate_property(MainMenuBackground, "position", main_menu_back_start, main_menu_back_end, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	MainMenuTween.interpolate_property(Start2P, "position", start_2P_start, start_2P_end, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	MainMenuTween.interpolate_property(Start2PDefender, "position", start_2P_defender_start, start_2P_defender_end, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	MainMenuTween.interpolate_property(StartAI, "position", start_ai_start, start_ai_end, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	MainMenuTween.interpolate_property(StartPractice, "position", start_practice_start, start_practice_end, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	MainMenuTween.interpolate_property(StartChallenge, "position", start_challenge_start, start_challenge_end, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	MainMenuTween.interpolate_property(Settings, "position", settings_start, settings_end, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	MainMenuTween.start()

func show_unlock_full():
	UnlockFullInfo.show()
	UnlockFullPurchase.show()
	UnlockFullBack.show()

func hide_unlock_full():
	UnlockFullInfo.hide()
	UnlockFullPurchase.hide()
	UnlockFullBack.hide()

func hide_main_menu():
	BlockInput.show()
	var main_menu_back_start = MainMenuBackground.position
	var main_menu_back_end = Vector2(-1600, 640)
	var start_2P_start = Start2P.position
	var start_2P_end = Vector2(-1080,0)
	var start_2P_defender_start = Start2PDefender.position
	var start_2P_defender_end = Vector2(-1080,0)
	var start_ai_start = StartAI.position
	var start_ai_end = Vector2(-1080, 0)
	var start_practice_start = StartPractice.position
	var start_practice_end = Vector2(-1080, 0)
	var start_challenge_start = StartChallenge.position
	var start_challenge_end = Vector2(-1080, 0)
	var settings_start = Settings.position
	var settings_end = Vector2(-1080, 0)
	MainMenuTween.interpolate_property(MainMenuBackground, "position", main_menu_back_start, main_menu_back_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	MainMenuTween.interpolate_property(Start2P, "position", start_2P_start, start_2P_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	MainMenuTween.interpolate_property(Start2PDefender, "position", start_2P_defender_start, start_2P_defender_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	MainMenuTween.interpolate_property(StartAI, "position", start_ai_start, start_ai_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	MainMenuTween.interpolate_property(StartPractice, "position", start_practice_start, start_practice_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	MainMenuTween.interpolate_property(StartChallenge, "position", start_challenge_start, start_challenge_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	MainMenuTween.interpolate_property(Settings, "position", settings_start, settings_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	MainMenuTween.start()


func show_settings():
		BlockInput.show()
		# all positions are relative to the parent node in this case for Main menu
		SettingsMenu.show()
		var settings_start = SettingsMenu.position
		var settings_end = Vector2(0,0)
		SettingsMenu.show()
		match SaveSettings.pixel_push_save_data["is_google_play"]:
			true: GoogleOn.set_pressed(true)
			false: GoogleOn.set_pressed(false)
		match SaveSettings.pixel_push_save_data["blue_touch_force"]:
			3:
				Team2CheckHeavy.set_pressed(true)
				Team2CheckMedium.set_pressed(false)
				Team2CheckLight.set_pressed(false)
			2:
				Team2CheckHeavy.set_pressed(false)
				Team2CheckMedium.set_pressed(true)
				Team2CheckLight.set_pressed(false)
			1:
				Team2CheckHeavy.set_pressed(false)
				Team2CheckMedium.set_pressed(false)
				Team2CheckLight.set_pressed(true)
		match SaveSettings.pixel_push_save_data["is_blue_pointer_offset"]:
			true: Team2PointerOffset.set_pressed(true)
			false: Team2PointerOffset.set_pressed(false)
		match SaveSettings.pixel_push_save_data["red_touch_force"]:
			3:
				Team1CheckHeavy.set_pressed(true)
				Team1CheckMedium.set_pressed(false)
				Team1CheckLight.set_pressed(false)
			2:
				Team1CheckHeavy.set_pressed(false)
				Team1CheckMedium.set_pressed(true)
				Team1CheckLight.set_pressed(false)
			1:
				Team1CheckHeavy.set_pressed(false)
				Team1CheckMedium.set_pressed(false)
				Team1CheckLight.set_pressed(true)
		match SaveSettings.pixel_push_save_data["is_red_pointer_offset"]:
			true: RedPointerOffset.set_pressed(true)
			false: RedPointerOffset.set_pressed(false)
		# checking for full game unlocked
		match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
			true:
				match SaveSettings.pixel_push_save_data["is_retro_mode"]:
					true: RetroMode.set_pressed(true)
					false: RetroMode.set_pressed(false)
			false:
				RetroMode.set_pressed(false)
				RetroMode.set_disabled(true)
		SettingsTween.interpolate_property(SettingsMenu, "position", settings_start, settings_end, .5, Tween.TRANS_BACK, Tween.EASE_OUT)
		SettingsTween.start()


func hide_settings():
		BlockInput.show()
		get_and_save_settings()
		Main.apply_retro_mode()
		SaveSettings.close_settings_save()
		var settings_start = SettingsMenu.position
		var settings_end = Vector2(0,-2285)
		SettingsTween.interpolate_property(SettingsMenu, "position", settings_start, settings_end, .5, Tween.TRANS_BACK, Tween.EASE_IN)
		SettingsTween.start()


func get_and_save_settings():
	if Team2CheckHeavy.is_pressed(): SaveSettings.pixel_push_save_data["blue_touch_force"] = 3
	if Team2CheckMedium.is_pressed(): SaveSettings.pixel_push_save_data["blue_touch_force"] = 2
	if Team2CheckLight.is_pressed(): SaveSettings.pixel_push_save_data["blue_touch_force"] = 1
	match Team2PointerOffset.is_pressed():
		true: SaveSettings.pixel_push_save_data["is_blue_pointer_offset"] = true
		false: SaveSettings.pixel_push_save_data["is_blue_pointer_offset"] = false
	if Team1CheckHeavy.is_pressed(): SaveSettings.pixel_push_save_data["red_touch_force"] = 3
	if Team1CheckMedium.is_pressed(): SaveSettings.pixel_push_save_data["red_touch_force"] = 2
	if Team1CheckLight.is_pressed(): SaveSettings.pixel_push_save_data["red_touch_force"] = 1
	match RedPointerOffset.is_pressed():
		true: SaveSettings.pixel_push_save_data["is_red_pointer_offset"] = true
		false: SaveSettings.pixel_push_save_data["is_red_pointer_offset"] = false
	if RetroMode.is_pressed():
		SaveSettings.pixel_push_save_data["is_retro_mode"] = true
	if !RetroMode.is_pressed():
		SaveSettings.pixel_push_save_data["is_retro_mode"] = false
	match GoogleOn.is_pressed():
		true:
			GPGS.gpgs_sign_in()
			SaveSettings.pixel_push_save_data["is_google_play"] = true
		false:
			GPGS.gpgs_sign_out()
			SaveSettings.pixel_push_save_data["is_google_play"] = false


func show_challenge_list():
	BlockInput.show()
	match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
		true: ChallengeMenuFgfButton.set_disabled(false)
		false: ChallengeMenuFgfButton.set_disabled(true)
	var challenge_menu_back_start = ChallengeMenuBackground.position
	var challenge_menu_back_end = Vector2(0, 640)
	var challenge_menu_two_minute_start = ChallengeMenuTwoMinute.position
	var challenge_menu_two_minute_end = Vector2(-0,0)
	var challenge_menu_shred_the_defense_start = ChallengeMenuShredTheDefense.position
	var challenge_menu_shred_the_defense_send = Vector2(-0,0)
	var challenge_back_button_start = ChallengeMenuBackButton.position
	var challenge_back_button_end = Vector2(0,0)
	var challenge_menu_fgf_start = ChallengeMenuFgf.position
	var challenge_menu_fgf_end = Vector2(0,0)
	ChallengeMenuTween.interpolate_property(ChallengeMenuBackground, "position", challenge_menu_back_start, challenge_menu_back_end, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	ChallengeMenuTween.interpolate_property(ChallengeMenuShredTheDefense, "position", challenge_menu_shred_the_defense_start, challenge_menu_shred_the_defense_send, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	ChallengeMenuTween.interpolate_property(ChallengeMenuTwoMinute, "position", challenge_menu_two_minute_start, challenge_menu_two_minute_end, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	ChallengeMenuTween.interpolate_property(ChallengeMenuFgf, "position", challenge_menu_fgf_start, challenge_menu_fgf_end, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	ChallengeMenuTween.interpolate_property(ChallengeMenuBackButton, "position", challenge_back_button_start, challenge_back_button_end, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	ChallengeMenuTween.start()


func hide_challenge_list():
	BlockInput.show()
	var challenge_menu_back_start = ChallengeMenuBackground.position
	var challenge_menu_back_end = Vector2(-1600, 640)
	var challenge_menu_two_minute_start = ChallengeMenuTwoMinute.position
	var challenge_menu_two_minute_end = Vector2(-1600,0)
	var challenge_menu_shred_the_defense_start = ChallengeMenuShredTheDefense.position
	var challenge_menu_shred_the_defense_send = Vector2(-1600,0)
	var challenge_back_button_start = ChallengeMenuBackButton.position
	var challenge_back_button_end = Vector2(-1600,0)
	var challenge_menu_fgf_start = ChallengeMenuFgf.position
	var challenge_menh_fgf_end = Vector2(-1600,0)
	ChallengeMenuTween.interpolate_property(ChallengeMenuBackground, "position", challenge_menu_back_start, challenge_menu_back_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	ChallengeMenuTween.interpolate_property(ChallengeMenuShredTheDefense, "position", challenge_menu_shred_the_defense_start, challenge_menu_shred_the_defense_send, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	ChallengeMenuTween.interpolate_property(ChallengeMenuTwoMinute, "position", challenge_menu_two_minute_start, challenge_menu_two_minute_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	ChallengeMenuTween.interpolate_property(ChallengeMenuBackButton, "position", challenge_back_button_start, challenge_back_button_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	ChallengeMenuTween.interpolate_property(ChallengeMenuFgf, "position", challenge_menu_fgf_start, challenge_menh_fgf_end, .25, Tween.TRANS_BACK, Tween.EASE_IN)
	ChallengeMenuTween.start()

# this is a hard coded mess
# but I am sick of this menu system
# so you get what you get
# todo // optimize this mess
func show_game_over(winning_player):
	match winning_player:
		1:
			BotWins.show()
			var _mmr_style = StyleBoxFlat.new()
			_mmr_style.set_bg_color(ThemeControl.bot_color_code)
			_mmr_style.set_border_color(ThemeControl.bot_color_code_dark)
			_mmr_style.set_border_width_all(12)
			MainMenuReturn.set("custom_styles/normal", _mmr_style)
			match ThemeControl.bot_text:
				"RED":
					BotWins.set_texture(ThemeControl.RED_WINS_INNER)
					BotWinsOuter.set_texture(ThemeControl.RED_WINS_OUTER)
					BotWins.modulate = ThemeControl.bot_color_code
				"BLUE":
					BotWins.set_texture(ThemeControl.BLUE_WINS_INNER)
					BotWinsOuter.set_texture(ThemeControl.BLUE_WINS_OUTER)
					BotWins.modulate = ThemeControl.bot_color_code
				"GREEN":
					BotWins.set_texture(ThemeControl.GREEN_WINS_INNER)
					BotWinsOuter.set_texture(ThemeControl.GREEN_WINS_OUTER)
					BotWins.modulate = ThemeControl.bot_color_code
				"PURPLE":
					BotWins.set_texture(ThemeControl.PURPLE_WINS_INNER)
					BotWinsOuter.set_texture(ThemeControl.PURPLE_WINS_OUTER)
					BotWins.modulate = ThemeControl.bot_color_code
				"YELLOW":
					BotWins.set_texture(ThemeControl.YELLOW_WINS_INNER)
					BotWinsOuter.set_texture(ThemeControl.YELLOW_WINS_OUTER)
					BotWins.modulate = ThemeControl.bot_color_code
				"PINK":
					BotWins.set_texture(ThemeControl.PINK_WINS_INNER)
					BotWinsOuter.set_texture(ThemeControl.PINK_WINS_OUTER)
					BotWins.modulate = ThemeControl.bot_color_code
		2:
			TopWins.show()
			var _mmr_style = StyleBoxFlat.new()
			_mmr_style.set_bg_color(ThemeControl.top_color_code)
			_mmr_style.set_border_color(ThemeControl.top_color_code_dark)
			_mmr_style.set_border_width_all(12)
			MainMenuReturn.set("custom_styles/normal", _mmr_style)
			match ThemeControl.top_text:
				"RED":
					TopWins.set_texture(ThemeControl.RED_WINS_INNER)
					TopWinsOuter.set_texture(ThemeControl.RED_WINS_OUTER)
					TopWins.modulate = ThemeControl.top_color_code
				"BLUE":
					TopWins.set_texture(ThemeControl.BLUE_WINS_INNER)
					TopWinsOuter.set_texture(ThemeControl.BLUE_WINS_OUTER)
					TopWins.modulate = ThemeControl.top_color_code
				"GREEN":
					TopWins.set_texture(ThemeControl.GREEN_WINS_INNER)
					TopWinsOuter.set_texture(ThemeControl.GREEN_WINS_OUTER)
					TopWins.modulate = ThemeControl.top_color_code
				"PURPLE":
					TopWins.set_texture(ThemeControl.PURPLE_WINS_INNER)
					TopWinsOuter.set_texture(ThemeControl.PURPLE_WINS_OUTER)
					TopWins.modulate = ThemeControl.top_color_code
				"YELLOW":
					TopWins.set_texture(ThemeControl.YELLOW_WINS_INNER)
					TopWinsOuter.set_texture(ThemeControl.YELLOW_WINS_OUTER)
					TopWins.modulate = ThemeControl.top_color_code
				"PINK":
					TopWins.set_texture(ThemeControl.PINK_WINS_INNER)
					TopWinsOuter.set_texture(ThemeControl.PINK_WINS_OUTER)
					TopWins.modulate = ThemeControl.top_color_code
	fade_in(GameOverMusic)
	GameOverMusic.play()
	TopScoreboard.hide()
	BotScoreboard.hide()
	Main.remove_ball()
	MainMenuReturn.show()
	StatControl.update_stats()
	BotStats.add_color_override("font_color", ThemeControl.bot_color_code)
	BotStats.show()
	BotStats.text = StatControl.eog_stats_bot()
	TopStats.add_color_override("font_color", ThemeControl.top_color_code)
	TopStats.show()
	TopStats.text = StatControl.eog_stats_top()

	StatBox.show()
	Main.can_pause = false

	var bot_wins_start = BotWins.position
	var bot_wins_end = Vector2(360, 170)
	var top_wins_start = TopWins.position
	var top_wins_end = Vector2(360, 170)
	var main_menu_return_start = MainMenuReturn.rect_position
	var main_menu_return_end = Vector2(160,980)
	var top_stats_start = TopStats.rect_position
	var top_stats_end = Vector2(619,260)
	var bot_stats_start = BotStats.rect_position
	var bot_stats_end = Vector2(529,260)
	var stat_box_start = StatBox.rect_position
	var stat_box_end = Vector2(25,260)

	GameOverTween.interpolate_property(BotWins, "position", bot_wins_start, bot_wins_end, 2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	GameOverTween.interpolate_property(TopWins, "position", top_wins_start, top_wins_end, 2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	GameOverTween.interpolate_property(MainMenuReturn, "rect_position", main_menu_return_start, main_menu_return_end, 2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	GameOverTween.interpolate_property(TopStats, "rect_position", top_stats_start, top_stats_end, 2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	GameOverTween.interpolate_property(BotStats, "rect_position", bot_stats_start, bot_stats_end, 2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	GameOverTween.interpolate_property(StatBox, "rect_position", stat_box_start, stat_box_end, 2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	GameOverTween.start()
# not necessary, we have no way of backing out of the game without reloading the scene

func hide_game_over():
	MainMenuReturn.hide()
	BotStats.hide()
	TopStats.hide()
	StatBox.hide()


func show_score():
	TopScoreboard.show()
	BotScoreboard.show()
	var top_start = TopScoreboard.position
	var bot_start = BotScoreboard.position
	var top_end = Vector2(360, 10)
	var bot_end = Vector2(360,1270)
	ScoreTweenTop.interpolate_property(TopScoreboard, "position", top_start, top_end, 0.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	ScoreTweenTop.interpolate_property(BotScoreboard, "position", bot_start, bot_end, 0.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	ScoreTweenTop.start()
	ScoreTweenBot.start()


func hide_score():
	var top_start = TopScoreboard.position
	var bot_start = BotScoreboard.position
	var top_end = Vector2(360, -480)
	var bot_end = Vector2(360,1760)
	ScoreTweenTop.interpolate_property(TopScoreboard, "position", top_start, top_end, 0.8, Tween.TRANS_EXPO, Tween.EASE_IN)
	ScoreTweenTop.interpolate_property(BotScoreboard, "position", bot_start, bot_end, 0.8, Tween.TRANS_EXPO, Tween.EASE_IN)
	ScoreTweenTop.start()
	ScoreTweenBot.start()


func fade_score(direction):
	match direction:
		1:
			TopScoreboard.modulate = Color(1, 1, 1, 1)
			BotScoreboard.modulate = Color(1, 1, 1, 1)
		2:
			BotScoreboard.modulate = Color(1, 1, 1, 0.5)
			TopScoreboard.modulate = Color(1, 1, 1, 0.5)


func show_pause():
	PauseBack.show()
	ResumeButton.show()
	QuitMainMenu.show()
	PauseSettings.show()


func hide_pause():
	PauseBack.hide()
	ResumeButton.hide()
	QuitMainMenu.hide()
	PauseSettings.hide()



# variable names arent consistent
# read closely to figure out what needs updating
# TODO
func update_score_top(score):
	TopScoreLabelTop.text = str(score)
	TopScoreLabelBot.text = str(score)
	TopScoreTeam1.text = ThemeControl.bot_text
	BotScoreTeam1.text = ThemeControl.bot_text
	TopScoreTeam1.add_color_override("font_color", ThemeControl.bot_color_code)
	BotScoreTeam1.add_color_override("font_color", ThemeControl.bot_color_code)


func update_score_bot(score):
	BotScoreLabelTop.text = str(score)
	BotScoreLabelBot.text = str(score)
	TopScoreTeam2.text = ThemeControl.top_text
	BotScoreTeam2.text = ThemeControl.top_text
	TopScoreTeam2.add_color_override("font_color", ThemeControl.top_color_code)
	BotScoreTeam2.add_color_override("font_color", ThemeControl.top_color_code)




func show_how_to_play():
	HowToPlayInfo.show()
	HowToPlayBack.show()


func hide_how_to_play():
	HowToPlayInfo.hide()
	HowToPlayBack.hide()


func practice_stats_show():
	PracticeStats.show()
	PracticeStats.text = "PRACTICE MODE\nLast Distance (yards):\nLast Result:"


func update_strikes_bot():
	match Main.bot_current_strikes:
		0: BotStrikesLabel.text = ""
		1: BotStrikesLabel.text = "X"
		2: BotStrikesLabel.text = "XX"
		3: BotStrikesLabel.text = "XXX"


func update_strikes_top():
	match Main.top_current_strikes:
		0: TopStrikesLabel.text = ""
		1: TopStrikesLabel.text = "X"
		2: TopStrikesLabel.text = "XX"
		3: TopStrikesLabel.text = "XXX"

func practice_stats_update(lastResult, last_distance_moved):
	var format_string = "PRACTICE MODE\nLast distance (yards): %s\nLast Result: %s"
	var practiceString = format_string % [last_distance_moved, lastResult]
	PracticeStats.text = practiceString


func notify_splash(notification):
	var _bot_start = Vector2(-600, 980)
	var _top_start = Vector2(-1320, -300)
	var _bot_end = Vector2(360, 980)
	var _top_end = Vector2(-360, -300)
	match notification:
		Notifications.BOT_TOUCHDOWN:
			TopNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_TD)
			TopNotifySprite.modulate = ThemeControl.bot_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_TD_OUTER)
			BotNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_TD)
			BotNotifySprite.modulate = ThemeControl.bot_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_TD_OUTER)
		Notifications.BOT_KICK_SUCCESS:
			TopNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_KICK_SUCCESS)
			TopNotifySprite.modulate = ThemeControl.bot_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_KICK_SUCCESS_OUTER)
			BotNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_KICK_SUCCESS)
			BotNotifySprite.modulate = ThemeControl.bot_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_KICK_SUCCESS_OUTER)
		Notifications.BOT_KICK_FAILURE :
			TopNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_KICK_FAILURE)
			TopNotifySprite.modulate = ThemeControl.bot_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_KICK_FAILURE_OUTER)
			BotNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_KICK_FAILURE)
			BotNotifySprite.modulate = ThemeControl.bot_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_KICK_FAILURE_OUTER)
		Notifications.BOT_TOUCHBACK_STRIKE:
			TopNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_TOUCHBACK_STRIKE)
			TopNotifySprite.modulate = ThemeControl.bot_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_TOUCHBACK_STRIKE_OUTER)
			BotNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_TOUCHBACK_STRIKE)
			BotNotifySprite.modulate = ThemeControl.bot_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_TOUCHBACK_STRIKE_OUTER)
		Notifications.BOT_2PT_SUCCESS:
			TopNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_2PT_SUCCESS)
			TopNotifySprite.modulate = ThemeControl.bot_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_2PT_SUCCESS_OUTER)
			BotNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_2PT_SUCCESS)
			BotNotifySprite.modulate = ThemeControl.bot_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_2PT_SUCCESS_OUTER)
		Notifications.BOT_OOB:
			TopNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_OOB)
			TopNotifySprite.modulate = ThemeControl.bot_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_OOB_OUTER)
			BotNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_OOB)
			BotNotifySprite.modulate = ThemeControl.bot_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_OOB_OUTER)
		Notifications.BOT_SAFETY:
			TopNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_SAFETY)
			TopNotifySprite.modulate = ThemeControl.bot_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_SAFETY_OUTER)
			BotNotifySprite.set_texture(ThemeControl.BOT_NOTIFY_SAFETY)
			BotNotifySprite.modulate = ThemeControl.bot_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.BOT_NOTIFY_SAFETY_OUTER)
		Notifications.TOP_TOUCHDOWN:
			TopNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_TD)
			TopNotifySprite.modulate = ThemeControl.top_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_TD_OUTER)
			BotNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_TD)
			BotNotifySprite.modulate = ThemeControl.top_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_TD_OUTER)
		Notifications.TOP_KICK_SUCCESS:
			TopNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_KICK_SUCCESS)
			TopNotifySprite.modulate = ThemeControl.top_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_KICK_SUCCESS_OUTER)
			BotNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_KICK_SUCCESS)
			BotNotifySprite.modulate = ThemeControl.top_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_KICK_SUCCESS_OUTER)
		Notifications.TOP_KICK_FAILURE:
			TopNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_KICK_FAILURE)
			TopNotifySprite.modulate = ThemeControl.top_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_KICK_FAILURE_OUTER)
			BotNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_KICK_FAILURE)
			BotNotifySprite.modulate = ThemeControl.top_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_KICK_FAILURE_OUTER)
		Notifications.TOP_TOUCHBACK_STRIKE:
			TopNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_TOUCHBACK_STRIKE)
			TopNotifySprite.modulate = ThemeControl.top_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_TOUCHBACK_STRIKE_OUTER)
			BotNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_TOUCHBACK_STRIKE)
			BotNotifySprite.modulate = ThemeControl.top_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_TOUCHBACK_STRIKE_OUTER)
		Notifications.TOP_OOB:
			TopNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_OOB)
			TopNotifySprite.modulate = ThemeControl.top_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_OOB_OUTER)
			BotNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_OOB)
			BotNotifySprite.modulate = ThemeControl.top_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_OOB_OUTER)
		Notifications.TOP_2PT_SUCCESS:
			TopNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_2PT_SUCCESS)
			TopNotifySprite.modulate = ThemeControl.top_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_2PT_SUCCESS_OUTER)
			BotNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_2PT_SUCCESS)
			BotNotifySprite.modulate = ThemeControl.top_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_2PT_SUCCESS_OUTER)
		Notifications.TOP_SAFETY:
			TopNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_SAFETY)
			TopNotifySprite.modulate = ThemeControl.top_color_code
			TopNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_SAFETY_OUTER)
			BotNotifySprite.set_texture(ThemeControl.TOP_NOTIFY_SAFETY)
			BotNotifySprite.modulate = ThemeControl.top_color_code
			BotNotifySpriteOuter.set_texture(ThemeControl.TOP_NOTIFY_SAFETY_OUTER)
	TopNotifySprite.show()
	BotNotifySprite.show()
	NotifyTween.interpolate_property(BotNotifySprite, "position", _bot_start, _bot_end, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
	notification_reset_bot = BotNotifySprite
	match Main.current_game_type:
		Main.GameType.VS_2P:
			NotifyTween.interpolate_property(TopNotifySprite, "position", _top_start, _top_end, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
			notification_reset_top = TopNotifySprite
	NotifyTween.start()


func notify_splash_reset():
	var _bot_end = Vector2(1320, 980)
	var _top_end = Vector2(600, -300)
	var _bot_start = notification_reset_bot.position
	NotifyTweenResetBot.interpolate_property(notification_reset_bot, "position", _bot_start, _bot_end, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	NotifyTweenResetBot.start()
	match Main.current_game_type:
		Main.GameType.VS_2P:
			var _top_start = notification_reset_top.position
			NotifyTweenResetTop.interpolate_property(notification_reset_top, "position", _top_start, _top_end, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
			NotifyTweenResetTop.start()


func show_ref_cam():
	var _ref_half_position = get_viewport().get_visible_rect().size / 2
	RefCamMain.position.y = _ref_half_position.y
	RefCamGood.show()
	RefCamBad.show()
	var _ref_start = Vector2(-2180, _ref_half_position.y)
	var _ref_end = Vector2(200,_ref_half_position.y)
	RefCamTween.interpolate_property(RefCamMain, "position", _ref_start, _ref_end, .75, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	RefCamTween.start()
	is_ref_alive = true


func animate_ref_cam(result):
	var _delay_time
	var _timer
	if is_ref_alive:
		match result:
			1:
				RefAnimation.play("RefGood")
				RefCamBad.hide()
				_delay_time = 3
			2:
				RefAnimation.play("RefBad")
				RefCamGood.hide()
				_delay_time = 3
			0:
				RefAnimation.play("RefBad")
				RefCamGood.hide()
				_delay_time = 2
		print("animate ref cam")
		print(_delay_time)
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout",self, "hide_ref_cam")
		_timer.set_wait_time(_delay_time)
		_timer.set_one_shot(true)
		_timer.start()


func hide_ref_cam():
	is_ref_alive = false
	print("ref cam hide called")
	RefAnimation.stop(true)
	var _ref_half_position = get_viewport().get_visible_rect().size / 2
	var _ref_start = RefCamMain.position
	var _ref_end = Vector2(-2180, _ref_half_position.y)
	RefCamTween.interpolate_property(RefCamMain, "position", _ref_start, _ref_end, .75, Tween.TRANS_CUBIC, Tween.EASE_IN)
	RefCamTween.start()


#func update_game_status(statusMessage):
#	GameStatusLabelTop.text = statusMessage
#	GameStatusLabelBot.text = statusMessage
#	GameStatusLabelTop.show()
#	GameStatusLabelBot.show()
#	var _delay_time = 4
#	var _timer
#	_timer = Timer.new()
#	add_child(_timer)
#	_timer.connect("timeout",self, "_on_message_timer_timeout")
#	_timer.set_wait_time(_delay_time)
#	_timer.set_one_shot(true)
#	_timer.start()


#func _on_message_timer_timeout():
#	GameStatusLabelTop.text = ""
#	GameStatusLabelBot.text = ""
#	for n in self.get_children():
#		self.remove_child(n)
#		n.queue_free()

func update_two_minute_drill_score_timer():
	ChallengeTwoMinuteCurrentScore.text = str(StatControl.challenge_stats.two_minute_drill_score)
	if is_instance_valid(Main.get_node("ChallengeControl").tmd_timer):
		var formatted_time = format_time(Main.get_node("ChallengeControl").tmd_timer.get_time_left(), FORMAT_MINUTES | FORMAT_SECONDS)
		ChallengeTwoMinuteCurrentTime.text = formatted_time
	else : ChallengeTwoMinuteCurrentTime.text = "02:00"

func show_direction_instruction():
	var _current_turn = Main.current_ball.current_turn
	var _current_turn_enum = Main.current_ball.Turn
	var _left_direction_start = LeftDirection.position
	var _left_direction_end = Vector2(100,637)
	var _right_direction_start = RightDirection.position
	var _right_direction_end = Vector2(620,637)
	match _current_turn:
		_current_turn_enum.TOP:
			RightDirectionSprite.set_rotation_degrees(0)
			RightDirectionSprite.set_material(DropShadow)
			RightDirectionSpriteOuter.set_rotation_degrees(0)
			RightDirectionSprite.modulate = ThemeControl.top_color_code
			RightDirectionSpriteOuter.modulate = Color(0,0,0)
			RightDirectionSpriteOuter.set_material(DropShadow)
			LeftDirectionSprite.set_rotation_degrees(0)
			LeftDirectionSprite.set_material(DropShadow)
			LeftDirectionSpriteOuter.set_rotation_degrees(0)
			LeftDirectionSpriteOuter.set_material(DropShadow)
			LeftDirectionSprite.modulate = ThemeControl.top_color_code
			LeftDirectionSpriteOuter.modulate = Color(0,0,0)
			if Main.current_ball.position.x <= 360:
				DirectionTween.interpolate_property(RightDirection, "position", _right_direction_start, _right_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
			if Main.current_ball.position.x >= 360:
				DirectionTween.interpolate_property(LeftDirection, "position", _left_direction_start, _left_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		_current_turn_enum.BOT, _current_turn_enum.CHALLENGE_PRACTICE:
			RightDirectionSprite.set_rotation_degrees(180)
			RightDirectionSpriteOuter.set_rotation_degrees(0)
			RightDirectionSprite.set_material(DropShadowFlipped)
			RightDirectionSprite.modulate = ThemeControl.bot_color_code
			RightDirectionSpriteOuter.modulate = Color(0,0,0)
			RightDirectionSpriteOuter.set_material(DropShadowFlipped)
			LeftDirectionSprite.set_rotation_degrees(180)
			LeftDirectionSprite.set_material(DropShadowFlipped)
			LeftDirectionSpriteOuter.set_material(DropShadowFlipped)
			LeftDirectionSpriteOuter.set_rotation_degrees(0)
			LeftDirectionSprite.modulate = ThemeControl.bot_color_code
			LeftDirectionSpriteOuter.modulate = Color(0,0,0)
			if Main.current_ball.position.x <= 360:
				DirectionTween.interpolate_property(RightDirection, "position", _right_direction_start, _right_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
			if Main.current_ball.position.x >= 360:
				DirectionTween.interpolate_property(LeftDirection, "position", _left_direction_start, _left_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)

	DirectionTween.start()



func hide_direction_instruction():
	var _left_direction_start = LeftDirection.position
	var _left_direction_end = Vector2(-750, 637)
	var _right_direction_start = RightDirection.position
	var _right_direction_end = Vector2(1470, 637)
	DirectionTween.interpolate_property(RightDirection, "position", _right_direction_start, _right_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	DirectionTween.interpolate_property(LeftDirection, "position", _left_direction_start, _left_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	DirectionTween.interpolate_property(RightDirection, "position", _right_direction_start, _right_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	DirectionTween.interpolate_property(LeftDirection, "position", _left_direction_start, _left_direction_end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	DirectionTween.start()

func show_two_minute_drill_start():
	GPGSSubmit.hide()
	GPGS.player_connected()
	var _challenge_two_minute_start = ChallengeTwoMinute.position
	# todo
	# this doesn't sync up, its a mess to keep track of
	var _challenge_two_minute_end = Vector2(0,14)
	ChallengeTwoMinute.show()
	ChallengeTwoMinuteTitle.show()
	ChallengeTwoMinuteScoreboard.show()
	ChallengeTwoMinuteCurrentScore.show()
	ChallengeTwoMinuteCurrentTime.show()
	ChallengeTwoMinuteScoreLabel.show()
	ChallengeTwoMinuteStart.show()
	ChallengeTwoMinuteInfo.show()
	ChallengeTwoMinuteRestart.hide()
	ChallengeTwoMinuteReturnToMain.hide()
	ChallengeTwoMinuteResults.hide()
	match GPGS.is_player_signed_in:
		true: ChallengeTwoMinuteShowLeaderboard.show()
		false: ChallengeTwoMinuteShowLeaderboard.hide()
	ChallengeTwoMinuteTween.interpolate_property(ChallengeTwoMinute, "position", _challenge_two_minute_start, _challenge_two_minute_end, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	ChallengeTwoMinuteTween.start()


func two_minute_drill_gameplay():
	GPGSSubmit.hide()
	ChallengeTwoMinuteTitle.hide()
	ChallengeTwoMinuteShowLeaderboard.hide()
	ChallengeTwoMinuteStart.hide()
	ChallengeTwoMinuteInfo.hide()
	ChallengeTwoMinuteRestart.hide()
	ChallengeTwoMinuteReturnToMain.hide()
	ChallengeTwoMinuteResults.hide()
	ChallengeTwoMinuteScoreboard.show()
	ChallengeTwoMinuteCurrentScore.show()
	ChallengeTwoMinuteCurrentTime.show()
	ChallengeTwoMinuteScoreLabel.show()


func show_two_minute_drill_results():
	ChallengeTwoMinute.position = Vector2(0, -1500)
	BlockInput.show()
	GPGS.player_connected()
	var _challenge_two_minute_start = ChallengeTwoMinute.position
	var _challenge_two_minute_end = Vector2(0,14)
	ChallengeTwoMinuteTween.interpolate_property(ChallengeTwoMinute, "position", _challenge_two_minute_start, _challenge_two_minute_end, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	ChallengeTwoMinuteTween.start()
	ChallengeTwoMinuteShowLeaderboard.hide()
	ChallengeTwoMinuteScoreboard.hide()
	ChallengeTwoMinuteCurrentScore.hide()
	ChallengeTwoMinuteCurrentTime.hide()
	ChallengeTwoMinuteScoreLabel.hide()
	ChallengeTwoMinuteTitle.show()
	ChallengeTwoMinuteRestart.show()
	ChallengeTwoMinuteReturnToMain.show()
	ChallengeTwoMinuteResults.show()
	match GPGS.is_player_signed_in:
		true: GPGSSubmit.show()
		false: pass
	ChallengeTwoMinuteResults.text = StatControl.two_minute_drill_stats()


func show_shred_the_defense_start():
	GPGS.player_connected()
	GPGSSubmit.hide()
	ShredTheDefense.show()
	ShredTheDefenseTitle.show()
	ShredTheDefenseScoreboard.show()
	ShredTheDefenseCurrentScore.show()
	ShredTheDefenseCurrentDown.show()
	ShredTheDefenseScoreLabel.show()
	ShredTheDefenseRestart.hide()
	ShredTheDefenseReturnToMain.hide()
	ShredTheDefenseResults.hide()
	match GPGS.is_player_signed_in:
		true: ShredTheDefenseShowLeaderboard.show()
		false: ShredTheDefenseShowLeaderboard.hide()
	var _shred_the_defense_start = ShredTheDefense.position
	var _shred_the_defense_end = Vector2(360, 47)
	ShredTheDefenseTween.interpolate_property(ShredTheDefense, "position", _shred_the_defense_start, _shred_the_defense_end, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	ShredTheDefenseTween.start()


func shred_the_defense_gameplay():
	GPGSSubmit.hide()
	ShredTheDefensePlayClock.show()
	ShredTheDefenseTitle.hide()
	ShredTheDefenseStart.hide()
	ShredTheDefenseInfo.hide()
	ShredTheDefenseRestart.hide()
	ShredTheDefenseReturnToMain.hide()
	ShredTheDefenseResults.hide()
	ShredTheDefenseShowLeaderboard.hide()
	ShredTheDefense.show()
	ShredTheDefenseScoreboard.show()
	ShredTheDefenseCurrentScore.show()
	ShredTheDefenseCurrentDown.show()
	ShredTheDefenseScoreLabel.show()


func show_shred_the_defense_results():
	ShredTheDefense.position = Vector2(360, -1500)
	BlockInput.show()
	GPGS.player_connected()
	var _shred_the_defense_start = ShredTheDefense.position
	var _shred_the_defense_end = Vector2(360, 47)
	ShredTheDefenseTween.interpolate_property(ShredTheDefense, "position", _shred_the_defense_start, _shred_the_defense_end, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	ShredTheDefenseTween.start()
	ShredTheDefenseScoreboard.hide()
	ShredTheDefenseCurrentScore.hide()
	ShredTheDefensePlayClock.hide()
	ShredTheDefenseCurrentDown.hide()
	ShredTheDefenseScoreLabel.hide()
	ShredTheDefenseShowLeaderboard.hide()
	ShredTheDefenseTitle.show()
	ShredTheDefenseRestart.show()
	ShredTheDefenseReturnToMain.show()
	ShredTheDefenseResults.show()
	match GPGS.is_player_signed_in:
		true: GPGSSubmit.show()
		false: GPGSSubmit.hide()
	ShredTheDefenseResults.text = StatControl.shred_the_defense_stats()


func update_shred_the_defense_ui():
	ShredTheDefenseCurrentScore.text = str(StatControl.challenge_stats.shred_the_defense_score)
	match ChallengeControl.shred_the_defense_current_down:
		1: ShredTheDefenseCurrentDown.text = "1st Down"
		2: ShredTheDefenseCurrentDown.text = "2nd Down"
		3: ShredTheDefenseCurrentDown.text = "3rd Down"
		4: ShredTheDefenseCurrentDown.text = "4th Down"
	if is_instance_valid(Main.get_node("ChallengeControl").std_timer):
		var formatted_time = ":" + format_time(Main.get_node("ChallengeControl").std_timer.get_time_left(), FORMAT_SECONDS)
		ShredTheDefensePlayClock.text = formatted_time
		if !Main.get_node("TimeCloseSound").playing:
			if formatted_time == ":03":
				Main.get_node("TimeCloseSound").play()
	else: ShredTheDefensePlayClock.text = ""


func show_fgf_start():
	FgfTitle.show()
	BlockInput.show()
	GPGS.player_connected()
	GPGSSubmit.hide()
	FgfResults.hide()
	Fgf.show()
	FgfScoreboard.show()
	FgfCurrentScore.show()
	FgfScoreLabel.show()
	FgfInfo.show()
	FgfStart.show()
	match GPGS.is_player_signed_in:
		true: ShredTheDefenseShowLeaderboard.show()
		false: ShredTheDefenseShowLeaderboard.hide()
	var _fgf_start_pos = Fgf.position
	var _fgf_end_pos = Vector2(345, 45)
	FgfReturntoMain.hide()
	FgfRestart.hide()
	FgfTween.interpolate_property(Fgf, "position", _fgf_start_pos, _fgf_end_pos, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	FgfTween.start()


func show_fgf_gameplay():
	FgfTitle.hide()
	ShredTheDefenseShowLeaderboard.hide()
	GPGSSubmit.hide()
	FgfResults.hide()
	FgfInfo.hide()
	FgfStart.hide()
	FgfReturntoMain.hide()
	FgfRestart.hide()
	FgfScoreboard.show()
	FgfCurrentScore.show()
	FgfScoreLabel.show()


func show_fgf_results():
	Fgf.position = Vector2(356, -1239)
	BlockInput.show()
	var _fgf_start_pos = Fgf.position
	var _fgf_end_pos = Vector2(345, 45)
	FgfTween.interpolate_property(Fgf, "position", _fgf_start_pos, _fgf_end_pos, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	FgfScoreboard.hide()
	FgfCurrentScore.hide()
	FgfScoreLabel.hide()
	ShredTheDefensePlayClock.hide()
	FgfTween.start()
	GPGS.player_connected()
	ShredTheDefenseShowLeaderboard.hide()
	FgfTitle.show()
	FgfResults.show()
	FgfReturntoMain.show()
	FgfRestart.show()
	FgfResults.text = StatControl.fgf_stats()
	match GPGS.is_player_signed_in:
		true: GPGSSubmit.show()
		false: pass
	ShredTheDefenseResults.text = StatControl.shred_the_defense_stats()


func update_fgf():
	FgfCurrentScore.text = str(StatControl.challenge_stats.fgf_score)


func format_time(time, format = FORMAT_DEFAULT, digit_format = "%02d"):
	var digits = []
	if format & FORMAT_HOURS:
		var hours = digit_format % [time / 3600]
		digits.append(hours)
	if format & FORMAT_MINUTES:
		var minutes = digit_format % [time / 60]
		digits.append(minutes)
	if format & FORMAT_SECONDS:
		var seconds = digit_format % [int(ceil(time)) % 60]
		digits.append(seconds)
	var formatted = String()
	var colon = ":"
	for digit in digits:
		formatted += digit + colon
	if not formatted.empty():
		formatted = formatted.rstrip(colon)
	# weird time display bug, this resolves it
	if formatted == "01:00":
		return "02:00"
	if formatted == "00:00":
		return "01:00"
	return formatted


func fade_out(stream_player):
	# tween music volume down to 0
	AudioTween.interpolate_property(stream_player, "volume_db", 0, -80, Transition_duration, Transition_type, Tween.EASE_IN, 0)
	AudioTween.start()
	# when the tween ends, the music will be stopped

func fade_in(stream_player):
	AudioTween.interpolate_property(stream_player, "volume_db", -80, 0, 2.25, Transition_type, Tween.EASE_IN, 0)
	AudioTween.start()
