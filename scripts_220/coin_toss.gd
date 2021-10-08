# 2020 Pixel Push Football - Brandon Thacker 

extends Node

enum Coin{HEADS, TAILS}
enum CoinState{FLIP, STOP}
enum Teams{TEAM_1, TEAM_2}
enum GameType{VS_AI, VS_2P}

onready var Main = get_parent()
onready var TC = Main.get_node("ThemeControl")
onready var Who = $Who
onready var Choose = $Choose
onready var BotHome = $BotHome
onready var TopHome = $TopHome
onready var Heads = $Heads
onready var Tails = $Tails
onready var CoinAnimate = $CoinAnimate
onready var CoinGraphic = CoinAnimate.get_node("CoinGraphic")
onready var StartGameButton = $StartGame
onready var ScoreInputDesc = $ScoreInputDesc
onready var ScoreInputError = $ScoreInputError
onready var MenuSelectSound = $MenuSelectSound
onready var MenuSelectSoundError = $MenuSelectSoundError
onready var MenuControl = Main.get_node("MenuControl")
onready var CoinFlipSound = $CoinFlipSound
onready var ScoreSlider = $ScoreSlider
onready var ScoreValue = $ScoreValue
onready var CoinTweenUp = $CoinTweenUp
onready var CoinTweenDown = $CoinTweenDown
onready var HeadsSound = $HeadsSound
onready var TailsSound = $TailsSound

# lows
onready var red1sound = preload("res://sounds/sound_ref_red_Low_01.wav")
onready var red2sound = preload("res://sounds/sound_ref_red_Low_02.wav")
onready var blue1sound = preload("res://sounds/sound_ref_blue_Low_01.wav")
onready var blue2sound = preload("res://sounds/sound_ref_blue_Low_02.wav")
onready var green1sound = preload("res://sounds/sound_ref_green_Low_01.wav")
onready var green2sound = preload("res://sounds/sound_ref_green_Low_02.wav")
onready var pink1sound = preload("res://sounds/sound_ref_pink_Low_01.wav")
onready var pink2sound = preload("res://sounds/sound_ref_pink_Low_02.wav")
onready var purple1sound = preload("res://sounds/sound_ref_purple_Low_01.wav")
onready var purple2sound = preload("res://sounds/sound_ref_purple_Low_02.wav")
onready var yellow1sound = preload("res://sounds/sound_ref_yellow_Low_01.wav")
onready var yellow2sound = preload("res://sounds/sound_ref_yellow_Low_02.wav")
onready var versus1sound = preload("res://sounds/sound_ref_versus_Low_01.wav")
onready var versus2sound  = preload("res://sounds/sound_ref_versus_Low_02.wav")

# highs
onready var red1soundhigh = preload("res://sounds/sound_ref_red_01.wav")
onready var red2soundhigh = preload("res://sounds/sound_ref_red_02.wav")
onready var blue1soundhigh = preload("res://sounds/sound_ref_blue_01.wav")
onready var blue2soundhigh = preload("res://sounds/sound_ref_blue_02.wav")
onready var green1soundhigh = preload("res://sounds/sound_ref_green_01.wav")
onready var green2soundhigh = preload("res://sounds/sound_ref_green_02.wav")
onready var pink1soundhigh = preload("res://sounds/sound_ref_pink_01.wav")
onready var pink2soundhigh = preload("res://sounds/sound_ref_pink_02.wav")
onready var purple1soundhigh = preload("res://sounds/sound_ref_purple_01.wav")
onready var purple2soundhigh = preload("res://sounds/sound_ref_purple_02.wav")
onready var yellow1soundhigh = preload("res://sounds/sound_ref_yellow_01.wav")
onready var yellow2soundhigh = preload("res://sounds/sound_ref_yellow_02.wav")
onready var versus1soundhigh = preload("res://sounds/sound_ref_versus_01.wav")
onready var versus2soundhigh  = preload("res://sounds/sound_ref_versus_02.wav")

var winning_player
var current_game_type
var coin_action
var coin_result
var chosen_coin_side
var home_team
var _timer_ai = null
var local_top_text
var local_bot_text
var half

func _ready():
	convert_player_text_prep()
	randomize()
	Main.can_pause = false

func convert_player_text_prep():
	var _top_style = StyleBoxFlat.new()
	var _bot_style = StyleBoxFlat.new()
	local_top_text = TC.top_text
	local_bot_text = TC.bot_text
	var _timer = Timer.new()
	_timer.connect("timeout",self, "announce_players")
	_timer.set_wait_time(1.2)
	_timer.set_one_shot(true)
	add_child(_timer)
	_timer.start()
	_top_style.set_bg_color(TC.top_color_code)
	_top_style.set_border_color(TC.top_color_code_dark)
	_top_style.set_border_width_all(12)
	_bot_style.set_bg_color(TC.bot_color_code)
	_bot_style.set_border_color(TC.bot_color_code_dark)
	_bot_style.set_border_width_all(12)
	TopHome.set("custom_styles/normal", _top_style)
	TopHome.text = local_top_text
	BotHome.set("custom_styles/normal", _bot_style)
	BotHome.text = local_bot_text
	# fix colors if yellow
	if TC.top_color_code == Color(1, .84, .25) or TC.top_color_code == Color(1, .99, .25):
		TopHome.set("custom_colors/font_color", Color(0, 0, 0))
	if TC.bot_color_code == Color(1, .84, .25) or TC.bot_color_code == Color(1, .99, .25):
		BotHome.set("custom_colors/font_color", Color(0, 0, 0))



func start_2P():
	Who.show()
	TopHome.show()
	BotHome.show()
	current_game_type = GameType.VS_2P


func start_AI():
	randomize()
	current_game_type = GameType.VS_AI
	var _first_value = bool(randi() % 2)
	if _first_value:
		home_team = Teams.TEAM_1
	else:
		home_team = Teams.TEAM_2

	begin_heads_tails(home_team)


func begin_heads_tails(selectedHomeColor):
	var _timer
	Who.hide()
	TopHome.hide()
	BotHome.hide()
	Heads.show()
	Tails.show()
	Choose.show()
	match current_game_type:
		GameType.VS_2P:
			match selectedHomeColor:
				Teams.TEAM_1:
					Choose.text = local_bot_text + " Team \n Choose Heads or Tails"
					#Choose.set("custom_colors/font_color", TC.bot_color_code)
				Teams.TEAM_2:
					Choose.text = local_top_text+ " Team \n Choose Heads or Tails"
					#Choose.set("custom_colors/font_color", TC.top_color_code)
		GameType.VS_AI:
			match selectedHomeColor:
				Teams.TEAM_1:
					Choose.text = local_bot_text + " PLAYER \n Choose Heads or Tails"
					#Choose.set("custom_colors/font_color", TC.bot_color_code)
				Teams.TEAM_2:
					Choose.text = local_top_text+ " CPU \n Choose Heads or Tails"
					$Heads.set_disabled(true)
					$Tails.set_disabled(true)
					$Heads.hide()
					$Tails.hide()
					_timer_ai = Timer.new()
					_timer_ai.connect("timeout",self, "_on_ai_coin_timeout")
					_timer_ai.set_wait_time(3.5)
					_timer_ai.set_one_shot(true)
					add_child(_timer_ai)
					_timer_ai.start()
					#Choose.set("custom_colors/font_color", TC.top_color_code)
				#Choose.set("custom_colors/font_color", TC.bot_color_code)

func _on_ai_coin_timeout():
	var _first_value = bool(randi() % 2)
	if _first_value:
		_on_Heads_pressed()
	else:
		_on_Tails_pressed()

func flip_coin(action):

	match action:
		CoinState.FLIP:
			CoinGraphic.show()
			var x = float(0)
			var _first_value = bool(randi() % 2)
			if _first_value:
				x = 3.3
			else:
				x = 3.9
			match x:
				3.3:
					CoinAnimate.get_animation("coin_animation").length = x
				3.9:
					CoinAnimate.get_animation("coin_animation").length = x
			CoinAnimate.play("coin_animation")
			$CoinFlipSound.play()
			half = x / 2
			CoinTweenUp.interpolate_property(CoinGraphic, "scale", Vector2(2,2), Vector2(4,4), half, Tween.TRANS_EXPO, Tween.EASE_OUT)
			CoinTweenUp.start()
			var _timer_flip = Timer.new()
			add_child(_timer_flip)
			_timer_flip.connect("timeout",self, "_on_Timer_timeout")
			x += .5
			_timer_flip.set_wait_time(x)
			_timer_flip.set_one_shot(true)
			_timer_flip.start()
		CoinState.STOP:
			if CoinGraphic.get_frame() == 0:
				coin_result = Coin.HEADS
				determine_winner()
			if CoinGraphic.get_frame() == 6:
				coin_result = Coin.TAILS
				determine_winner()

func _on_CoinTweenUp_tween_all_completed():
	CoinTweenDown.interpolate_property(CoinGraphic, "scale", Vector2(4,4), Vector2(2,2), half, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	CoinTweenDown.start()

func coin_flip():
	Heads.hide()
	Tails.hide()
	Choose.hide()
	coin_action = CoinState.FLIP
	flip_coin(coin_action)


func determine_winner():
	$RandomKickoff.show()
	$RandomKickoffOn.show()
	if Main.current_game_type == Main.GameType.VS_AI:
		$AIDifficulty.show()
		$Easy.show()
		$Medium.show()
		$Hard.show()
	match home_team:
		Teams.TEAM_1:
			match chosen_coin_side:
				Coin.TAILS:
					match coin_result:
						Coin.HEADS:
							HeadsSound.play()
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							ScoreInputDesc.text = local_top_text + " has won the toss.\nSlide to Set Winning Score:"
							check_full_unlock()
						Coin.TAILS:
							TailsSound.play()
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							ScoreInputDesc.text = local_bot_text + " has won the toss.\nSlide to Set Winning Score:"
							check_full_unlock()
				Coin.HEADS:
					match coin_result:
						Coin.HEADS:
							HeadsSound.play()
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							ScoreInputDesc.text = local_bot_text + " has won the toss.\nSlide to Set Winning Score:"
							check_full_unlock()
						Coin.TAILS:
							TailsSound.play()
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							ScoreInputDesc.text = local_top_text + " has won the toss.\nSlide to Set Winning Score:"
							check_full_unlock()
		Teams.TEAM_2:
			match chosen_coin_side:
				Coin.TAILS:
					match coin_result:
						Coin.HEADS:
							HeadsSound.play()
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							ScoreInputDesc.text = local_bot_text + " has won the toss.\nSlide to Set Winning Score"
							check_full_unlock()
						Coin.TAILS:
							TailsSound.play()
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							ScoreInputDesc.text = local_top_text + " has won the toss.\nSlide to Set Winning Score"
							check_full_unlock()
				Coin.HEADS:

					match coin_result:
						Coin.HEADS:
							HeadsSound.play()
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							ScoreInputDesc.text = local_top_text + " has won the toss.\nSlide to Set Winning Score"
							check_full_unlock()
						Coin.TAILS:
							TailsSound.play()
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							ScoreInputDesc.text = local_bot_text + " has won the toss.\nSlide to Set Winning Score"
							check_full_unlock()

# legacy code from IAP version, still needed due to logic
# refactor at some point
func check_full_unlock():
	match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
		true:
			ScoreInputDesc.show()
			#ScoreInput.show()
			ScoreSlider.show()
			ScoreValue.show()
			StartGameButton.show()
		false:
			ScoreInputDesc.text = "Free Version restricted to 14 points. Unlock the full game to enter a custom winning score."
			ScoreInputDesc.show()
			#ScoreInput.text = str(14)
			#ScoreInput.set_editable(false)
			#ScoreInput.show()
			StartGameButton.show()


func _on_Timer_timeout():
	flip_coin(CoinState.STOP)


func _on_red_home_pressed():
	home_team = Teams.TEAM_1
	begin_heads_tails(home_team)
	MenuSelectSound.play()


func _on_blue_home_pressed():
	home_team = Teams.TEAM_2
	begin_heads_tails(home_team)
	MenuSelectSound.play()


func _on_start_game_pressed():
	MenuControl.start_game_transition()
	var _score_to_win = $ScoreSlider.value
	#evaluate_scoring_input(_score_to_win)
	match $RandomKickoffOn.is_pressed():
		true: Main.randomize_kickoff = true
		false: Main.randomize_kickoff= false
	match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
		# need to validate input as full game unlocked
		# users can manipulate score from 6-99
		true:
			_score_to_win = int(_score_to_win)
			if $Easy.is_pressed(): Main.current_difficulty = 1
			if $Medium.is_pressed(): Main.current_difficulty = 2
			if $Hard.is_pressed():	Main.current_difficulty = 3
			if _score_to_win >= 6 and _score_to_win <= 99:
				Main.winning_score = _score_to_win
				match current_game_type:
					GameType.VS_2P:
						match winning_player:
							Teams.TEAM_2:
								Main.last_coin_toss_winning_player = 2
								Main.start_action_2p(Main.FirstMove.TOP)
							Teams.TEAM_1:
								Main.start_action_2p(Main.FirstMove.BOT)
								Main.last_coin_toss_winning_player = 1
					GameType.VS_AI:
						match winning_player:
							Teams.TEAM_2:
								Main.start_action_ai(Main.FirstMove.TOP)
								Main.last_coin_toss_winning_player = 2
							Teams.TEAM_1:
								Main.start_action_ai(Main.FirstMove.BOT)
								Main.last_coin_toss_winning_player = 1
		false:
			Main.winning_score = int(_score_to_win)
			match current_game_type:
				GameType.VS_2P:
					match winning_player:
						Teams.TEAM_2:
							Main.start_action_2p(Main.FirstMove.TOP)
						Teams.TEAM_1:
							Main.start_action_2p(Main.FirstMove.BOT)
				GameType.VS_AI:
					match winning_player:
						Teams.TEAM_2:
							Main.start_action_ai(Main.FirstMove.TOP)
						Teams.TEAM_1:
							Main.start_action_ai(Main.FirstMove.BOT)
	CoinGraphic.hide()
	ScoreInputError.show()
	MenuSelectSoundError.play()
	queue_free()


func _on_Heads_pressed():
	chosen_coin_side = Coin.HEADS
	coin_flip()
	MenuSelectSound.play()


func _on_Tails_pressed():
	chosen_coin_side = Coin.TAILS
	coin_flip()
	MenuSelectSound.play()


func _on_ScoreSlider_value_changed(value):
	ScoreValue.text = str(value)


#func evaluate_scoring_input(value):
#	print("score input was changed")
#	print(value)
#	if value.get_class() == TYPE_INT:
#		print("this is an int")
#		return
#	else:
#		print("this is not an int")
#		ScoreInput.value = 21


# logic for difficulty switch



func _on_Medium_pressed():
	$Easy.set_pressed(false)
	$Medium.set_pressed(true)
	$Hard.set_pressed(false)


func _on_Hard_pressed():
	$Easy.set_pressed(false)
	$Medium.set_pressed(false)
	$Hard.set_pressed(true)


func _on_Easy_pressed():
	$Easy.set_pressed(true)
	$Medium.set_pressed(false)
	$Hard.set_pressed(false)


func announce_players():
	randomize()
	local_top_text = TC.top_text
	local_bot_text = TC.bot_text
	var _seed = int(rand_range(0,2))

	match local_bot_text:
		"RED":
			match _seed:
				0:
					$Player1Sound.stream = red1sound
					$Player1SoundHigh.stream = red1soundhigh
				1:
					$Player1Sound.stream = red2sound
					$Player1SoundHigh.stream = red2soundhigh
		"BLUE":
			match _seed:
				0:
					$Player1Sound.stream = blue1sound
					$Player1SoundHigh.stream = blue1soundhigh
				1:
					$Player1Sound.stream = blue2sound
					$Player1SoundHigh.stream = blue2soundhigh
		"GREEN":
			match _seed:
				0:
					$Player1Sound.stream = green1sound
					$Player1SoundHigh.stream = green1soundhigh
				1:
					$Player1Sound.stream = green2sound
					$Player1SoundHigh.stream = green2soundhigh
		"YELLOW":
			match _seed:
				0:
					$Player1Sound.stream = yellow1sound
					$Player1SoundHigh.stream = yellow1soundhigh
				1:
					$Player1Sound.stream = yellow2sound
					$Player1SoundHigh.stream = yellow2soundhigh
		"PURPLE":
			match _seed:
				0:
					$Player1Sound.stream = purple1sound
					$Player1SoundHigh.stream = purple1soundhigh
				1:
					$Player1Sound.stream = purple2sound
					$Player1SoundHigh.stream = purple2soundhigh
		"PINK":
			match _seed:
				0:
					$Player1Sound.stream = pink1sound
					$Player1SoundHigh.stream = pink1soundhigh
				1:
					$Player1Sound.stream = pink2sound
					$Player1SoundHigh.stream = pink2soundhigh
	randomize()
	_seed = int(rand_range(0,2))

	match local_top_text:
		"RED":
			match _seed:
				0:
					$Player2Sound.stream = red1sound
					$Player2SoundHigh.stream = red1soundhigh
				1:
					$Player2Sound.stream = red2sound
					$Player2SoundHigh.stream = red2soundhigh
		"BLUE":
			match _seed:
				0:
					$Player2Sound.stream = blue1sound
					$Player2SoundHigh.stream = blue1soundhigh
				1:
					$Player2Sound.stream = blue2sound
					$Player2SoundHigh.stream = blue2soundhigh
		"GREEN":
			match _seed:
				0:
					$Player2Sound.stream = green1sound
					$Player2SoundHigh.stream = green1soundhigh
				1:
					$Player2Sound.stream = green2sound
					$Player2SoundHigh.stream = green2soundhigh
		"YELLOW":
			match _seed:
				0:
					$Player2Sound.stream = yellow1sound
					$Player2SoundHigh.stream = yellow1soundhigh
				1:
					$Player2Sound.stream = yellow2sound
					$Player2SoundHigh.stream = yellow2soundhigh
		"PURPLE":
			match _seed:
				0:
					$Player2Sound.stream = purple1sound
					$Player2SoundHigh.stream = purple1soundhigh
				1:
					$Player2Sound.stream = purple2sound
					$Player2SoundHigh.stream = purple2soundhigh
		"PINK":
			match _seed:
				0:
					$Player2Sound.stream = pink1sound
					$Player2SoundHigh.stream = pink1soundhigh
				1:
					$Player2Sound.stream = pink2sound
					$Player2SoundHigh.stream = pink2soundhigh
	randomize()
	_seed = int(rand_range(0,2))

	match _seed:
		0:
			$VersusSound.stream = versus1sound
			$VersusSoundHigh.stream = versus1soundhigh
		1:
			$VersusSound.stream = versus2sound
			$VersusSoundHigh.stream = versus2soundhigh

	var _timer1
	var _timer2
	$Player1Sound.play()
	$Player1SoundHigh.play()
	_timer1 = Timer.new()
	_timer1.connect("timeout",self, "play_versus_sound")
	_timer1.set_wait_time(.75)
	_timer1.set_one_shot(true)
	add_child(_timer1)
	_timer1.start()

	_timer2 = Timer.new()
	_timer2.connect("timeout",self, "play_player2_sound")
	_timer2.set_wait_time(1.5)
	_timer2.set_one_shot(true)
	add_child(_timer2)
	_timer2.start()


func play_versus_sound():
	$VersusSound.play()
	$VersusSoundHigh.play()

func play_player2_sound():
	$Player2Sound.play()
	$Player2SoundHigh.play()
