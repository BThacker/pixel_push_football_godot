# Pixel Push Football - 2020 Brandon Thacker 

extends Node2D#

onready var Customize = get_parent()
onready var Main = get_tree().get_root().get_node("Main")
onready var MenuSelectSound = Main.get_node("MenuSelectSound")

# theme choices
#-------------------------------------------------------------------

func _on_Paper_pressed():
	Customize.flip_theme_choice(0)
	Customize.hide_choices()

func _on_Retro_pressed():
	Customize.flip_theme_choice(1)
	Customize.hide_choices()

func _on_League_pressed():
	Customize.flip_theme_choice(2)
	Customize.hide_choices()


# show ball / field choices

func _on_ChooseField_pressed():
	Customize.show_field_choice()
	Customize.save_and_apply_settings()


func _on_ChooseBall_pressed():
	Customize.show_ball_choice()
	Customize.save_and_apply_settings()

# player 1 color choices
#-----------------------------------------------------------------
func _on_P1Red_pressed():
	Customize.player1_color_index = 0
	Customize.flip_player_color_choice(1,0)
	Customize.hide_choices()

func _on_P1Blue_pressed():
	Customize.player1_color_index = 1
	Customize.flip_player_color_choice(1,1)
	Customize.hide_choices()

func _on_P1Green_pressed():
	Customize.player1_color_index = 2
	Customize.flip_player_color_choice(1,2)
	Customize.hide_choices()

func _on_P1Purple_pressed():
	Customize.player1_color_index = 3
	Customize.flip_player_color_choice(1,3)
	Customize.hide_choices()


func _on_P1Yellow_pressed():
	Customize.player1_color_index = 4
	Customize.flip_player_color_choice(1,4)
	Customize.hide_choices()

func _on_P1Pink_pressed():
	Customize.player1_color_index = 5
	Customize.flip_player_color_choice(1,5)
	Customize.hide_choices()



# player 2 color choices
func _on_P2Red_pressed():
	Customize.player2_color_index = 0
	Customize.flip_player_color_choice(2,0)
	Customize.hide_choices()

func _on_P2Blue_pressed():
	Customize.player2_color_index = 1
	Customize.flip_player_color_choice(2,1)
	Customize.hide_choices()

func _on_P2Green_pressed():
	Customize.player2_color_index = 2
	Customize.flip_player_color_choice(2,2)
	Customize.hide_choices()

func _on_P2Purple_pressed():
	Customize.player2_color_index = 3
	Customize.flip_player_color_choice(2,3)
	Customize.hide_choices()

func _on_P2Yellow_pressed():
	Customize.player2_color_index = 4
	Customize.flip_player_color_choice(2,4)
	Customize.hide_choices()

func _on_P2Pink_pressed():
	Customize.player2_color_index = 5
	Customize.flip_player_color_choice(2,5)
	Customize.hide_choices()


# paper ball selection
#-----------------------------------------------------------------
func _on_paper_ball_white_1_pressed():
	Customize.temp_chosen_ball_index = 0
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_grey_1_pressed():
	Customize.temp_chosen_ball_index = 1
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_burnt_red_1_pressed():
	Customize.temp_chosen_ball_index = 2
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_blue_green_1_pressed():
	Customize.temp_chosen_ball_index = 3
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_tan_1_pressed():
	Customize.temp_chosen_ball_index = 4
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_tan_2_pressed():
	Customize.temp_chosen_ball_index = 5
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_white_blue_1_pressed():
	Customize.temp_chosen_ball_index = 6
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_green_1_pressed():
	Customize.temp_chosen_ball_index = 7
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_green_2_pressed():
	Customize.temp_chosen_ball_index = 8
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_notebook_1_pressed():
	Customize.temp_chosen_ball_index = 9
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_notebook_2_pressed():
	Customize.temp_chosen_ball_index = 10
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_notebook_3_pressed():
	Customize.temp_chosen_ball_index = 11
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_notebook_4_pressed():
	Customize.temp_chosen_ball_index = 12
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_notebook_5_pressed():
	Customize.temp_chosen_ball_index = 13
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_notebook_6_pressed():
	Customize.temp_chosen_ball_index = 14
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_brown_1_pressed():
	Customize.temp_chosen_ball_index = 15
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_brown_2_pressed():
	Customize.temp_chosen_ball_index = 16
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_ball_brown_3_pressed():
	Customize.temp_chosen_ball_index = 16
	Customize.hide_choices()
	Customize.save_and_apply_settings()


# retro balls
#----------------------------------------------------------------
func _on_retro_ball_purple_pressed():
	Customize.temp_chosen_ball_index = 0
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_retro_ball_red_pressed():
	Customize.temp_chosen_ball_index = 1
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_retro_ball_yellow_pressed():
	Customize.temp_chosen_ball_index = 2
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_retro_ball_aqua_pressed():
	Customize.temp_chosen_ball_index = 3
	Customize.hide_choices()
	Customize.save_and_apply_settings()





# paper gamefield
#-----------------------------------------------------------------
func _on_paper_blueprint_gamefield_pressed():
	Customize.temp_chosen_gamefield_index = 0
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_cardboard_gamefield_pressed():
	Customize.temp_chosen_gamefield_index = 1
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_paper_notebook_gamefield_pressed():
	Customize.temp_chosen_gamefield_index = 2
	Customize.hide_choices()
	Customize.save_and_apply_settings()


# retro gamefield
#-----------------------------------------------------------------
func _on_retro_gamefield_pressed():
	Customize.hide_choices()
	Customize.save_and_apply_settings()



# league gamefield
#-----------------------------------------------------------------
func _on_league_green_stripe_numbers_gamefield_pressed():
	Customize.temp_chosen_gamefield_index = 0
	Customize.hide_choices()


func _on_league_green_stripe_gamefield_pressed():
	Customize.temp_chosen_gamefield_index = 1
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_league_green_numbers_gamefield_pressed():
	Customize.temp_chosen_gamefield_index = 2
	Customize.hide_choices()
	Customize.save_and_apply_settings()


func _on_league_green_gamefield_pressed():
	Customize.temp_chosen_gamefield_index = 3
	Customize.hide_choices()
	Customize.save_and_apply_settings()




# league balls

func _on_league_ball_pro_round_pressed():
	Customize.temp_chosen_ball_index = 0
	Customize.hide_choices()
	Customize.save_and_apply_settings()

func _on_league_ball_pro_triangle_pressed():
	Customize.temp_chosen_ball_index = 1
	Customize.hide_choices()
	Customize.save_and_apply_settings()

func _on_league_ball_college_round_pressed():
	Customize.temp_chosen_ball_index = 2
	Customize.hide_choices()
	Customize.save_and_apply_settings()

func _on_league_ball_college_triangle_pressed():
	Customize.temp_chosen_ball_index = 3
	Customize.hide_choices()
	Customize.save_and_apply_settings()


# exit
func _on_Button_pressed():
	get_tree().reload_current_scene()


func _on_StartGame_pressed():
	MenuSelectSound.play()
	Customize.save_and_apply_settings()
	Customize.start_game()

