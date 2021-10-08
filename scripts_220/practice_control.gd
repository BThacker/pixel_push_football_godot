# 2020 Pixel Push Football - Brandon Thacker 

extends Node2D


onready var Main = get_parent()
onready var TouchDownSound =  get_parent().get_node("TouchdownSound")
onready var MenuControl = get_parent().get_node("MenuControl")


func update_practice():
	# some duplicate code is here, but required to isolate as I
	# originally didn't plan on making a practice mode
	Main.can_action_cam = true
	var blue_dead_zone_bodies = Main.get_node("TopDeadZone").get_overlapping_bodies()
	var blue_td_bodies = Main.get_node("TopTd").get_overlapping_bodies()
	if Main.practice_oob:
		MenuControl.practice_stats_update("Out of Bounds", Main.last_distance_moved)
		Main.practice_oob = false
		return
	if blue_td_bodies.size() > 0 and Main.current_ball.position.y > 100:
		Main.play_touchdown_sound()
		MenuControl.practice_stats_update("Touchdown!", Main.last_distance_moved)
		return
	if blue_dead_zone_bodies.size() > 0:
		MenuControl.practice_stats_update("Touchback", Main.last_distance_moved)
		return
	MenuControl.practice_stats_update("Turnover", Main.last_distance_moved)
	return


func randomize_practice_spawn():
	var return_array = [Vector2(), 0]
	var spawn_pos
	var spawn_rotation
	randomize()
	spawn_pos = Vector2(rand_range(50, 670), rand_range(150, 1080))
	spawn_rotation = int(rand_range(1, 360))
	return_array[0] = spawn_pos
	return_array[1] = spawn_rotation
	return return_array
