# 2020 Pixel Push Football - Brandon Thacker 
extends Node2D

export (PackedScene) var fat_boy
export (PackedScene) var med_boy
export (PackedScene) var small_boy
export (PackedScene) var reciever
export (PackedScene) var field_goal_kick

const two_minute_drill_spawn_locations_1 = [
	Vector2(276,234),
	Vector2(276,342),
	Vector2(276,450),
	Vector2(276,558),
	Vector2(276,666),
	Vector2(276,774),
	Vector2(276,882),
	Vector2(276,990),
	Vector2(276,1098),

]
const two_minute_drill_spawn_locations_2 = [
	Vector2(445,234),
	Vector2(445,342),
	Vector2(445,450),
	Vector2(445,558),
	Vector2(445,666),
	Vector2(445,774),
	Vector2(445,882),
	Vector2(445,990),
	Vector2(445,1098),

]
enum ChallengeType {
	TWO_MINUTE_DRILL,
	FOUR_DOWN_LADDER,
	SHRED_THE_DEFENSE,
	FGF
}
enum DefenseBoy {
	FAT_BOY1,
	FAT_BOY2,
	FAT_BOY3,
	FAT_BOY4,
	RECEIVER
}
enum Diffculty {
	EASY,
	MEDIUM,
	HARD
}
enum Directions {
	UP,
	DOWN
}

onready var Main = get_parent()
onready var MenuControl = Main.get_node("MenuControl")
onready var StatControl = Main.get_node("StatControl")
onready var TopTd = Main.get_node("TopTd")
onready var BotTd = Main.get_node("BotTd")
onready var FgMachine = Main.get_node("Gamefield/TopFgMachine")
onready var ThemeControl = Main.get_node("ThemeControl")
onready var OobRight = Main.get_node("OobRight")
onready var OobLeft = Main.get_node("OobLeft")

var current_challenge_type
var spawn_rotation
var spawn_position
var _timer
var two_minute_drill = false
var two_minute_drill_score = 0
var two_minute_drill_last_position
var two_minute_drill_next_position_index = 0
var two_minute_drill_direction
var two_minute_drill_last_position_index = 0
var two_minute_success
var two_minute_drill_last_rotation
var current_fgf
var ball_spawn_pos
var ball_rotation
var current_level = 1
var shred_the_defense
var shred_the_defense_success = false
var shred_the_defense_current_down = 1
var std_timer
var defense_active = []
var current_reciever
var current_difficulty
var tmd_timer

func _physics_process(_delta):
	if two_minute_drill:
		MenuControl.update_two_minute_drill_score_timer()
	if shred_the_defense:
		MenuControl.update_shred_the_defense_ui()


func _ready():
	$ShredTimer.connect("timeout",self, "shred_the_defense_timer_expire")

func start_two_minute_drill():
	MenuControl.PracticeChallengeMusic.play()
	randomize()
	Main.can_glow = true
	MenuControl.PracticeChallengeMusic.play()
	StatControl.reset_two_minute_drill_stats()
	Main.get_node("GameStartSound").play()
	current_challenge_type = ChallengeType.TWO_MINUTE_DRILL
	var left_right = int(rand_range(1,3))
	match left_right:
		1:
			ball_rotation = 135
			ball_spawn_pos = two_minute_drill_spawn_locations_1[0]
		2:
			ball_rotation = -135
			ball_spawn_pos = two_minute_drill_spawn_locations_2[0]
	Main.add_ball(ball_spawn_pos,ball_rotation)
	Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)
	two_minute_drill_direction = Directions.DOWN
	two_minute_drill_last_position = ball_spawn_pos
	two_minute_drill_last_position_index = 0
	two_minute_drill_next_position_index = 0
	two_minute_drill_last_rotation = ball_rotation
	two_minute_drill = true
	two_minute_drill_timer()


func update_two_minute_drill():
	randomize()
	var left_right = int(rand_range(1,3))
	StatControl.challenge_stats.two_minute_drill_shot_attempts += 1
	two_minute_success = evaluate_two_minute_drill_result()
	if two_minute_success:
		match two_minute_drill_direction:
			Directions.UP:
				if two_minute_drill_last_position_index == 0:
					two_minute_drill_next_position_index += 1
					two_minute_drill_direction = Directions.DOWN
				else:
					two_minute_drill_next_position_index -= 1
			Directions.DOWN:
				if two_minute_drill_last_position_index == 8:
					two_minute_drill_next_position_index = 7
					two_minute_drill_direction = Directions.UP
				else:
					two_minute_drill_next_position_index += 1
		match left_right:
			1:
				spawn_position = two_minute_drill_spawn_locations_1[two_minute_drill_next_position_index]
				ball_rotation = 135
				two_minute_drill_last_rotation = ball_rotation
			2:
				spawn_position = two_minute_drill_spawn_locations_2[two_minute_drill_next_position_index]
				ball_rotation = -135
				two_minute_drill_last_rotation = ball_rotation
	if !two_minute_success:
		spawn_position = two_minute_drill_last_position
		ball_rotation = two_minute_drill_last_rotation
	two_minute_drill_last_position_index = two_minute_drill_next_position_index
	two_minute_drill_last_position= spawn_position
	Main.add_ball(spawn_position,ball_rotation)
	Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)


func two_minute_drill_timer():
	tmd_timer = $TwoMinuteTimer
	add_child(_timer)
	$TwoMinuteTimer.connect("timeout",self, "end_two_minute_drill")
	$TwoMinuteTimer.set_wait_time(120)
	$TwoMinuteTimer.set_one_shot(true)
	$TwoMinuteTimer.start()


func end_two_minute_drill():
	two_minute_drill = false
	MenuControl.show_two_minute_drill_results()
	$TwoMinuteTimer.stop()
	if is_instance_valid(Main.current_ball):
		Main.remove_ball()


func evaluate_two_minute_drill_result():
	var _TopTd = Main.get_node("TopTd").get_overlapping_bodies()
	if Main.challenge_oob:
		Main.challenge_oob = false
		return false
	if _TopTd.size() > 0 and Main.current_ball.position.y > 100:
		Main.play_touchdown_sound()
		StatControl.challenge_stats.two_minute_drill_score += 1
		return true
	return false


# shred the defense specific ----------------------------------------------------------------------------------


func start_shred_the_defense():
	Main.get_node("GameStartSound").play()
	MenuControl.PracticeChallengeMusic.play()
	randomize()
	StatControl.reset_shred_the_defense_stats()
	defense_active.clear()
	if is_instance_valid(current_reciever):
		current_reciever.queue_free()
	Main.can_glow = false
	shred_the_defense = true
	shred_the_defense_current_down = 1
	StatControl.challenge_stats.shred_the_defense_score = 0
	MenuControl.update_shred_the_defense_ui()
	current_challenge_type = ChallengeType.SHRED_THE_DEFENSE
	var rc
	var _spawn_array = randomize_shred_the_defense_spawn()
	Main.add_ball(_spawn_array[0],_spawn_array[1])
	Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)
	defense_active.resize(1)

	for s in defense_active.size():
		defense_active[s] = fat_boy.instance()
		defense_active[s].start(randomize_boy_spawn(s))
		add_child(defense_active[s])

	rc = reciever.instance()
	current_reciever = rc
	add_child(rc)
	rc.start(randomize_boy_spawn(int(rand_range(7,10))))
	shred_the_defense_timer()


func shred_the_defense_timer():

	# how often we want the AI to respond to information
	$ShredTimer.set_wait_time(8)
	$ShredTimer.set_one_shot(true)
	std_timer = $ShredTimer
	$ShredTimer.start()


func delete_timer_ball_contact():
	if is_instance_valid(std_timer):
		std_timer.stop()


func shred_the_defense_timer_expire():
	# basic logic for now, anything complex we can add later
	Main.get_node("FailSound").play()
	update_shred_the_defense()


func update_shred_the_defense():
	Main.remove_ball()
	StatControl.challenge_stats.shred_the_defense_attempts += 1
	for def in defense_active:
		def.queue_free()
	if is_instance_valid(std_timer):
		std_timer.stop()
	if evaluate_shred_the_defense_result():
		return
	shred_the_defense_timer()
	# reset the flag
	shred_the_defense_success = false
	MenuControl.update_shred_the_defense_ui()
	# here we get harder as the game progresses
	match StatControl.challenge_stats.shred_the_defense_score:
		3: defense_active.resize(2)
		6: defense_active.resize(3)
		9: defense_active.resize(4)
		12: defense_active.resize(5)
		20: defense_active.resize(6)
		30: defense_active.resize(7)
	var rc
	for s in defense_active.size():
		defense_active[s] = fat_boy.instance()
		defense_active[s].start(randomize_boy_spawn(s))
		add_child(defense_active[s])
	var _spawn_array = randomize_shred_the_defense_spawn()
	Main.add_ball(_spawn_array[0], _spawn_array[1])
	Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)
	current_reciever.queue_free()
	rc = reciever.instance()
	add_child(rc)
	current_reciever = rc
	rc.start(randomize_boy_spawn(int(rand_range(7,10))))


func evaluate_shred_the_defense_result():
	if shred_the_defense_success:
		StatControl.challenge_stats.shred_the_defense_score += 1
		shred_the_defense_current_down = 1
	# temp logic before adding timer
	if !shred_the_defense_success and shred_the_defense_current_down == 4:
		end_shred_the_defense()
		return true
	if !shred_the_defense_success and shred_the_defense_current_down < 4:
		shred_the_defense_current_down += 1


func end_shred_the_defense():
	Main.get_node("FailSound").play()
	shred_the_defense = false
	if is_instance_valid(current_reciever):
		current_reciever.queue_free()
	MenuControl.show_shred_the_defense_results()
	std_timer.stop()
	for s in defense_active.size():
		defense_active[s].queue_free()
	if is_instance_valid(Main.current_ball):
		Main.remove_ball()
	# GPGS



func randomize_shred_the_defense_spawn():
	var return_array = [Vector2(), 0]
	var spawn_pos
	var local_spawn_rotation
	randomize()
	spawn_pos = Vector2(rand_range(150, 570), rand_range(700, 1020))
	local_spawn_rotation = int(rand_range(1, 360))
	return_array[0] = spawn_pos
	return_array[1] = local_spawn_rotation
	return return_array


func randomize_boy_spawn(npc):
	randomize()
	var spawn_pos = Vector2()
	match npc:
		# enemy spawn
		0: spawn_pos = Vector2(rand_range(25, 695), 616)
		1: spawn_pos = Vector2(rand_range(25, 695), 506)
		2: spawn_pos = Vector2(rand_range(25, 695), 396)
		3: spawn_pos = Vector2(rand_range(25, 695), 286)
		4: spawn_pos = Vector2(rand_range(25, 695), 176)
		5: spawn_pos = Vector2(rand_range(25, 695), 556)
		6: spawn_pos = Vector2(rand_range(25, 695), 446)
		#reciever spawn
		7: spawn_pos = Vector2(rand_range(25, 695), 125)
		8: spawn_pos = Vector2(rand_range(25, 695), 235)
		9: spawn_pos = Vector2(rand_range(25, 695), 345)
	randomize()
	return spawn_pos

# field goal frenzy specific-----------------------------------------------------
func start_field_goal_frenzy():
	Main.get_node("GameStartSound").play()
	MenuControl.PracticeChallengeMusic.play()
	StatControl.challenge_stats.fgf_score = 0
	if is_instance_valid(current_fgf):
		current_fgf.queue_free()
	current_challenge_type = ChallengeType.FGF
	MenuControl.show_fgf_gameplay()
	var fgf
	var position_offset
	MenuControl.start_game_transition()
	BotTd.hide()
	TopTd.hide()
	Main.can_glow = false
	Main.can_pause = true
	MenuControl.update_fgf()
	#ThemeControl.apply_fg_background(Main.Turn.CHALLENGE_PRACTICE)
	BotTd.set_process(false)
	TopTd.set_process(false)
	OobRight.set_block_signals(true)
	OobLeft.set_block_signals(true)
	fgf = field_goal_kick.instance()
	var _fg_sprite = fgf.get_node("GoalPostBottom")
	var _fg_sprite1 = fgf.get_node("GoalPostTop")
	_fg_sprite.set_texture(ThemeControl.fgf_post2)
	_fg_sprite1.set_texture(ThemeControl.fgf_post1)
	position_offset = Main.get_node("TeamTop20Yd").position
	ball_spawn_pos = Main.get_node("TeamBot20Yd").position
	ball_rotation = 90
	Main.add_ball(ball_spawn_pos,ball_rotation)
	Main.current_ball.is_field_goal_kick = true
	Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)
	position_offset.y -= 25
	fgf.position = position_offset
	fgf.field_goal_frenzy = true
	FgMachine.show()
	add_child(fgf)
	fgf.start(current_level)
	current_fgf = fgf


func update_field_goal_frenzy():
	MenuControl.start_game_transition()
	if current_fgf.successful_kick and Main.current_ball.position.y < 185:
		Main.play_touchdown_sound()
		StatControl.challenge_stats.fgf_score += 1
		MenuControl.update_fgf()
	if !current_fgf.successful_kick or Main.current_ball.position.y > 185:
		end_field_goal_frenzy()
		return
	match StatControl.challenge_stats.fgf_score:
		3: current_level = 2
		6: current_level = 3
		9: current_level = 4
		12: current_level = 5
		15: current_level = 5
	var fgf
	var position_offset
	BotTd.hide()
	TopTd.hide()
	Main.can_glow = false
	current_fgf.queue_free()
	#ThemeControl.apply_fg_background(Main.Turn.CHALLENGE_PRACTICE)
	BotTd.set_process(false)
	TopTd.set_process(false)
	OobRight.set_block_signals(true)
	OobLeft.set_block_signals(true)
	fgf = field_goal_kick.instance()
	position_offset = Main.get_node("TeamTop20Yd").position
	ball_spawn_pos = Main.get_node("TeamBot20Yd").position
	ball_rotation = 90
	Main.add_ball(ball_spawn_pos,ball_rotation)
	Main.current_ball.is_field_goal_kick = true
	Main.current_ball.set_turn(Main.current_ball.Turn.CHALLENGE_PRACTICE)
	var _fg_sprite = fgf.get_node("GoalPostBottom")
	var _fg_sprite1 = fgf.get_node("GoalPostTop")
	FgMachine.show()
	_fg_sprite.set_texture(ThemeControl.fgf_post2)
	_fg_sprite1.set_texture(ThemeControl.fgf_post1)
	position_offset.y -= 25
	fgf.position = position_offset
	fgf.field_goal_frenzy = true
	add_child(fgf)
	current_fgf = fgf
	fgf.start(current_level)



func end_field_goal_frenzy():
	Main.get_node("FailSound").play()
	current_level = 1
	current_fgf.queue_free()
	MenuControl.show_fgf_results()
