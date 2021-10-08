# 2020 Pixel Push Football - Brandon Thacker 

extends Node
# extends EditorScript
#tool
var total_turns
var game_length
var Main

var top_stats = {
	score = 0,
	turns_taken = float(0),
	miss_turns = float(0),
	miss_distance_total = float(0),
	avg_miss_distance = float(0),
	turns_per_td = float(0),
	fg_attempts = float(0),
	fg_successes = float(0),
	fg_success_rate = float(0),
	pat_attempts = float(0),
	two_pt_attempts = float(0),
	pat_successes = float(0),
	two_pt_successes = float(0),
	pat_success_rate = float(0),
	two_pt_success_rate = float(0),
	touchbacks = float(0),
	safeties = float(0),
	out_of_bounds = 0,
	touchdowns = float(3),
	total_touchdown_distance = float(0),
	avg_touchdown_distance = float(0),
	last_touchdown_distance = float(0),
	longest_touchdown_distance = 0,
	redzone_attempts = float(0),
	redzone_successes = float(0),
	redzone_success_rate = float(0),
	skill_rating = 0
}

var bot_stats = {
	score = 0,
	turns_taken = float(0),
	miss_turns = float(0),
	miss_distance_total = float(0),
	avg_miss_distance = float(0),
	turns_per_td = float(0),
	fg_attempts = float(0),
	fg_successes = float(0),
	fg_success_rate = float(0),
	pat_attempts = float(0),
	two_pt_attempts = float(0),
	pat_successes = float(0),
	two_pt_successes = float(0),
	pat_success_rate = float(0),
	two_pt_success_rate = float(0),
	touchbacks = float(0),
	safeties = float(0),
	out_of_bounds = 0,
	touchdowns = float(3),
	total_touchdown_distance = float(0),
	avg_touchdown_distance = float(0),
	last_touchdown_distance = float(0),
	longest_touchdown_distance = 0,
	redzone_attempts = float(0),
	redzone_successes = float(0),
	redzone_success_rate = float(0),
	skill_rating = 0
}

var challenge_stats = {
	two_minute_drill_shot_attempts = 0,
	two_minute_drill_success_rate = float(0),
	two_minute_drill_score = 0,
	shred_the_defense_score = 0,
	shred_the_defense_attempts = 0,
	shred_the_defense_accuracy = float(0),
	fgf_score = 0
}


func _ready():
	Main = get_parent()


func _run():
	print("testing tool functionality")


func update_stats():
	bot_stats.score = Main.bot_score
	top_stats.score = Main.top_score
	calculate_touchdown_stats()
	calculate_scoring_line_distance()
	calculate_twopt_stats()
	calculate_fg_stats()
	calculate_pat_stats()


func calculate_fg_stats():
	if bot_stats.fg_attempts > 0:
		bot_stats.fg_success_rate = float(bot_stats.fg_successes) / float(bot_stats.fg_attempts)
		bot_stats.fg_success_rate *= 100
		bot_stats.fg_success_rate = int(round(bot_stats.fg_success_rate))
	if top_stats.fg_attempts > 0:
		top_stats.fg_success_rate = float(top_stats.fg_successes) / float(top_stats.fg_attempts)
		top_stats.fg_success_rate *= 100
		top_stats.fg_success_rate = int(round(top_stats.fg_success_rate))


func calculate_touchdown_stats():
	if bot_stats.touchdowns > 0:
		bot_stats.turns_per_td = bot_stats.turns_taken / bot_stats.touchdowns
		bot_stats.avg_touchdown_distance = bot_stats.total_touchdown_distance / bot_stats.touchdowns
	if top_stats.touchdowns > 0:
		top_stats.turns_per_td = top_stats.turns_taken / top_stats.touchdowns
		top_stats.avg_touchdown_distance = top_stats.total_touchdown_distance / top_stats.touchdowns

	if bot_stats.last_touchdown_distance > bot_stats.longest_touchdown_distance:
		bot_stats.longest_touchdown_distance = bot_stats.last_touchdown_distance
	if top_stats.last_touchdown_distance > top_stats.longest_touchdown_distance:
		top_stats.longest_touchdown_distance = top_stats.last_touchdown_distance

	if bot_stats.redzone_attempts > 0:
		bot_stats.redzone_success_rate = float(bot_stats.redzone_successes) / float(bot_stats.redzone_attempts)
		bot_stats.redzone_success_rate *= 100
		top_stats.redzone_success_rate = int(round(top_stats.redzone_success_rate))
	if top_stats.redzone_attempts > 0:
		top_stats.redzone_success_rate = float(top_stats.redzone_successes) / float(top_stats.redzone_attempts)
		top_stats.redzone_success_rate *= 100
		top_stats.redzone_success_rate = int(round(top_stats.redzone_success_rate))


func calculate_scoring_line_distance():
	if bot_stats.miss_turns > 0:
		bot_stats.avg_miss_distance = bot_stats.miss_distance_total / bot_stats.miss_turns
	if top_stats.miss_turns > 0:
		top_stats.avg_miss_distance = top_stats.miss_distance_total / top_stats.miss_turns


func calculate_twopt_stats():
	if bot_stats.two_pt_attempts > 0:
		bot_stats.two_pt_success_rate = float(bot_stats.two_pt_successes) / float(bot_stats.two_pt_attempts)
		bot_stats.two_pt_success_rate *= 100
		bot_stats.two_pt_success_rate = int(round(bot_stats.two_pt_success_rate))
	if top_stats.two_pt_attempts > 0:
		top_stats.two_pt_success_rate = float(top_stats.two_pt_successes) / float(top_stats.two_pt_attempts)
		top_stats.two_pt_success_rate *= 100
		top_stats.two_pt_success_rate = int(round(top_stats.two_pt_success_rate))


func calculate_pat_stats():
	if bot_stats.pat_attempts > 0:
		bot_stats.pat_success_rate = float(bot_stats.pat_successes) / float(bot_stats.pat_attempts)
		bot_stats.pat_success_rate *= 100
		bot_stats.pat_success_rate = int(round(bot_stats.pat_success_rate))
	if top_stats.pat_attempts > 0:
		top_stats.pat_success_rate = float(top_stats.pat_successes) / float(top_stats.pat_attempts)
		top_stats.pat_success_rate *= 100
		top_stats.pat_success_rate = int(round(top_stats.pat_success_rate))


func debug_stats():
	print("---Red Total Turns---")
	print(bot_stats.turns_taken)
	print("---Blue Total Turns---")
	print(top_stats.turns_taken)
	print("---Red Turns per TD---")
	print(bot_stats.turns_per_td)
	print("---Blue Turns Per TD---")
	print(top_stats.turns_per_td)
	print("---Red Two Points Attempted, Succeeded, Success Rate---")
	print(bot_stats.two_pt_attempts)
	print(bot_stats.two_pt_successes)
	print(bot_stats.two_pt_success_rate)
	print("---Blue Two Points Attempted, Succeeded, Success Rate---")
	print(top_stats.two_pt_attempts)
	print(top_stats.two_pt_successes)
	print(top_stats.two_pt_success_rate)
	print("---Red PAT attempted, Succeeded, Success Rate---")
	print(bot_stats.pat_attempts)
	print(bot_stats.pat_successes)
	print(bot_stats.pat_success_rate)
	print("---Blue PAT attempted, Succeeded, Success Rate---")
	print(top_stats.pat_attempts)
	print(top_stats.pat_successes)
	print(top_stats.pat_success_rate)
	print("---Red Touchbacks---")
	print(bot_stats.touchbacks)
	print("---Blue Touchbacks---")
	print(top_stats.touchbacks)
	print("---Red Safeties---")
	print(bot_stats.safeties)
	print("---Blue Safeties---")
	print(top_stats.safeties)
	print("---Red Longest Touchdown---")
	print(bot_stats.longest_touchdown_distance)
	print("---Blue Longest Touchdown---")
	print(top_stats.longest_touchdown_distance)
	print("---Red Average Distance Left to Scoring Line on Miss---")
	print(bot_stats.avg_miss_distance)
	print("---Blue Average Distance Left to Scoring Line on Miss---")
	print(top_stats.avg_miss_distance)
	print("---Red Total Out of Bounds---")
	print(bot_stats.out_of_bounds)
	print("---Blue Total Out of Bounds---")
	print(top_stats.out_of_bounds)
	print("---Red RedZone Attempt, Succeeded, Success Rate---")
	print(bot_stats.redzone_attempts)
	print(bot_stats.redzone_successes)
	print(bot_stats.redzone_success_rate)
	print("---Blue RedZone Attempt, Succeeded, Success Rate---")
	print(top_stats.redzone_attempts)
	print(top_stats.redzone_successes)
	print(top_stats.redzone_success_rate)


func reset_stats():
	for r in bot_stats:
		bot_stats[r] = 0
	for b in top_stats:
		top_stats[b] = 0


func eog_stats_top():
	var format_string = "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s"
	var top_stat_string = format_string % [
		top_stats.score,
		top_stats.turns_taken,
		top_stats.avg_miss_distance,
		top_stats.touchdowns,
		int(round(top_stats.avg_touchdown_distance)),
		top_stats.longest_touchdown_distance,
		top_stats.fg_attempts,
		int(round(top_stats.fg_success_rate)),
		top_stats.redzone_attempts,
		int(round(top_stats.redzone_success_rate)),
		top_stats.pat_attempts,
		int(round(top_stats.pat_success_rate)),
		top_stats.two_pt_attempts,
		int(round(top_stats.two_pt_success_rate)),
		top_stats.touchbacks,
		top_stats.out_of_bounds,
		top_stats.safeties
	]
	return top_stat_string


func eog_stats_bot():
	var format_string = "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s"
	var bot_stat_string = format_string % [
		bot_stats.score,
		bot_stats.turns_taken,
		bot_stats.avg_miss_distance,
		bot_stats.touchdowns,
		int(round(bot_stats.avg_touchdown_distance)),
		bot_stats.longest_touchdown_distance,
		bot_stats.fg_attempts,
		int(round(bot_stats.fg_success_rate)),
		bot_stats.redzone_attempts,
		int(round(bot_stats.redzone_success_rate)),
		bot_stats.pat_attempts,
		int(round(bot_stats.pat_success_rate)),
		bot_stats.two_pt_attempts,
		int(round(bot_stats.two_pt_success_rate)),
		bot_stats.touchbacks,
		bot_stats.out_of_bounds,
		bot_stats.safeties
	]
	return bot_stat_string

# challenge specific


func two_minute_drill_stats():
	var high_score
	if challenge_stats.two_minute_drill_score >= SaveSettings.pixel_push_save_data["two_minute_drill_high_score"]:
		high_score = challenge_stats.two_minute_drill_score
		SaveSettings.pixel_push_save_data["two_minute_drill_high_score"] = challenge_stats.two_minute_drill_score
		SaveSettings.close_settings_save()
	elif challenge_stats.two_minute_drill_score < SaveSettings.pixel_push_save_data["two_minute_drill_high_score"]:
		high_score = SaveSettings.pixel_push_save_data["two_minute_drill_high_score"]
	if challenge_stats.two_minute_drill_shot_attempts > 0:
		challenge_stats.two_minute_drill_success_rate = float(challenge_stats.two_minute_drill_score) / float(challenge_stats.two_minute_drill_shot_attempts)
		challenge_stats.two_minute_drill_success_rate *= 100

	var format_string = "------------------\nRESULTS\n\nAttempts: %s\n\nTouchdowns: %s\n\nSuccess Rate: %s\n\n\nPersonal High Score: %s"
	var two_minute_stat_string = format_string % [
		challenge_stats.two_minute_drill_shot_attempts,
		challenge_stats.two_minute_drill_score,
		challenge_stats.two_minute_drill_success_rate,
		high_score
	]
	return two_minute_stat_string


func reset_two_minute_drill_stats():
	challenge_stats.two_minute_drill_shot_attempts = 0
	challenge_stats.two_minute_drill_success_rate = float(0)
	challenge_stats.two_minute_drill_score = 0


func reset_shred_the_defense_stats():
	challenge_stats.shred_the_defense_attempts = 0
	challenge_stats.shred_the_defense_accuracy = float(0)
	challenge_stats.shred_the_defense_score = 0


func shred_the_defense_stats():
	var high_score
	if challenge_stats.shred_the_defense_score >= SaveSettings.pixel_push_save_data["shred_the_defense_high_score"]:
		high_score = challenge_stats.shred_the_defense_score
		SaveSettings.pixel_push_save_data["shred_the_defense_high_score"] = challenge_stats.shred_the_defense_score
		SaveSettings.close_settings_save()
	elif challenge_stats.shred_the_defense_score < SaveSettings.pixel_push_save_data["shred_the_defense_high_score"]:
		high_score = SaveSettings.pixel_push_save_data["shred_the_defense_high_score"]
	if challenge_stats.shred_the_defense_attempts > 0:
		challenge_stats.shred_the_defense_accuracy = float(challenge_stats.shred_the_defense_score) / float(challenge_stats.shred_the_defense_attempts)
		challenge_stats.shred_the_defense_accuracy *= 100
	var format_string = "-----------------\nRESULTS\n\nPasses Attempted: %s\n\nPasses Completed (Score): %s\n\nAccuracy: %s\n\nPersonal High Score: %s"
	var shred_the_defense_string = format_string % [
		challenge_stats.shred_the_defense_attempts,
		challenge_stats.shred_the_defense_score,
		challenge_stats.shred_the_defense_accuracy,
		high_score
	]
	return shred_the_defense_string

func fgf_stats():
	var high_score
	if challenge_stats.fgf_score >= SaveSettings.pixel_push_save_data["field_goal_frenzy_high_score"]:
		high_score = challenge_stats.fgf_score
		SaveSettings.pixel_push_save_data["field_goal_frenzy_high_score"] = challenge_stats.fgf_score
		SaveSettings.close_settings_save()
	elif challenge_stats.fgf_score < SaveSettings.pixel_push_save_data["field_goal_frenzy_high_score"]:
		high_score = SaveSettings.pixel_push_save_data["field_goal_frenzy_high_score"]
	var format_string = "------------------\nRESULTS\n\nScore: %s\n\n\nPersonal High Score: %s"
	var fgf_string = format_string %[
		challenge_stats.fgf_score,
		high_score
	]
	return fgf_string
