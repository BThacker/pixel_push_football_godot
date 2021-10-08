# Pixel Push Football - 2020 Brandon Thacker 

extends Node2D

# timers for delaying certain actions to prevent the game from feeling "instant"

# reaching back into the parent to control the flow
var Main = null
var _timer = null
var GameEventControl
var oobSound = null
var gameCamera


func _ready():
	Main = get_parent()
	gameCamera = Main.get_node("game_camera")
	GameEventControl = Main.get_node("GameEventControl")


func delayOOB():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout",self, "_on_delayOOB_timeout")
	# how often we want the AI to respond to information
	_timer.set_wait_time(2)
	_timer.set_one_shot(true)
	_timer.start()


func _on_delayOOB_timeout():
	_timer = null
	oobSound = Main.get_node("oobTBSound")
	oobSound.play()
	Main.get_node("oob_marker/blue_oob_graphic").hide()
	Main.get_node("oob_marker/red_oob_graphic").hide()
	gameCamera.camera_action_move(gameCamera.camera_position.default)
	Main.did_ball_oob = false
	match Main.current_ball.current_turn:
		Main.current_ball.Turn.BOT:
			GameEventControl.game_eventAction(GameEventControl.GameEvent.BOT_OOB)
		Main.current_ball.Turn.TOP:
			GameEventControl.game_eventAction(GameEventControl.GameEvent.TOP_OOB)
		Main.current_ball.Turn.CHALLENGE_PRACTICE:
			pass

func delayTD():
	pass
