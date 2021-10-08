# Pixel Push Football - 2020 Brandon Thacker 

# Stores, saves and loads game Settings in an ini-style file
extends Node

var pixel_push_save_data = {
	"blue_touch_force": 2,
	"is_blue_pointer_offset": true,
	"red_touch_force": 2,
	"is_red_pointer_offset": true,
	"is_retro_mode": false,
	"is_google_play": false,
	"is_full_game_unlocked": true,
	"unlicensed_remaining": 499,
	"two_minute_drill_high_score": 0,
	"field_goal_frenzy_high_score": 0,
	"shred_the_defense_high_score": 0,
	"player_saved_settings": false,
	"player_last_theme": 0,
	"player_last_gamefield": 0,
	"player_last_ball": 0,
	"player1_last_color": 0,
	"player2_last_color":0
 }


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
	check_save_state("user://pixel_push_save_b33.data")
	pixel_push_save_data = load_play_data("user://pixel_push_save_b33.data")


func close_settings_save():
	var f = File.new()
	f.open_encrypted_with_pass("user://pixel_push_save_b33.data", File.WRITE, OS.get_unique_id())
	f.store_var(pixel_push_save_data)
	f.close()


func load_play_data(path):
	var f = File.new()
	if f.file_exists(path):
		f.open_encrypted_with_pass(path, File.READ, OS.get_unique_id())
		var data = f.get_var()
		f.close()
		return data
	return null


func check_save_state(path):
	var f = File.new()
	if f.file_exists(path):
		return;
	else:
		close_settings_save()
