# Pixel Push Football - 2020 Brandon Thacker 

extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Main = get_parent()
onready var TC = Main.get_node("ThemeControl")
onready var is_unlocked = true # SaveSettings.pixel_push_save_data["is_full_game_unlocked"]
onready var ThemePaper = $Theme/Paper
onready var ThemeRetro = $Theme/Retro
onready var ThemeLeague = $Theme/League
onready var FieldPaper = $Field/Paper
onready var FieldRetro = $Field/Retro
onready var FieldLeague = $Field/League
onready var BallPaper = $Ball/Paper
onready var BallRetro = $Ball/Retro
onready var BallLeague = $Ball/League
onready var P1Red = $Player1/Red
onready var P1Blue = $Player1/Blue
onready var P1Green = $Player1/Green
onready var P1Purple = $Player1/Purple
onready var P1Yellow = $Player1/Yellow
onready var P1Pink = $Player1/Pink
onready var P2Red = $Player2/Red
onready var P2Blue = $Player2/Blue
onready var P2Green = $Player2/Green
onready var P2Purple = $Player2/Purple
onready var P2Yellow = $Player2/Yellow
onready var P2Pink = $Player2/Pink
onready var ChooseField = $ChooseField/ChooseField
onready var ChooseBall = $ChooseBall/ChooseBall
# we have to convert the enum back to a graphic
# I decided to do this after I wanted graphical buttons
onready var gamefield_graphic

onready var theme_array = [
	ThemePaper,
	ThemeRetro,
	ThemeLeague
]

onready var p1_color_array = [
	P1Red,
	P1Blue,
	P1Green,
	P1Purple,
	P1Yellow,
	P1Pink
]

onready var p2_color_array = [
	P2Red,
	P2Blue,
	P2Green,
	P2Purple,
	P2Yellow,
	P2Pink
]
var anim_index = 0
var paper_ball_array = []
var retro_ball_array = []
var league_ball_array = []
var paper_field_array = []
var retro_field_array = []
var league_field_array = []
var player1_color_index
var player2_color_index
var temp_chosen_gamefield_index
var temp_chosen_theme_index
var temp_chosen_ball_index

const WIGGLE_SPEED = 1



func _ready():
	determine_lock_status()
	check_settings()

	# generate arrays for animation movement
	# finding the path of the node took a long time
	# see https://docs.godotengine.org/en/3.1/classes/class_node.html#class-node-method-get-path
	for n in $Ball/Paper.get_children():
		var _np_index = get_path_to(n)
		var _np_string = str(_np_index) + ":rect_rotation"
		var _np_final_path = NodePath(_np_string)
		paper_ball_array.append(_np_final_path)
		wiggle_buttons(paper_ball_array)
	for n in $Ball/Retro.get_children():
		var _np_index = get_path_to(n)
		var _np_string = str(_np_index) + ":rect_rotation"
		var _np_final_path = NodePath(_np_string)
		retro_ball_array.append(_np_final_path)
		wiggle_buttons(retro_ball_array)
	for n in $Ball/League.get_children():
		var _np_index = get_path_to(n)
		var _np_string = str(_np_index) + ":rect_rotation"
		var _np_final_path = NodePath(_np_string)
		league_ball_array.append(_np_final_path)
		wiggle_buttons(league_ball_array)
	for n in $Field/Paper.get_children():
		var _np_index = get_path_to(n)
		var _np_string = str(_np_index) + ":rect_rotation"
		var _np_final_path = NodePath(_np_string)
		paper_field_array.append(_np_final_path)
		wiggle_buttons(paper_field_array)
	for n in $Field/Retro.get_children():
		var _np_index = get_path_to(n)
		var _np_string = str(_np_index) + ":rect_rotation"
		var _np_final_path = NodePath(_np_string)
		retro_field_array.append(_np_final_path)
		wiggle_buttons(retro_field_array)
	for n in $Field/League.get_children():
		var _np_index = get_path_to(n)
		var _np_string = str(_np_index) + ":rect_rotation"
		var _np_final_path = NodePath(_np_string)
		league_field_array.append(_np_final_path)
		wiggle_buttons(league_field_array)

func wiggle_buttons(asset_array):
	for path in asset_array:
		var _animation_player = AnimationPlayer.new()
		var _animation_string = "animation" + str(anim_index)
		var _wiggle_length = rand_range(1, 2)
		var _wiggle_key_1 = _wiggle_length / 4
		var _wiggle_key_2 = _wiggle_key_1 * 2
		var _wiggle_key_3 = _wiggle_key_1 * 3
		var _wiggle_key_4 = _wiggle_length
		var _wiggle_animation = Animation.new()
		_wiggle_animation.set_length(_wiggle_length)
		_wiggle_animation.add_track(0)
		_wiggle_animation.track_set_path(0, path)
		_wiggle_animation.track_insert_key(0, 0, 0)
		_wiggle_animation.track_insert_key(0, _wiggle_key_1, 15)
		_wiggle_animation.track_insert_key(0, _wiggle_key_2, 0)
		_wiggle_animation.track_insert_key(0, _wiggle_key_3, -15)
		_wiggle_animation.track_insert_key(0, _wiggle_key_4, 0)
		_wiggle_animation.loop = true
		_animation_player.add_animation(_animation_string, _wiggle_animation)
		anim_index += 1
		_animation_player.play(_animation_string)
		add_child(_animation_player)


func determine_lock_status():
	match is_unlocked:
		true:
			ThemeRetro.set_disabled(false)
			ThemeLeague.set_disabled(false)
		false:
			temp_chosen_theme_index = 0
			ThemePaper.set_pressed(true)
			ThemeRetro.set_disabled(true)
			ThemeRetro.set_pressed(false)
			ThemeLeague.set_disabled(true)
			ThemeRetro.set_pressed(false)


func check_settings():
	match SaveSettings.pixel_push_save_data["player_saved_settings"]:
		true: load_player_settings()
		false: load_default_settings()

func load_default_settings():
	player1_color_index = 0
	player2_color_index = 1
	temp_chosen_gamefield_index = 0
	temp_chosen_theme_index = 0
	temp_chosen_ball_index = 0
	flip_theme_choice(0)
	flip_player_color_choice(1,0)
	flip_player_color_choice(2,1)
	# all of these settings are index references for the various arrays
	SaveSettings.pixel_push_save_data["player_saved_settings"] = true
	SaveSettings.pixel_push_save_data["player_last_theme"] = 0
	SaveSettings.pixel_push_save_data["player_last_gamefield"] = 0
	SaveSettings.pixel_push_save_data["player_last_ball"] = 0
	SaveSettings.pixel_push_save_data["player1_last_color"] = 0
	SaveSettings.pixel_push_save_data["player2_last_color"] = 1
	print("default color index")
	print(player1_color_index)
	print(player2_color_index)
	SaveSettings.close_settings_save()



func load_player_settings():
	if is_unlocked:
		temp_chosen_theme_index = SaveSettings.pixel_push_save_data["player_last_theme"]
	if !is_unlocked: temp_chosen_theme_index = 0
	temp_chosen_gamefield_index = SaveSettings.pixel_push_save_data["player_last_gamefield"]
	temp_chosen_ball_index = SaveSettings.pixel_push_save_data["player_last_ball"]
	player1_color_index = SaveSettings.pixel_push_save_data["player1_last_color"]
	player2_color_index = SaveSettings.pixel_push_save_data["player2_last_color"]
	flip_theme_choice(temp_chosen_theme_index)
	flip_player_color_choice(1,player1_color_index)
	flip_player_color_choice(2,player2_color_index)
	print("player color index")
	print(player1_color_index)
	print(player2_color_index)
	save_and_apply_settings()


# this is probably awful, but here goes
func flip_player_color_choice(player,pressed_index):
	match player:
		1:
			for x in p1_color_array.size():
				if x == pressed_index:
					p1_color_array[x].set_pressed(true)
					p2_color_array[x].set_disabled(true)
				else:
					p2_color_array[x].set_disabled(false)
					p1_color_array[x].set_pressed(false)
		2:
			for x in p2_color_array.size():
				if x == pressed_index:
					p2_color_array[x].set_pressed(true)
					p1_color_array[x].set_disabled(true)
				else:
					p1_color_array[x].set_disabled(false)
					p2_color_array[x].set_pressed(false)
	save_and_apply_settings()


# simpler switch statement
func flip_theme_choice(pressed_index):
	if pressed_index != temp_chosen_theme_index:
		temp_chosen_gamefield_index = 0
		temp_chosen_ball_index = 0
		print("switching graphics")
	for x in theme_array.size():
		theme_array[x].set_pressed(true)
		if x != pressed_index:
			theme_array[x].set_pressed(false)
	temp_chosen_theme_index = pressed_index
	save_and_apply_settings()


func show_field_choice():
	$BlockBehind.show()
	$ChoiceBackground.show()
	if ThemePaper.is_pressed():
		FieldPaper.show()
	if ThemeRetro.is_pressed():
		FieldRetro.show()
	if ThemeLeague.is_pressed():
		FieldLeague.show()

func show_ball_choice():
	$BlockBehind.show()
	$ChoiceBackground.show()
	if ThemePaper.is_pressed():
		BallPaper.show()
	if ThemeRetro.is_pressed():
		BallRetro.show()
	if ThemeLeague.is_pressed():
		BallLeague.show()

func hide_choices():
	$BlockBehind.hide()
	FieldPaper.hide()
	FieldRetro.hide()
	FieldLeague.hide()
	BallPaper.hide()
	BallRetro.hide()
	BallLeague.hide()
	$ChoiceBackground.hide()

func save_and_apply_settings():
	SaveSettings.pixel_push_save_data["player_last_theme"] = temp_chosen_theme_index
	SaveSettings.pixel_push_save_data["player_last_gamefield"] = temp_chosen_gamefield_index
	SaveSettings.pixel_push_save_data["player_last_ball"] = temp_chosen_ball_index
	SaveSettings.pixel_push_save_data["player1_last_color"] = player1_color_index
	SaveSettings.pixel_push_save_data["player2_last_color"] = player2_color_index
	SaveSettings.close_settings_save()
	match temp_chosen_theme_index:
		0:
			TC.selected_theme = TC.Themes.PAPER
			match temp_chosen_gamefield_index:
				0:
					TC.selected_gamefield = TC.PaperGamefields.BLUEPRINT
					gamefield_graphic = TC.paper_blueprint_gamefield
				1:
					TC.selected_gamefield = TC.PaperGamefields.CARDBOARD
					gamefield_graphic = TC.paper_cardboard_gamefield
				2:
					TC.selected_gamefield = TC.PaperGamefields.NOTEBOOK
					gamefield_graphic = TC.paper_notebook_gamefield
			match temp_chosen_ball_index:
				0:TC.selected_ball = TC.paper_ball_white_1
				1:TC.selected_ball = TC.paper_ball_grey_1
				2:TC.selected_ball = TC.paper_ball_burnt_red_1
				3:TC.selected_ball = TC.paper_ball_blue_green_1
				4:TC.selected_ball = TC.paper_ball_tan_1
				5:TC.selected_ball = TC.paper_ball_tan_2
				6:TC.selected_ball = TC.paper_ball_white_blue_1
				7:TC.selected_ball = TC.paper_ball_green_1
				8:TC.selected_ball = TC.paper_ball_green_2
				9:TC.selected_ball = TC.paper_ball_notebook_1
				10:TC.selected_ball = TC.paper_ball_notebook_2
				11:TC.selected_ball = TC.paper_ball_notebook_3
				12:TC.selected_ball = TC.paper_ball_notebook_4
				13:TC.selected_ball = TC.paper_ball_notebook_5
				14:TC.selected_ball = TC.paper_ball_notebook_6
				15:TC.selected_ball = TC.paper_ball_brown_1
				16:TC.selected_ball = TC.paper_ball_brown_2
				17:TC.selected_ball = TC.paper_ball_brown_3
			match player1_color_index:
				0: TC.bot_player_selected_color = TC.PaperColors.RED
				1: TC.bot_player_selected_color = TC.PaperColors.BLUE
				2: TC.bot_player_selected_color = TC.PaperColors.GREEN
				3: TC.bot_player_selected_color = TC.PaperColors.PURPLE
				4: TC.bot_player_selected_color = TC.PaperColors.YELLOW
				5: TC.bot_player_selected_color = TC.PaperColors.PINK
			match player2_color_index:
				0: TC.top_player_selected_color = TC.PaperColors.RED
				1: TC.top_player_selected_color = TC.PaperColors.BLUE
				2: TC.top_player_selected_color = TC.PaperColors.GREEN
				3: TC.top_player_selected_color = TC.PaperColors.PURPLE
				4: TC.top_player_selected_color = TC.PaperColors.YELLOW
				5: TC.top_player_selected_color = TC.PaperColors.PINK
		# theme retro
		1:
			TC.selected_theme = TC.Themes.RETRO
			match temp_chosen_gamefield_index:
				0:
					TC.selected_gamefield = TC.RETRO_GAMEFIELD
					gamefield_graphic = TC.RETRO_GAMEFIELD
			match temp_chosen_ball_index:
				0:TC.selected_ball = TC.retro_ball_purple
				1:TC.selected_ball = TC.retro_ball_red
				2:TC.selected_ball = TC.retro_ball_yellow
				3:TC.selected_ball = TC.retro_ball_aqua
			match player1_color_index:
				0:TC.bot_player_selected_color = TC.RetroColors.RED
				1:TC.bot_player_selected_color = TC.RetroColors.BLUE
				2:TC.bot_player_selected_color = TC.RetroColors.GREEN
				3:TC.bot_player_selected_color = TC.RetroColors.PURPLE
				4:TC.bot_player_selected_color = TC.RetroColors.YELLOW
				5:TC.bot_player_selected_color = TC.RetroColors.PINK
			match player2_color_index:
				0:TC.top_player_selected_color = TC.RetroColors.RED
				1:TC.top_player_selected_color = TC.RetroColors.BLUE
				2:TC.top_player_selected_color = TC.RetroColors.GREEN
				3:TC.top_player_selected_color = TC.RetroColors.PURPLE
				4:TC.top_player_selected_color = TC.RetroColors.YELLOW
				5:TC.top_player_selected_color = TC.RetroColors.PINK
		# theme league
		2:
			TC.selected_theme = TC.Themes.LEAGUE
			match temp_chosen_gamefield_index:
				0:
					TC.selected_gamefield = TC.LeagueGamefields.STRIPED_NUMBERS
					gamefield_graphic = TC.league_green_stripe_numbers_gamefield
				1:
					TC.selected_gamefield = TC.LeagueGamefields.STRIPED
					gamefield_graphic = TC.league_green_stripe_gamefield
				2:
					TC.selected_gamefield = TC.LeagueGamefields.GREEN_NUMBERS
					gamefield_graphic = TC.league_green_numbers_gamefield
				3:
					TC.selected_gamefield = TC.LeagueGamefields.GREEN
					gamefield_graphic = TC.league_green_gamefield
			match temp_chosen_ball_index:
				0:TC.selected_ball = TC.league_ball_pro_round
				1:TC.selected_ball = TC.league_ball_pro_triangle
				2:TC.selected_ball = TC.league_ball_college_round
				3:TC.selected_ball = TC.league_ball_college_triangle
			match player1_color_index:
				0:TC.bot_player_selected_color = TC.LeagueColors.RED
				1:TC.bot_player_selected_color = TC.LeagueColors.BLUE
				2:TC.bot_player_selected_color = TC.LeagueColors.GREEN
				3:TC.bot_player_selected_color = TC.LeagueColors.PURPLE
				4:TC.bot_player_selected_color = TC.LeagueColors.YELLOW
				5:TC.bot_player_selected_color = TC.LeagueColors.PINK
			match player2_color_index:
				0:TC.top_player_selected_color = TC.LeagueColors.RED
				1:TC.top_player_selected_color = TC.LeagueColors.BLUE
				2:TC.top_player_selected_color = TC.LeagueColors.GREEN
				3:TC.top_player_selected_color = TC.LeagueColors.PURPLE
				4:TC.top_player_selected_color = TC.LeagueColors.YELLOW
				5:TC.top_player_selected_color = TC.LeagueColors.PINK
	set_field_graphic(gamefield_graphic)
	set_ball_graphic(TC.selected_ball)


func set_field_graphic(graphic):
	ChooseField.set_normal_texture(graphic)
	ChooseField.set_disabled_texture(graphic)
	ChooseField.set_focused_texture(graphic)
	ChooseField.set_hover_texture(graphic)
	ChooseField.set_pressed_texture(graphic)

func set_ball_graphic(graphic):
	ChooseBall.set_normal_texture(graphic)
	ChooseBall.set_disabled_texture(graphic)
	ChooseBall.set_focused_texture(graphic)
	ChooseBall.set_hover_texture(graphic)
	ChooseBall.set_pressed_texture(graphic)


func start_game():
	TC.set_theme_values()
	match Main.current_game_type:
		Main.GameType.VS_2P:
			Main.start_coin_toss_2p()
		Main.GameType.VS_AI:
			Main.start_coin_toss_ai()
	queue_free()
