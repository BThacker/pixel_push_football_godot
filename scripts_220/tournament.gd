# 2020 Pixel Push Football - Brandon Thacker 

extends Node2D


onready var ResumeButton = $NewExisting/Resume
onready var StartNew = $NewExisting/StartNew
onready var StartBack = $NewExisting/Back
onready var NewExisting = $NewExisting
onready var Choices = $Choices
onready var Bracket = $Bracket
onready var Main = get_parent()
onready var MenuSelectSound = Main.get_node("MenuSelectSound")
onready var MenuControl = Main.get_node("MenuControl")
onready var TC = Main.get_node("ThemeControl")

# related to the seed team names for reference
var next_team_1_index
var next_team_2_index
var current_game
# for AI simulation
var score = [0,0]
# id 0 = CPU, id 1 = Player

var seed_team_names = ["RED","BLUE","GREEN","PURPLE","YELLOW","PINK"]
var seed_colors = [Color(.71, .13, .16),Color(.16, .36, .77),Color(.1, .48, .24),Color(.47, .23, .5),Color(1, .84, .25),Color(.91, .42, .45),Color(1,1,1)]

var next_p1_ai = false
var next_p2_ai = false
var PaperColorDict = {
	"RED": Color(.71, .13, .16),
	"BLUE": Color(.16, .36, .77),
	"GREEN": Color(.1, .48, .24) ,
	"PURPLE": Color(.47, .23, .5),
	"YELLOW": Color(1, .84, .25),
	"PINK": Color(.91, .42, .45),
	"WHITE": Color(1,1,1)
}

func _ready():
	$NewExisting/TrophyAnimate.play("TrophyRotate")


func start(entrypoint):
	match entrypoint:
		1:
			show_new_existing()
			if SaveSettings.BracketData["active_tournament"]:
				$NewExisting/Resume.set_disabled(false)
			else:
				$NewExisting/Resume.set_disabled(true)
			$NewExisting/TrophyAnimate/TrophyGraphic.show()
		2:
			show_bracket()
			update_bracket()

func return_from_game():
	$Choices.hide()
	$NewExisting.hide()
	$NewExisting/TrophyAnimate/TrophyGraphic.hide()
	show_bracket()
	match SaveSettings.BracketData["games_completed"]:
		0:
			SaveSettings.BracketData["game_1_winner"] = SaveSettings.BracketData["last_game_winner"]
			if SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_1_p1_score"] = Main.top_score
				SaveSettings.BracketData["game_1_p2_score"] = Main.bot_score
			if !SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_1_p1_score"] = Main.bot_score
				SaveSettings.BracketData["game_1_p2_score"] = Main.top_score
		1:
			SaveSettings.BracketData["game_2_winner"] = SaveSettings.BracketData["last_game_winner"]
			if SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_2_p1_score"] = Main.top_score
				SaveSettings.BracketData["game_2_p2_score"] = Main.bot_score
			if !SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_2_p1_score"] = Main.bot_score
				SaveSettings.BracketData["game_2_p2_score"] = Main.top_score
		2:
			SaveSettings.BracketData["game_3_winner"] = SaveSettings.BracketData["last_game_winner"]
			if SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_3_p1_score"] = Main.top_score
				SaveSettings.BracketData["game_3_p2_score"] = Main.bot_score
			if !SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_3_p1_score"] = Main.bot_score
				SaveSettings.BracketData["game_3_p2_score"] = Main.top_score
		3:
			SaveSettings.BracketData["game_4_winner"] = SaveSettings.BracketData["last_game_winner"]
			if SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_4_p1_score"] = Main.top_score
				SaveSettings.BracketData["game_4_p2_score"] = Main.bot_score
			if !SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_4_p1_score"] = Main.bot_score
				SaveSettings.BracketData["game_4_p2_score"] = Main.top_score
		4:
			SaveSettings.BracketData["game_5_winner"] = SaveSettings.BracketData["last_game_winner"]
			if SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_5_p1_score"] = Main.top_score
				SaveSettings.BracketData["game_5_p2_score"] = Main.bot_score
			if !SaveSettings.BracketData["last_index_flipped"]:
				SaveSettings.BracketData["game_5_p1_score"] = Main.bot_score
				SaveSettings.BracketData["game_5_p2_score"] = Main.top_score
	SaveSettings.BracketData["games_completed"] += 1
	update_bracket()

func show_new_existing():
	NewExisting.show()
	Choices.hide()
	Bracket.hide()
	ResumeButton.set_disabled(true)
	#if SaveSettings.pixel_push_tournament["current_tournament"]:
	#	ResumeButton.set_disabled(false)


func show_choices():
	NewExisting.hide()
	$NewExisting/TrophyAnimate/TrophyGraphic.hide()
	Choices.show()
	Bracket.hide()


func show_bracket():
	StartNew.hide()
	Choices.hide()
	Bracket.show()
	$Bracket/BracketTrophyRotate.play("TrophyBracketRotate")
	$Bracket/BracketTrophyRotate/BracketTrophy.show()


func get_all_choices():
	SaveSettings.BracketData["ai_players"][0] = $Choices/P1ChoiceAI.get_selected_id()
	SaveSettings.BracketData["ai_players"][1] = $Choices/P2ChoiceAI.get_selected_id()
	SaveSettings.BracketData["ai_players"][2] = $Choices/P3ChoiceAI.get_selected_id()
	SaveSettings.BracketData["ai_players"][3] = $Choices/P4ChoiceAI.get_selected_id()
	SaveSettings.BracketData["ai_players"][4] = $Choices/P5ChoiceAI.get_selected_id()
	SaveSettings.BracketData["ai_players"][5] = $Choices/P6ChoiceAI.get_selected_id()
	# 0 = Easy, 1 = Medium, 2 = Hard
	SaveSettings.BracketData["ai_difficulty"] = $Choices/AIDifficultyChoice.get_selected_id()
	# 0 = 14, 1 = 21, 2 = 28, 3 = 35
	match $Choices/GameLengthChoice.get_selected_id():
		0: SaveSettings.BracketData["game_length"] = 14
		1: SaveSettings.BracketData["game_length"] = 21
		2: SaveSettings.BracketData["game_length"] = 28
		3: SaveSettings.BracketData["game_length"] = 35

	SaveSettings.BracketData["theme"] = $Choices/ThemeChoice.get_selected_id()
	SaveSettings.BracketData["randomize_kickoff"] = $Choices/RandomizeKickoffCheck.is_pressed()
	# shuffle the array to generate the seed
	SaveSettings.BracketData["seed_order"].shuffle()
	generate_bracket_initial()
	update_bracket()
	Choices.hide()
	Bracket.show()
	$Bracket/BracketTrophyRotate/BracketTrophy.show()
	$Bracket/BracketTrophyRotate.play("TrophyBracketRotate")

func simulate_ai_game():
	score[0] = 0
	score[1] = 0
	randomize()
	var _fifty_fifty = int(rand_range(1,3))
	var _first_move
	var _second_move
	match _fifty_fifty:
		1:
			_first_move = 0
			_second_move = 1
		2:
			_first_move = 1
			_second_move = 0

	while score[0] < SaveSettings.BracketData["game_length"] and score[1] < SaveSettings.BracketData["game_length"]:
		ai_scoring_simulation(_first_move)
		if score[_first_move] < SaveSettings.BracketData["game_length"]:
			ai_scoring_simulation(_second_move)

	match SaveSettings.BracketData["games_completed"]:
		0:
			if score[0] > score[1]:
				SaveSettings.BracketData["game_1_winner"] = SaveSettings.BracketData["game_1_p1"]
			if score[1] > score[0]:
				SaveSettings.BracketData["game_1_winner"] = SaveSettings.BracketData["game_1_p2"]
			SaveSettings.BracketData["game_1_p1_score"] = score[0]
			SaveSettings.BracketData["game_1_p2_score"] = score[1]
		1:
			if score[0] > score[1]:
				SaveSettings.BracketData["game_2_winner"] = SaveSettings.BracketData["game_2_p1"]
			if score[1] > score[0]:
				SaveSettings.BracketData["game_2_winner"] = SaveSettings.BracketData["game_2_p2"]
			SaveSettings.BracketData["game_2_p1_score"] = score[0]
			SaveSettings.BracketData["game_2_p2_score"] = score[1]
		2:
			if score[0] > score[1]:
				SaveSettings.BracketData["game_3_winner"] = SaveSettings.BracketData["game_3_p1"]
			if score[1] > score[0]:
				SaveSettings.BracketData["game_3_winner"] = SaveSettings.BracketData["game_3_p2"]
			SaveSettings.BracketData["game_3_p1_score"] = score[0]
			SaveSettings.BracketData["game_3_p2_score"] = score[1]
		3:
			if score[0] > score[1]:
				SaveSettings.BracketData["game_4_winner"] = SaveSettings.BracketData["game_4_p1"]
			if score[1] > score[0]:
				SaveSettings.BracketData["game_4_winner"] = SaveSettings.BracketData["game_4_p2"]
			SaveSettings.BracketData["game_4_p1_score"] = score[0]
			SaveSettings.BracketData["game_4_p2_score"] = score[1]
		4:
			if score[0] > score[1]:
				SaveSettings.BracketData["game_5_winner"] = SaveSettings.BracketData["game_5_p1"]
			if score[1] > score[0]:
				SaveSettings.BracketData["game_5_winner"] = SaveSettings.BracketData["game_5_p2"]
			SaveSettings.BracketData["game_5_p1_score"] = score[0]
			SaveSettings.BracketData["game_5_p2_score"] = score[1]
	SaveSettings.BracketData["games_completed"] += 1
	update_bracket()



func ai_scoring_simulation(player):
	var _scoring_chance = 15
	var _touchdown_percentage = 80
	var _field_goal_percentage = 35
	var _safety_percentage = 2
	var _extra_point_percentage = 90
	var _2_pt_percentage = 10
	var _2_pt_success_rate = 45
	var _score_seed = int(rand_range(0,101))
	var _can_score = int(rand_range(0,101))
	if _can_score <= _scoring_chance:
		if _score_seed <= 2:
			score[player] += 2
			return
		if _score_seed <= _field_goal_percentage:
			score[player] += 3
			return
		if _score_seed <= _touchdown_percentage :
			score[player] += 6
			if _score_seed <= _extra_point_percentage:
				if score[player] < SaveSettings.BracketData["game_length"]:
					score[player] += 1
				return
			return

func start_player_game():
	pass

# this will use the random seed generated by shuffling the array
func generate_bracket_initial():
	SaveSettings.BracketData["game_1_p1"] = seed_team_names[SaveSettings.BracketData["seed_order"][2]]
	SaveSettings.BracketData["game_1_p1_color"] = seed_colors[SaveSettings.BracketData["seed_order"][2]]
	SaveSettings.BracketData["game_1_p2"] = seed_team_names[SaveSettings.BracketData["seed_order"][4]]
	SaveSettings.BracketData["game_1_p2_color"] = seed_colors[SaveSettings.BracketData["seed_order"][4]]
	SaveSettings.BracketData["game_2_p1"] = seed_team_names[SaveSettings.BracketData["seed_order"][3]]
	SaveSettings.BracketData["game_2_p1_color"] = seed_colors[SaveSettings.BracketData["seed_order"][3]]
	SaveSettings.BracketData["game_2_p2"] = seed_team_names[SaveSettings.BracketData["seed_order"][5]]
	SaveSettings.BracketData["game_2_p2_color"] = seed_colors[SaveSettings.BracketData["seed_order"][5]]
	SaveSettings.BracketData["game_3_p1"] = seed_team_names[SaveSettings.BracketData["seed_order"][0]]
	SaveSettings.BracketData["game_3_p1_color"] = seed_colors[SaveSettings.BracketData["seed_order"][0]]
	SaveSettings.BracketData["game_4_p2"] = seed_team_names[SaveSettings.BracketData["seed_order"][1]]
	SaveSettings.BracketData["game_4_p2_color"] = seed_colors[SaveSettings.BracketData["seed_order"][1]]


func update_bracket():
	match SaveSettings.BracketData["games_completed"]:
		0:
			$Bracket/NextTeam1.set_text(SaveSettings.BracketData["game_1_p1"])
			$Bracket/NextTeam1.set("custom_colors/font_color", SaveSettings.BracketData["game_1_p1_color"])
			$Bracket/NextTeam2.set_text(SaveSettings.BracketData["game_1_p2"])
			$Bracket/NextTeam2.set("custom_colors/font_color", SaveSettings.BracketData["game_1_p2_color"])
			evaluate_ai()

		1:
			$Bracket/NextTeam1.set_text(SaveSettings.BracketData["game_2_p1"])
			$Bracket/NextTeam1.set("custom_colors/font_color", SaveSettings.BracketData["game_2_p1_color"])
			$Bracket/NextTeam2.set_text(SaveSettings.BracketData["game_2_p2"])
			$Bracket/NextTeam2.set("custom_colors/font_color", SaveSettings.BracketData["game_2_p2_color"])
			SaveSettings.BracketData["game_3_p2"] = SaveSettings.BracketData["game_1_winner"]
			SaveSettings.BracketData["game_3_p2_color"] = PaperColorDict[SaveSettings.BracketData["game_1_winner"]]
			evaluate_ai()
		2:
			$Bracket/NextTeam1.set_text(SaveSettings.BracketData["game_3_p1"])
			$Bracket/NextTeam1.set("custom_colors/font_color", SaveSettings.BracketData["game_3_p1_color"])
			$Bracket/NextTeam2.set_text(SaveSettings.BracketData["game_3_p2"])
			$Bracket/NextTeam2.set("custom_colors/font_color", SaveSettings.BracketData["game_3_p2_color"])
			SaveSettings.BracketData["game_4_p1"] = SaveSettings.BracketData["game_2_winner"]
			SaveSettings.BracketData["game_4_p1_color"] = PaperColorDict[SaveSettings.BracketData["game_2_winner"]]
			evaluate_ai()
		3:
			$Bracket/NextTeam1.set_text(SaveSettings.BracketData["game_4_p1"])
			$Bracket/NextTeam1.set("custom_colors/font_color", SaveSettings.BracketData["game_4_p1_color"])
			$Bracket/NextTeam2.set_text(SaveSettings.BracketData["game_4_p2"])
			$Bracket/NextTeam2.set("custom_colors/font_color", SaveSettings.BracketData["game_4_p2_color"])
			SaveSettings.BracketData["game_5_p1"] = SaveSettings.BracketData["game_3_winner"]
			SaveSettings.BracketData["game_5_p1_color"] = PaperColorDict[SaveSettings.BracketData["game_3_winner"]]
			evaluate_ai()
		4:
			SaveSettings.BracketData["game_5_p2"] = SaveSettings.BracketData["game_4_winner"]
			SaveSettings.BracketData["game_5_p2_color"] = PaperColorDict[SaveSettings.BracketData["game_4_winner"]]
			$Bracket/NextTeam1.set_text(SaveSettings.BracketData["game_5_p1"])
			$Bracket/NextTeam1.set("custom_colors/font_color", SaveSettings.BracketData["game_5_p1_color"])
			$Bracket/NextTeam2.set_text(SaveSettings.BracketData["game_5_p2"])
			$Bracket/NextTeam2.set("custom_colors/font_color", SaveSettings.BracketData["game_5_p2_color"])
			evaluate_ai()
		5:
			$Bracket/Champion.set_text(SaveSettings.BracketData["game_5_winner"])
			$Bracket/Champion.set("custom_colors/font_color", PaperColorDict[SaveSettings.BracketData["game_5_winner"]])
			$Bracket/Start.set_disabled(true)
			$Bracket/Simulate.set_disabled(true)
			$Bracket/NextTeam1.set_text("")
			$Bracket/NextTeam2.set_text("")
			$Bracket/NextGame.set_text(str(SaveSettings.BracketData["game_5_winner"]) + " is the Champion!")
			$Bracket/NextGame.set("custom_colors/font_color", PaperColorDict[SaveSettings.BracketData["game_5_winner"]])

	$Bracket/P1Game1.set_text(SaveSettings.BracketData["game_1_p1"])
	$Bracket/P1Game1.set("custom_colors/font_color", SaveSettings.BracketData["game_1_p1_color"])
	$Bracket/P1Game1Score.set_text(str(SaveSettings.BracketData["game_1_p1_score"]))
	$Bracket/P1Game1Score.set("custom_colors/font_color", SaveSettings.BracketData["game_1_p1_color"])
	$Bracket/P2Game1.set_text(SaveSettings.BracketData["game_1_p2"])
	$Bracket/P2Game1.set("custom_colors/font_color", SaveSettings.BracketData["game_1_p2_color"])
	$Bracket/P2Game1Score.set_text(str(SaveSettings.BracketData["game_1_p2_score"]))
	$Bracket/P2Game1Score.set("custom_colors/font_color", SaveSettings.BracketData["game_1_p2_color"])
	$Bracket/P1Game2.set_text(SaveSettings.BracketData["game_2_p1"])
	$Bracket/P1Game2.set("custom_colors/font_color", SaveSettings.BracketData["game_2_p1_color"])
	$Bracket/P1Game2Score.set_text(str(SaveSettings.BracketData["game_2_p1_score"]))
	$Bracket/P1Game2Score.set("custom_colors/font_color", SaveSettings.BracketData["game_2_p1_color"])
	$Bracket/P2Game2.set_text(SaveSettings.BracketData["game_2_p2"])
	$Bracket/P2Game2.set("custom_colors/font_color", SaveSettings.BracketData["game_2_p2_color"])
	$Bracket/P2Game2Score.set_text(str(SaveSettings.BracketData["game_2_p2_score"]))
	$Bracket/P2Game2Score.set("custom_colors/font_color", SaveSettings.BracketData["game_2_p2_color"])
	$Bracket/P1Game3.set_text(SaveSettings.BracketData["game_3_p1"])
	$Bracket/P1Game3.set("custom_colors/font_color", SaveSettings.BracketData["game_3_p1_color"])
	$Bracket/P1Game3Score.set_text(str(SaveSettings.BracketData["game_3_p1_score"]))
	$Bracket/P1Game3Score.set("custom_colors/font_color", SaveSettings.BracketData["game_3_p1_color"])
	$Bracket/P2Game3.set_text(SaveSettings.BracketData["game_3_p2"])
	$Bracket/P2Game3.set("custom_colors/font_color", SaveSettings.BracketData["game_3_p2_color"])
	$Bracket/P2Game3Score.set_text(str(SaveSettings.BracketData["game_3_p2_score"]))
	$Bracket/P2Game3Score.set("custom_colors/font_color", SaveSettings.BracketData["game_3_p2_color"])
	$Bracket/P1Game4.set_text(SaveSettings.BracketData["game_4_p1"])
	$Bracket/P1Game4.set("custom_colors/font_color", SaveSettings.BracketData["game_4_p1_color"])
	$Bracket/P1Game4Score.set_text(str(SaveSettings.BracketData["game_4_p1_score"]))
	$Bracket/P1Game4Score.set("custom_colors/font_color", SaveSettings.BracketData["game_4_p1_color"])
	$Bracket/P2Game4.set_text(SaveSettings.BracketData["game_4_p2"])
	$Bracket/P2Game4.set("custom_colors/font_color", SaveSettings.BracketData["game_4_p2_color"])
	$Bracket/P2Game4Score.set_text(str(SaveSettings.BracketData["game_4_p2_score"]))
	$Bracket/P2Game4Score.set("custom_colors/font_color", SaveSettings.BracketData["game_4_p2_color"])
	$Bracket/P1Game5.set_text(SaveSettings.BracketData["game_5_p1"])
	$Bracket/P1Game5.set("custom_colors/font_color", SaveSettings.BracketData["game_5_p1_color"])
	$Bracket/P1Game5Score.set_text(str(SaveSettings.BracketData["game_5_p1_score"]))
	$Bracket/P1Game5Score.set("custom_colors/font_color", SaveSettings.BracketData["game_5_p1_color"])
	$Bracket/P2Game5.set_text(SaveSettings.BracketData["game_5_p2"])
	$Bracket/P2Game5.set("custom_colors/font_color", SaveSettings.BracketData["game_5_p2_color"])
	$Bracket/P2Game5Score.set_text(str(SaveSettings.BracketData["game_5_p2_score"]))
	$Bracket/P2Game5Score.set("custom_colors/font_color", SaveSettings.BracketData["game_5_p2_color"])
	SaveSettings.BracketData["active_tournament"] = true
	SaveSettings.tournament_save()
	if SaveSettings.BracketData["games_completed"] == 5:
		SaveSettings.reset_tournament_vars()

func evaluate_ai():
	var _player_1
	var _player_2
	# these are strings passed to the dictionary
	match SaveSettings.BracketData["games_completed"]:
		0:
			_player_1 = "game_1_p1"
			_player_2 = "game_1_p2"
		1:
			_player_1 = "game_2_p1"
			_player_2 = "game_2_p2"
		2:
			_player_1 = "game_3_p1"
			_player_2 = "game_3_p2"
		3:
			_player_1 = "game_4_p1"
			_player_2 = "game_4_p2"
		4:
			_player_1 = "game_5_p1"
			_player_2 = "game_5_p2"
	for i in range(0, seed_team_names.size()):
		if seed_team_names[i] == SaveSettings.BracketData[_player_1]:
			if SaveSettings.BracketData["ai_players"][i] == 0:
				next_p1_ai = true
	for i in range(0, seed_team_names.size()):
		if seed_team_names[i] == SaveSettings.BracketData[_player_2]:
			if SaveSettings.BracketData["ai_players"][i] == 0:
				next_p2_ai = true
	if next_p1_ai and next_p2_ai:
		$Bracket/Simulate.set_disabled(false)
		$Bracket/Start.set_disabled(true)
	if !next_p1_ai or !next_p2_ai:
		$Bracket/Simulate.set_disabled(true)
		$Bracket/Start.set_disabled(false)

func set_theme_values():
	# a lot of this code is duplicated from the customziie script
	# needs a refactor at a later date
	# be advised if adding graphics or themes this will have to be updated as well
	# should prob just put this in the theme controller
	randomize()
	var _temp_chosen_theme_index = SaveSettings.BracketData["theme"]
	match _temp_chosen_theme_index:
		0:
			var _temp_chosen_gamefield_index = int(rand_range(0,3))
			var _temp_chosen_ball_index = int(rand_range(0,18))
			TC.selected_theme = TC.Themes.PAPER

			match _temp_chosen_gamefield_index:
				0: TC.selected_gamefield = TC.PaperGamefields.BLUEPRINT
				1: TC.selected_gamefield = TC.PaperGamefields.CARDBOARD
				2: TC.selected_gamefield = TC.PaperGamefields.NOTEBOOK
			match _temp_chosen_ball_index:
				0: TC.selected_ball = TC.paper_ball_white_1
				1: TC.selected_ball = TC.paper_ball_grey_1
				2: TC.selected_ball = TC.paper_ball_burnt_red_1
				3: TC.selected_ball = TC.paper_ball_blue_green_1
				4: TC.selected_ball = TC.paper_ball_tan_1
				5: TC.selected_ball = TC.paper_ball_tan_2
				6: TC.selected_ball = TC.paper_ball_white_blue_1
				7: TC.selected_ball = TC.paper_ball_green_1
				8: TC.selected_ball = TC.paper_ball_green_2
				9: TC.selected_ball = TC.paper_ball_notebook_1
				10: TC.selected_ball = TC.paper_ball_notebook_2
				11: TC.selected_ball = TC.paper_ball_notebook_3
				12: TC.selected_ball = TC.paper_ball_notebook_4
				13: TC.selected_ball = TC.paper_ball_notebook_5
				14: TC.selected_ball = TC.paper_ball_notebook_6
				15: TC.selected_ball = TC.paper_ball_brown_1
				16: TC.selected_ball = TC.paper_ball_brown_2
				17: TC.selected_ball = TC.paper_ball_brown_3
		# theme league
		1:
			var _temp_chosen_gamefield_index = int(rand_range(0,4))
			var _temp_chosen_ball_index = int(rand_range(0,4))
			TC.selected_theme = TC.Themes.LEAGUE
			match _temp_chosen_gamefield_index:
				0: TC.selected_gamefield = TC.LeagueGamefields.STRIPED_NUMBERS
				1: TC.selected_gamefield = TC.LeagueGamefields.STRIPED
				2: TC.selected_gamefield = TC.LeagueGamefields.GREEN_NUMBERS
				3: TC.selected_gamefield = TC.LeagueGamefields.GREEN
			match _temp_chosen_ball_index:
				0:TC.selected_ball = TC.league_ball_pro_round
				1:TC.selected_ball = TC.league_ball_pro_triangle
				2:TC.selected_ball = TC.league_ball_college_round
				3:TC.selected_ball = TC.league_ball_college_triangle
		# theme retro
		2:
			var _temp_chosen_gamefield_index = 0
			var _temp_chosen_ball_index = int(rand_range(0,4))
			TC.selected_theme = TC.Themes.RETRO
			match _temp_chosen_gamefield_index:
				0: TC.selected_gamefield = TC.RETRO_GAMEFIELD
			match _temp_chosen_ball_index:
				0: TC.selected_ball = TC.retro_ball_purple
				1: TC.selected_ball = TC.retro_ball_red
				2: TC.selected_ball = TC.retro_ball_yellow
				3: TC.selected_ball = TC.retro_ball_aqua

func submit_previous_game_results():
	pass


# Button logic
func _on_Back_pressed():
	get_tree().reload_current_scene()


func _on_StartNew_pressed():
	MenuSelectSound.play()
	SaveSettings.reset_tournament_vars()
	show_choices()


func _on_Start_pressed():
	var _can_proceed = evaluate_player_choice()
	match _can_proceed:
		true:
			MenuSelectSound.play()
			get_all_choices()
		false:
			$Choices/ErrorMessage.show()
			Main.get_node("ErrorSound").play()


func _on_Exit_pressed():
	get_tree().reload_current_scene()

func evaluate_player_choice():
	if $Choices/P1ChoiceAI.get_selected_id() == 1: return true
	if $Choices/P2ChoiceAI.get_selected_id() == 1: return true
	if $Choices/P3ChoiceAI.get_selected_id() == 1: return true
	if $Choices/P4ChoiceAI.get_selected_id() == 1: return true
	if $Choices/P5ChoiceAI.get_selected_id() == 1: return true
	if $Choices/P6ChoiceAI.get_selected_id() == 1: return true
	return false


func _on_Simulate_pressed():
	MenuSelectSound.play()
	next_p1_ai = false
	next_p2_ai = false
	simulate_ai_game()



func _on_Start_game_pressed():
	var _fifty_fifty = int(rand_range(1,3))
	MenuSelectSound.play()
	MenuControl.GameOverMusic.stop()
	Main.tournament_mode = true
	Main.current_difficulty = SaveSettings.BracketData["ai_difficulty"]
	Main.winning_score = SaveSettings.BracketData["game_length"]
	Main.randomize_kickoff = SaveSettings.BracketData["randomize_kickoff"]
	set_theme_values()
	var _temp_player_1
	var _temp_player_2
	match SaveSettings.BracketData["games_completed"]:
		0:
			_temp_player_1 = SaveSettings.BracketData["game_1_p1"]
			_temp_player_2 = SaveSettings.BracketData["game_1_p2"]
		1:
			_temp_player_1 = SaveSettings.BracketData["game_2_p1"]
			_temp_player_2 = SaveSettings.BracketData["game_2_p2"]
		2:
			_temp_player_1 = SaveSettings.BracketData["game_3_p1"]
			_temp_player_2 = SaveSettings.BracketData["game_3_p2"]
		3:
			_temp_player_1 = SaveSettings.BracketData["game_4_p1"]
			_temp_player_2 = SaveSettings.BracketData["game_4_p2"]
		4:
			_temp_player_1 = SaveSettings.BracketData["game_5_p1"]
			_temp_player_2 = SaveSettings.BracketData["game_5_p2"]
	if !next_p1_ai and !next_p2_ai:
		set_player_index(_temp_player_1, _temp_player_2, 2)
		match _fifty_fifty:
			1:Main.start_action_2p(Main.FirstMove.BOT)
			2:Main.start_action_2p(Main.FirstMove.TOP)
	if !next_p1_ai and next_p2_ai:
		set_player_index(_temp_player_1, _temp_player_2, 2)
		match _fifty_fifty:
			1:Main.start_action_ai(Main.FirstMove.BOT)
			2:Main.start_action_ai(Main.FirstMove.TOP)
	if next_p1_ai and !next_p2_ai:
		set_player_index(_temp_player_1, _temp_player_2, 1)
		match _fifty_fifty:
			1:Main.start_action_ai(Main.FirstMove.BOT)
			2:Main.start_action_ai(Main.FirstMove.TOP)
	SaveSettings.tournament_save()
	queue_free()


func set_player_index(temp_player_1, temp_player_2, flip):
	var _temp_flip
	var _temp_player_1 = temp_player_1
	var _temp_player_2 = temp_player_2
	SaveSettings.BracketData["last_index_flipped"] = false
	match flip:
		1:
			_temp_flip = _temp_player_1
			_temp_player_1 = _temp_player_2
			_temp_player_2 = _temp_flip
			SaveSettings.BracketData["last_index_flipped"] = true
	match _temp_player_1:
		"RED":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.bot_player_selected_color = TC.PaperColors.RED
				TC.Themes.LEAGUE: TC.bot_player_selected_color = TC.LeagueColors.RED
				TC.Themes.RETRO: TC.bot_player_selected_color = TC.RetroColors.RED
		"BLUE":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.bot_player_selected_color = TC.PaperColors.BLUE
				TC.Themes.LEAGUE: TC.bot_player_selected_color = TC.LeagueColors.BLUE
				TC.Themes.RETRO: TC.bot_player_selected_color = TC.RetroColors.BLUE
		"GREEN":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.bot_player_selected_color = TC.PaperColors.GREEN
				TC.Themes.LEAGUE: TC.bot_player_selected_color = TC.LeagueColors.GREEN
				TC.Themes.RETRO: TC.bot_player_selected_color = TC.RetroColors.GREEN
		"PURPLE":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.bot_player_selected_color = TC.PaperColors.PURPLE
				TC.Themes.LEAGUE: TC.bot_player_selected_color = TC.LeagueColors.PURPLE
				TC.Themes.RETRO: TC.bot_player_selected_color = TC.RetroColors.PURPLE
		"YELLOW":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.bot_player_selected_color = TC.PaperColors.YELLOW
				TC.Themes.LEAGUE: TC.bot_player_selected_color = TC.LeagueColors.YELLOW
				TC.Themes.RETRO: TC.bot_player_selected_color = TC.RetroColors.YELLOW
		"PINK":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.bot_player_selected_color = TC.PaperColors.PINK
				TC.Themes.LEAGUE: TC.bot_player_selected_color = TC.LeagueColors.PINK
				TC.Themes.RETRO: TC.bot_player_selected_color = TC.RetroColors.PINK
	match _temp_player_2:
		"RED":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.top_player_selected_color = TC.PaperColors.RED
				TC.Themes.LEAGUE: TC.top_player_selected_color = TC.LeagueColors.RED
				TC.Themes.RETRO: TC.top_player_selected_color = TC.RetroColors.RED
		"BLUE":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.top_player_selected_color = TC.PaperColors.BLUE
				TC.Themes.LEAGUE: TC.top_player_selected_color = TC.LeagueColors.BLUE
				TC.Themes.RETRO: TC.top_player_selected_color = TC.RetroColors.BLUE
		"GREEN":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.top_player_selected_color = TC.PaperColors.GREEN
				TC.Themes.LEAGUE: TC.top_player_selected_color = TC.LeagueColors.GREEN
				TC.Themes.RETRO: TC.top_player_selected_color = TC.RetroColors.GREEN
		"PURPLE":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.top_player_selected_color = TC.PaperColors.PURPLE
				TC.Themes.LEAGUE: TC.top_player_selected_color = TC.LeagueColors.PURPLE
				TC.Themes.RETRO: TC.top_player_selected_color = TC.RetroColors.PURPLE
		"YELLOW":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.top_player_selected_color = TC.PaperColors.YELLOW
				TC.Themes.LEAGUE: TC.top_player_selected_color = TC.LeagueColors.YELLOW
				TC.Themes.RETRO: TC.top_player_selected_color = TC.RetroColors.YELLOW
		"PINK":
			match TC.selected_theme:
				TC.Themes.PAPER: TC.top_player_selected_color = TC.PaperColors.PINK
				TC.Themes.LEAGUE: TC.top_player_selected_color = TC.LeagueColors.PINK
				TC.Themes.RETRO: TC.top_player_selected_color = TC.RetroColors.PINK
	TC.set_theme_values()


func _on_Resume_pressed():
	MenuSelectSound.play()
	NewExisting.hide()
	$NewExisting/TrophyAnimate/TrophyGraphic.hide()
	update_bracket()
	Bracket.show()
	$Bracket/BracketTrophyRotate.play("TrophyBracketRotate")
	$Bracket/BracketTrophyRotate/BracketTrophy.show()
