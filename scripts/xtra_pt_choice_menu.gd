# Pixel Push Football - 2020 Brandon Thacker 

extends Node

signal one_pt(xtra_ball_color)
signal two_pt(xtra_ball_color)
signal field_goal

onready	var Main = get_parent()
onready var TC = Main.get_node("ThemeControl")
onready	var Bot = $Bot
onready var Top = $Top
onready	var BotPat = $Bot/BotPat
onready	var Bot2Pt = $Bot/Bot2Pt
onready var BotTitle = $Bot/Title
onready	var TopPat = $Top/TopPat
onready	var Top2Pt = $Top/Top2Pt
onready var TopTitle = $Top/Title
onready var BotFg = $Bot/BotFg
onready var BotFgTitle = $Bot/FgTitle
onready var TopFg = $Top/TopFg
onready var TopFgTitle = $Top/FgTitle
onready var ChoiceTween = $ChoiceTween
onready var BlockInput = Main.get_node("MenuLayer/BlockInput/BlockInput")
onready var ErrorSound = Main.get_node("FailSound")
var should_play_error


func start(color, type):
	BlockInput.show()
	var _timer = null

	$Bot/Title.modulate = TC.bot_color_code
	$Top/Title.modulate = TC.top_color_code
	$Bot/FgTitle.modulate = TC.top_color_code
	$Top/FgTitle.modulate = TC.bot_color_code

	var _top_style = StyleBoxFlat.new()
	var _bot_style = StyleBoxFlat.new()

	_top_style.set_bg_color(TC.top_color_code)
	_top_style.set_border_color(TC.top_color_code_dark)
	_top_style.set_border_width_all(12)
	_bot_style.set_bg_color(TC.bot_color_code)
	_bot_style.set_border_color(TC.bot_color_code_dark)
	_bot_style.set_border_width_all(12)

	$Bot/Bot2Pt.set("custom_styles/normal", _bot_style)
	$Bot/BotPat.set("custom_styles/normal", _bot_style)
	$Bot/BotFg.set("custom_styles/normal", _bot_style)

	$Top/Top2Pt.set("custom_styles/normal", _top_style)
	$Top/TopPat.set("custom_styles/normal", _top_style)
	$Top/TopFg.set("custom_styles/normal", _top_style)


	match type:
		1:
			match color:
				Main.Turn.BOT:
					BotPat.show()
					Bot2Pt.show()
					BotTitle.show()
				Main.Turn.TOP:
					TopPat.show()
					Top2Pt.show()
					TopTitle.show()
			var top_pat_start = TopPat.rect_position
			var top_pat_end = Vector2(-550,-490)
			var top_2pt_start = Top2Pt.rect_position
			var top_2pt_end = Vector2(-550,-330)
			var top_title_start = TopTitle.position
			var top_title_end = Vector2(-360,-1050)
			var bot_pat_start = BotPat.rect_position
			var bot_pat_end = Vector2(170,790)
			var bot_2pt_start = Bot2Pt.rect_position
			var bot_2pt_end = Vector2(170,950)
			var bot_title_start = BotTitle.position
			var bot_title_end = Vector2(360,230)
			ChoiceTween.interpolate_property(TopPat, "rect_position", top_pat_start, top_pat_end, 1.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(Top2Pt, "rect_position", top_2pt_start, top_2pt_end, 1.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(TopTitle, "position", top_title_start, top_title_end, 1.25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(BotPat, "rect_position", bot_pat_start, bot_pat_end, 1.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(Bot2Pt, "rect_position", bot_2pt_start, bot_2pt_end, 1.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(BotTitle, "position", bot_title_start, bot_title_end, 1.25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		2:
			should_play_error = true
			match color:
				Main.Turn.BOT:
					BotFg.show()
					BotFgTitle.show()
				Main.Turn.TOP:
					TopFg.show()
					TopFgTitle.show()
			var bot_fg_start = BotFg.rect_position
			var bot_fg_end = Vector2(170,950)
			var bot_fg_title_start = BotFgTitle.position
			var bot_fg_title_end = Vector2(360,230)
			var top_fg_start = TopFg.rect_position
			var top_fg_end = Vector2(-550,-330)
			var top_fg_title_start = TopFgTitle.position
			var top_fg_title_end = Vector2(-360,-1050)
			ChoiceTween.interpolate_property(BotFg, "rect_position", bot_fg_start, bot_fg_end, 1.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(BotFgTitle, "position", bot_fg_title_start, bot_fg_title_end, 1.25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(TopFg, "rect_position", top_fg_start, top_fg_end, 1.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
			ChoiceTween.interpolate_property(TopFgTitle, "position", top_fg_title_start, top_fg_title_end, 1.25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	_timer = Timer.new()
	_timer.connect("timeout",self, "execute_tween")
	match type:
		1: _timer.set_wait_time(2.5)
		2: _timer.set_wait_time(1.0)
	_timer.set_one_shot(true)
	add_child(_timer)
	_timer.start()


func execute_tween():
	ChoiceTween.start()
	if should_play_error:
		ErrorSound.play()


func _on_ChoiceTween_tween_all_completed():
	BlockInput.hide()

func _on_BotPat_pressed():
	emit_signal("one_pt", Main.Turn.BOT)
	queue_free()


func _on_Bot2Pt_pressed():
	emit_signal("two_pt", Main.Turn.BOT)
	queue_free()


func _on_Top2Pt_pressed():
	emit_signal("two_pt", Main.Turn.TOP)
	queue_free()


func _on_TopPat_pressed():
	emit_signal("one_pt", Main.Turn.TOP)
	queue_free()


func _on_BotFg_pressed():
	emit_signal("field_goal")
	queue_free()


func _on_TopFg_pressed():
	emit_signal("field_goal")
	queue_free()
