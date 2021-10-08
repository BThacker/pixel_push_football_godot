# Pixel Push Football - 2020 Brandon Thacker  

extends Node2D

export (PackedScene) var Defender

onready var Main = get_parent()

var four_three = [
	Vector2(-312, -48),
	Vector2(-104, -35),
	Vector2(165, -241),
	Vector2(-163, -213),
	Vector2(305, -43),
	Vector2(61, -93),
	Vector2(-4, -96),
	Vector2(-70, -96),
	Vector2(90, -38),
	Vector2(21, -37),
	Vector2(-41, -37)
]
var three_four = [
	Vector2(-307, -53),
	Vector2(-84, -45),
	Vector2(1, -46),
	Vector2(80, -46),
	Vector2(319, -49),
	Vector2(-148, -81),
	Vector2(-46, -116),
	Vector2(51, -116),
	Vector2(137, -81),
	Vector2(-210, -242),
	Vector2(227, -252)
]
var nickel = [
	Vector2(-307, -53),
	Vector2(-105, -43),
	Vector2(-36, -42),
	Vector2(28, -40),
	Vector2(96, -40),
	Vector2(299, -43),
	Vector2(-55, -119),
	Vector2(67, -119),
	Vector2(7, -245),
	Vector2(-189, -243),
	Vector2(222, -240)
]

var quarter = [
	Vector2(-298, -46),
	Vector2(2, -127),
	Vector2(-87, -41),
	Vector2(2, -42),
	Vector2(96, -41),
	Vector2(299, -43),
	Vector2(-240, -137),
	Vector2(247, -137),
	Vector2(1, -242),
	Vector2(-171, -236),
	Vector2(203, -239)
]

var gap_left = [
	Vector2(-298, -46),
	Vector2(96, -136),
	Vector2(81, -41),
	Vector2(10, -41),
	Vector2(40, -212),
	Vector2(299, -43),
	Vector2(-262, -95),
	Vector2(247, -137),
	Vector2(164, -232),
	Vector2(-223, -143),
	Vector2(153, -40)
]

var gap_right = [
	Vector2(-298, -46),
	Vector2(-130, -243),
	Vector2(-74, -37),
	Vector2(-155, -38),
	Vector2(-109, -113.122002),
	Vector2(309, -45.153702),
	Vector2(-249, -134),
	Vector2(269, -111.629997),
	Vector2(240, -176),
	Vector2(-193, -195),
	Vector2(2, -41)
]
var gap_middle = [
	Vector2(-298, -46),
	Vector2(-199, -240),
	Vector2(2, -52),
	Vector2(-127, -250),
	Vector2(233, -244),
	Vector2(317, -53),
	Vector2(-264, -117),
	Vector2(290, -116),
	Vector2(258, -184),
	Vector2(-230, -176),
	Vector2(141, -244)
]
var goal_line_1 = [
	Vector2(-298, -46),
	Vector2(101, -96),
	Vector2(-11, -41),
	Vector2(-83, -41),
	Vector2(134, -40),
	Vector2(317, -53),
	Vector2(-122, -97),
	Vector2(223, -100),
	Vector2(-156, -41),
	Vector2(-11, -100),
	Vector2(65, -40)
]
var goal_line_2 = [
	Vector2(-297, -43),
	Vector2(31, -91),
	Vector2(-11, -41),
	Vector2(-83, -41),
	Vector2(134, -40),
	Vector2(298, -42),
	Vector2(-46, -90),
	Vector2(-227, -43),
	Vector2(-156, -41),
	Vector2(201, -41),
	Vector2(65, -40)
]
var goal_line_gap_left = [
	Vector2(-297, -43),
	Vector2(258, -95),
	Vector2(53, -97),
	Vector2(-259, -93),
	Vector2(186, -99),
	Vector2(298, -42),
	Vector2(135, -38),
	Vector2(-227, -43),
	Vector2(122, -96),
	Vector2(201, -41),
	Vector2(65, -40)
]
var goal_line_gap_middle = [
	Vector2(-297, -43),
	Vector2(260, -90),
	Vector2(-190, -87),
	Vector2(-259, -93),
	Vector2(181, -88),
	Vector2(298, -42),
	Vector2(135, -38),
	Vector2(-227, -43),
	Vector2(-121, -89),
	Vector2(218, -41),
	Vector2(-158, -41)
]
var goal_line_gap_right = [
	Vector2(-297, -43),
	Vector2(-21, -87),
	Vector2(-190, -87),
	Vector2(-259, -93),
	Vector2(-319, -94),
	Vector2(-58, -36),
	Vector2(45, -85),
	Vector2(-227, -43),
	Vector2(-121, -89),
	Vector2(3, -39),
	Vector2(-158, -41)
]
var far_defenses = [
	four_three,
	three_four,
	nickel,
	quarter,
	gap_left,
	gap_right,
	gap_middle
]
var short_defenses = [
	goal_line_1,
	goal_line_2,
	goal_line_gap_middle,
	goal_line_gap_right,
	goal_line_gap_left
]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(turn):
	var _ball_position = Main.current_ball.position
	match turn:
		# top
		1:
			$Defenders.position.y = _ball_position.y - 50
			if _ball_position.y < 350:
				var _rand_short = int(rand_range(0,5))
				var _defense = short_defenses[_rand_short]
				for d in _defense.size():
					var _index = d
					d = Defender.instance()
					$Defenders.add_child(d)
					d.start(_defense[_index], 1)
			if _ball_position.y >= 350:
				var _rand_far = int(rand_range(0,7))
				var _defense = far_defenses[_rand_far]
				for d in _defense.size():
					var _index = d
					d = Defender.instance()
					$Defenders.add_child(d)
					d.start(_defense[_index], 1)
		# bot
		2:
			$Defenders.set_rotation_degrees(180)
			$Defenders.position.y = _ball_position.y + 50
			if _ball_position.y > 930:
				var _rand_short = int(rand_range(0,5))
				var _defense = short_defenses[_rand_short]
				for d in _defense.size():
					var _index = d
					d = Defender.instance()
					$Defenders.add_child(d)
					d.start(_defense[_index], 2)

			if _ball_position.y <= 930:
				var _rand_far = int(rand_range(0,7))
				var _defense = far_defenses[_rand_far]
				for d in _defense.size():
					var _index = d
					d = Defender.instance()
					$Defenders.add_child(d)
					d.start(_defense[_index], 2)

func kill():
	queue_free()


func randomize_defender_spawn(team, index):
	randomize()
	var _spawn_pos = Vector2()
	match team:
		1:
			match index:
				9: _spawn_pos = Vector2(rand_range(25, 695), 616)
				8: _spawn_pos = Vector2(rand_range(25, 695), 561)
				7: _spawn_pos = Vector2(rand_range(25, 695), 506)
				6: _spawn_pos = Vector2(rand_range(25, 695), 451)
				5: _spawn_pos = Vector2(rand_range(25, 695), 396)
				4: _spawn_pos = Vector2(rand_range(25, 695), 341)
				3: _spawn_pos = Vector2(rand_range(25, 695), 286)
				2: _spawn_pos = Vector2(rand_range(25, 695), 231)
				1: _spawn_pos = Vector2(rand_range(25, 695), 176)
				0: _spawn_pos = Vector2(rand_range(25, 695), 121)
		2:
			match index:
				0: _spawn_pos = Vector2(rand_range(25, 695), 1159)
				1: _spawn_pos = Vector2(rand_range(25, 695), 1104)
				2: _spawn_pos = Vector2(rand_range(25, 695), 1049)
				3: _spawn_pos = Vector2(rand_range(25, 695), 994)
				4: _spawn_pos = Vector2(rand_range(25, 695), 939)
				5: _spawn_pos = Vector2(rand_range(25, 695), 884)
				6: _spawn_pos = Vector2(rand_range(25, 695), 829)
				7: _spawn_pos = Vector2(rand_range(25, 695), 774)
				8: _spawn_pos = Vector2(rand_range(25, 695), 719)
				9: _spawn_pos = Vector2(rand_range(25, 695), 664)

	return _spawn_pos
