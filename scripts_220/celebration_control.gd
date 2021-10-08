# 2020 Pixel Push Football - Brandon Thacker 

extends Node2D


onready var ball_explosion = [
	$BallExplosion,
	$BallExplosion2,
	$BallExplosion3
]

onready var Main = get_parent()
onready var GameCamera = Main.get_node("GameCamera")
onready var TC = Main.get_node("ThemeControl")

var timers = []

func celebrate_touchdown():
	randomize()
	GameCamera.shake_camera()
	var _wait_time = 1.5
	var td1x = rand_range(100,620)
	var td1y = rand_range(540,740)
	var td2x = rand_range(100,620)
	var td2y = rand_range(540,740)
	var td3x = rand_range(100,620)
	var td3y = rand_range(540,740)
	var td4x = rand_range(100,620)
	var td4y = rand_range(540,740)
	var touchdown1_position = Vector2(td1x, td1y)
	var touchdown2_position = Vector2(td2x,td2y)
	var touchdown3_position = Vector2(td3x,td3y)
	var touchdown4_position = Vector2(td4x,td4y)
	var _local_ball = Main.current_ball
	for be in ball_explosion:
		be.position = Main.current_ball.position
	$BallExplosion2.color = color_match_ball(1)
	$BallExplosion.color = color_match_ball(2)
	$BallExplosion3.color = color_match_ball(3)
	match _local_ball.current_turn:
		_local_ball.Turn.AI, _local_ball.Turn.TOP:
			$Touchdown3PlayerColor.color = TC.top_color_code
		_local_ball.Turn.BOT:
			$Touchdown3PlayerColor.color = TC.bot_color_code
		Main.Turn.CHALLENGE_PRACTICE:
			pass

	for be in ball_explosion:
		be.emitting = true
	$BallExplosionSound.play()

	$Touchdown1.position = touchdown1_position
	$Touchdown2.position = touchdown2_position
	$Touchdown3PlayerColor.position = touchdown3_position
	$Touchdown4.position = touchdown4_position
	timers.resize(4)
	for t in range(4):
		timers[t] = Timer.new()
		add_child(timers[t])
		timers[t].set_one_shot(true)
		timers[t].set_wait_time(_wait_time)
		timers[t].start()
		_wait_time += .4
	timers[0].connect("timeout",self, "td1_timeout")
	timers[1].connect("timeout",self, "td2_timeout")
	timers[3].connect("timeout",self, "td3_timeout")
	timers[2].connect("timeout",self, "td4_timeout")

func celebrate_2pt():
	GameCamera.shake_camera()
	$BallExplosion2.color = color_match_ball(1)
	$BallExplosion.color = color_match_ball(2)
	$BallExplosion3.color = color_match_ball(3)
	var _local_ball = Main.current_ball
	for be in ball_explosion:
		be.position = Main.current_ball.position
	for be in ball_explosion:
		be.emitting = true
	$BallExplosionSound.play()


func td1_timeout():
	$Touchdown1.emitting = true
	$FireworkSound1.play()


func td2_timeout():
	$Touchdown2.emitting = true
	$FireworkSound2.play()


func td3_timeout():
	$Touchdown3PlayerColor.emitting = true
	$FireworkSound3.play()


func td4_timeout():
	$Touchdown4.emitting = true
	$FireworkSound4.play()


func color_match_ball(zone):
	match TC.selected_ball:
		# paper ball
		TC.paper_ball_white_1:
			match zone:
				1: return Color(1,1,1)
				2: return Color(.7,.72,.82)
				3: return Color(.7,.72,.82)
		TC.paper_ball_grey_1:
			match zone:
				1: return Color(.7,.73,.82)
				2: return Color(.29,.33,.38)
				3: return Color(1,1,1)
		TC.paper_ball_burnt_red_1:
			match zone:
				1: return Color(.98,.84,.72)
				2: return Color(.91,.42,.45)
				3: return Color(1,.95,.75)
		TC.paper_ball_blue_green_1:
			match zone:
				1: return Color(.52,.61,.89)
				2: return Color(.14,.4,.31)
				3: return Color(.35,.55,.75)
		TC.paper_ball_tan_1:
			match zone:
				1: return Color(.47,.4,.33)
				2: return Color(.78,.69,.55)
				3: return Color(1,1,1)
		TC.paper_ball_tan_2:
			match zone:
				1: return Color(.47,.4,.33)
				2: return Color(.78,.69,.55)
				3: return Color(1,1,1)
		TC.paper_ball_white_blue_1:
			match zone:
				1: return Color(1,1,1)
				2: return Color(.89,.9,.1)
				3: return Color(.89,.9,.1)
		TC.paper_ball_green_1:
			match zone:
				1: return Color(.39,.71,.58)
				2: return Color(.14,.4,.31)
				3: return Color(.57,.86,.73)
		TC.paper_ball_green_2:
			match zone:
				1: return Color(.1,.48,.24)
				2: return Color(.14,.32,.23)
				3: return Color(.08,.63,.18)
		TC.paper_ball_notebook_1,TC.paper_ball_notebook_2,TC.paper_ball_notebook_3,TC.paper_ball_notebook_4,TC.paper_ball_notebook_5,TC.paper_ball_notebook_6:
			match zone:
				1: return Color(1,1,1)
				2: return Color(.52,.61,.89)
				3: return Color(.74,.29,.61)
		TC.paper_ball_brown_1:
			match zone:
				1: return Color(.44,.25,.23)
				2: return Color(.13,.11,.1)
				3: return Color(.2,.17,.16)
		TC.paper_ball_brown_2:
			match zone:
				1: return Color(.73,.46,.28)
				2: return Color(.2,.17,.16)
				3: return Color(.44,.25,.23)
		TC.paper_ball_brown_3:
			match zone:
				1: return Color(.91,.71,.64)
				2: return Color(.56,.32,.32)
				3: return Color(.56,.32,.32)
		# retro ball
		TC.retro_ball_purple:
			match zone:
				1: return Color(.74,.29,.61)
				2: return Color(.25,.2,.33)
				3: return Color(.98,.64,.11)
		TC.retro_ball_red:
			match zone:
				1: return Color(.87,.24,.14)
				2: return Color(.45,.09,.18)
				3: return Color(.98,.64,.11)
		TC.retro_ball_yellow:
			match zone:
				1: return Color(1,.84,.25)
				2: return Color(.98,.42,.04)
				3: return Color(1,.98,.89)
		TC.retro_ball_aqua:
			match zone:
				1: return Color(.65,.99,.86)
				2: return Color(.14,.62,.87)
				3: return Color(1,1,1)
		# league ball
		TC.league_ball_pro_round, TC.league_ball_pro_triangle, TC.league_ball_college_round, TC.league_ball_college_triangle:
			match zone:
				1: return Color(.44,.25,.23)
				2: return Color(.2,.17,.16)
				3: return Color(1,.95,.75)


