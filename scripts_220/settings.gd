# 2020 Pixel Push Football - Brandon Thacker 
# Stores, saves and loads game Settings in an ini-style file
extends Node

var pixel_push_save_data = {
	"blue_touch_force": 2,
	"is_blue_pointer_offset": true,
	"red_touch_force": 2,
	"is_red_pointer_offset": true,
	"is_retro_mode": false,
	"is_google_play": true,
	"is_full_game_unlocked": true,
	"is_small_screen": true,
	"unlicensed_remaining": 9999,
	"two_minute_drill_high_score": 0,
	"field_goal_frenzy_high_score": 0,
	"shred_the_defense_high_score": 0,
	"player_saved_settings": false,
	"player_last_theme": 0,
	"player_last_gamefield": 0,
	"player_last_ball": 0,
	"player1_last_color": 0,
	"player2_last_color":0,
	"gameplay_music": true
 }

var BracketData = {
	"ai_difficulty":"",
	"game_length":"",
	"randomize_kickoff":"",
	"active_tournament": false,
	"seed_order": [0,1,2,3,4,5],
	"ai_players": [0,0,0,0,0,0],
	"games_completed": 0,
	"game_1_p1":"",
	"game_1_p1_color":"",
	"game_1_p1_score":"",
	"game_1_p2":"",
	"game_1_p2_color":"",
	"game_1_p2_score":"",
	"game_1_winner":"",
	"game_2_p1":"",
	"game_2_p1_color":"",
	"game_2_p1_score":"",
	"game_2_p2":"",
	"game_2_p2_color":"",
	"game_2_p2_score":"",
	"game_2_winner":"",
	"game_3_p1":"",
	"game_3_p1_color":"",
	"game_3_p1_score":"",
	"game_3_p2":"",
	"game_3_p2_color":"",
	"game_3_p2_score":"",
	"game_3_winner":"",
	"game_4_p1":"",
	"game_4_p1_color":"",
	"game_4_p1_score":"",
	"game_4_p2":"",
	"game_4_p2_color":"",
	"game_4_p2_score":"",
	"game_4_winner":"",
	"game_5_p1":"",
	"game_5_p1_color":"",
	"game_5_p1_score":"",
	"game_5_p2":"",
	"game_5_p2_color":"",
	"game_5_p2_score":"",
	"game_5_winner":"",
	"next_game_team_1":"",
	"next_game_team_2":"",
	"last_game_winner":"",
	"last_game_winner_score":"",
	"last_game_loser":"",
	"last_game_loser_score":"",
	"last_index_flipped": false
}
var reset_times = 0

# save_play_data("user://pixel_push_save.data", pixel_push_save_data)


#func save_play_data(path, data):
#	var f = File.new()
#	f.open(path, File.WRITE)
#	f.store_var(data)
#	f.close()


# rewrite below so we can encrypt the locked game
# var f = File.new()
# var err = f.open_encrypted_with_pass("user://savedata.bin", File.WRITE, OS.get_unique_id())
# f.store_var(game_state)
# f.close()

func _ready():
	check_save_state_main("user://pixel_push_save_release_3.data")
	check_save_state_tournament("user://pixel_push_tournament_3.data")
	pixel_push_save_data = load_play_data("user://pixel_push_save_release_3.data")
	BracketData = load_play_data("user://pixel_push_tournament_3.data")


func close_settings_save():
	var f = File.new()
	f.open("user://pixel_push_save_release_3.data", File.WRITE)
	f.store_var(pixel_push_save_data)
	f.close()

func tournament_save():
	var f = File.new()
	f.open("user://pixel_push_tournament_3.data", File.WRITE)
	f.store_var(BracketData)
	f.close()

func reset_tournament_vars():
	BracketData = {
		"ai_difficulty":"",
		"game_length":"",
		"randomize_kickoff":"",
		"active_tournament": false,
		"seed_order": [0,1,2,3,4,5],
		"ai_players": [0,0,0,0,0,0],
		"games_completed": 0,
		"game_1_p1":"",
		"game_1_p1_color":"",
		"game_1_p1_score":"",
		"game_1_p2":"",
		"game_1_p2_color":"",
		"game_1_p2_score":"",
		"game_1_winner":"",
		"game_2_p1":"",
		"game_2_p1_color":"",
		"game_2_p1_score":"",
		"game_2_p2":"",
		"game_2_p2_color":"",
		"game_2_p2_score":"",
		"game_2_winner":"",
		"game_3_p1":"",
		"game_3_p1_color":"",
		"game_3_p1_score":"",
		"game_3_p2":"",
		"game_3_p2_color":"",
		"game_3_p2_score":"",
		"game_3_winner":"",
		"game_4_p1":"",
		"game_4_p1_color":"",
		"game_4_p1_score":"",
		"game_4_p2":"",
		"game_4_p2_color":"",
		"game_4_p2_score":"",
		"game_4_winner":"",
		"game_5_p1":"",
		"game_5_p1_color":"",
		"game_5_p1_score":"",
		"game_5_p2":"",
		"game_5_p2_color":"",
		"game_5_p2_score":"",
		"game_5_winner":"",
		"next_game_team_1":"",
		"next_game_team_2":"",
		"last_game_winner":"",
		"last_game_winner_score":"",
		"last_game_loser":"",
		"last_game_loser_score":"",
		"last_index_flipped": false
	}
	tournament_save()

func load_play_data(path):
	var f = File.new()
	if f.file_exists(path):
		f.open(path, File.READ)
		var data = f.get_var()
		f.close()
		return data
	return null

func check_save_state_tournament(path):
	var f = File.new()
	if f.file_exists(path):
		return;
	else:
		tournament_save()

func check_save_state_main(path):
	var f = File.new()
	if f.file_exists(path):
		return;
	else:
		close_settings_save()

func increment_reset_times():
	reset_times += 1
