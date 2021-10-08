# Pixel Push Football - 2020 Brandon Thacker 

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


var winning_player
var current_game_type
var coin_action
var coin_result
var chosen_coin_side
var home_team
var _timer = null
var local_top_text
var local_bot_text

func _ready():
	convert_player_text_prep()
	randomize()
	Main.can_pause = false

func convert_player_text_prep():
	var _top_style = StyleBoxFlat.new()
	var _bot_style = StyleBoxFlat.new()
	local_top_text = TC.top_text
	local_bot_text = TC.bot_text
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


func start_2P():
	Who.show()
	TopHome.show()
	BotHome.show()
	current_game_type = GameType.VS_2P


func start_ai():
	current_game_type = GameType.VS_AI
	home_team = Teams.TEAM_1
	begin_heads_tails(home_team)


func begin_heads_tails(selectedHomeColor):
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
					Choose.text = local_bot_text + " Team \n Choose Heads or Tails:"
					Choose.set("custom_colors/font_color", TC.bot_color_code)
				Teams.TEAM_2:
					Choose.text = local_top_text+ " Team \n Choose Heads or Tails:"
					Choose.set("custom_colors/font_color", TC.top_color_code)
		GameType.VS_AI:
				Choose.text = "Player\nChoose Heads or Tails:"
				Choose.set("custom_colors/font_color", TC.bot_color_code)


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
			_timer = Timer.new()
			add_child(_timer)
			_timer.connect("timeout",self, "_on_Timer_timeout")
			x += .5
			_timer.set_wait_time(x)
			_timer.set_one_shot(true)
			_timer.start()
		CoinState.STOP:
			if CoinGraphic.get_frame() == 0:
				coin_result = Coin.HEADS
				determine_winner()
			if CoinGraphic.get_frame() == 6:
				coin_result = Coin.TAILS
				determine_winner()


func coin_flip():
	Heads.hide()
	Tails.hide()
	Choose.hide()
	coin_action = CoinState.FLIP
	flip_coin(coin_action)


func determine_winner():
	match home_team:
		Teams.TEAM_1:
			match chosen_coin_side:
				Coin.TAILS:
					match coin_result:
						Coin.HEADS:
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							check_full_unlock()
						Coin.TAILS:
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							check_full_unlock()
				Coin.HEADS:
					match coin_result:
						Coin.HEADS:
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							check_full_unlock()
						Coin.TAILS:
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							check_full_unlock()
		Teams.TEAM_2:
			match chosen_coin_side:
				Coin.TAILS:
					match coin_result:
						Coin.HEADS:
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							check_full_unlock()
						Coin.TAILS:
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							check_full_unlock()
				Coin.HEADS:
					match coin_result:
						Coin.HEADS:
							winning_player = Teams.TEAM_2
							ScoreValue.set("custom_colors/font_color", TC.bot_color_code)
							check_full_unlock()
						Coin.TAILS:
							winning_player = Teams.TEAM_1
							ScoreValue.set("custom_colors/font_color", TC.top_color_code)
							check_full_unlock()


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
	print("score to win")
	print(_score_to_win)
	#evaluate_scoring_input(_score_to_win)
	match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
		# need to validate input as full game unlocked
		# users can manipulate score from 6-99
		true:
			_score_to_win = int(_score_to_win)
			if _score_to_win >= 6 and _score_to_win <= 99:
				Main.winning_score = _score_to_win
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

