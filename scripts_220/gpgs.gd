# 2020 Pixel Push Football - Brandon Thacker 

# reference documentation
# https://github.com/cgisca/PGSGP
# google drive, google games develoepr API and many others need to be enabled
#
extends Node

signal signed_in
signal signed_in_fail
signal signed_out
signal signed_out_fail
signal leaderboard_score_submitted
signal leaderboard_score_failed


var shred_the_defense_leaderboard = Null
var two_minute_drill_leaderboard = Null
var fgf_leaderboard = Null
var show_popups = true
var gpgs
var is_player_signed_in
var gpgs_status = ""

func _ready():
	if Engine.has_singleton("PlayGameServices"):
		gpgs = Engine.get_singleton("PlayGameServices")
		# so we can show popups to users
		gpgs.init(get_instance_id(), show_popups)

# signing in
# callbacks: _on_sign_in_success | _on_sign_in_failed
func gpgs_sign_in():
	if gpgs:
		gpgs.sign_in()


func _on_sign_in_success():
	emit_signal("signed_in")
	is_player_signed_in = true


func _on_sign_in_failed(error_code: int):
	emit_signal("signed_in_fail")
	is_player_signed_in = false


# signing out
# callbacks: _on_sign_out_success | _on_sign_out_failed
func gpgs_sign_out():
	if gpgs:
		gpgs.sign_out()


func _on_sign_out_success():
	emit_signal("signed_out")
	is_player_signed_in = false


func _on_sign_out_failed():
	emit_signal("signed_out_fail")


# submit leaderboards
# callbacks: _on_leaderboard_score_submitted | _on_leaderboard_score_submitting_failed
func gpgs_submit_leaderboard_score(leaderboard_id: String, score: int):
	if gpgs:
		gpgs.submit_leaderboard_score(leaderboard_id, score)


func _on_leaderboard_score_submitted(leaderboard_id: String):
	emit_signal("leaderboard_score_submitted")



func _on_leaderboard_score_submitting_failed(leaderboard_id: String):
	emit_signal("leaderboard_score_failed")



# show leaderboards
# callbacks: none
func show_leaderboard(leaderboard_id: String):
	if gpgs:
		gpgs.show_leaderboard(leaderboard_id)


# test player connection
# callback _on_player_is_already_connected
func player_connected():
	if gpgs:
		gpgs.is_player_connected()

func _on_player_is_already_connected(is_connected: bool):
	is_player_signed_in = is_connected


