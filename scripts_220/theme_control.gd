# 2020 Pixel Push Football - Brandon Thacker 

extends Node2D



enum Themes {
	PAPER,
	LEAGUE,
	RETRO
}

enum PaperColors {
	RED,
	BLUE,
	GREEN,
	PURPLE,
	YELLOW,
	PINK
}

enum PaperGamefields {
	NOTEBOOK,
	CARDBOARD,
	BLUEPRINT
}

enum RetroColors {
	RED,
	BLUE,
	GREEN,
	PURPLE,
	YELLOW,
	PINK
}

const RETRO_GAMEFIELD = preload("res://images/themes/retro/field_retro/retro_gamefield.png")
const RETRO_GAMEFIELD_BORDER = preload("res://images/themes/retro/field_retro/retro_gamefield_border.png")
const BALL_ZONE = preload("res://images/aap_64/touch_zone.png")

const TOP_NOTIFY_TD = preload("res://images/aap_64/notify/touchdown_inner.png")
const TOP_NOTIFY_TD_OUTER = preload("res://images/aap_64/notify/touchdown_outer.png")
const TOP_NOTIFY_KICK_SUCCESS = preload("res://images/aap_64/notify/kick_success_inner.png")
const TOP_NOTIFY_KICK_SUCCESS_OUTER = preload("res://images/aap_64/notify/kick_success_outer.png")
const TOP_NOTIFY_KICK_FAILURE = preload("res://images/aap_64/notify/kick_failure_inner.png")
const TOP_NOTIFY_KICK_FAILURE_OUTER = preload("res://images/aap_64/notify/kick_failure_outer.png")
const TOP_NOTIFY_TOUCHBACK_STRIKE = preload("res://images/aap_64/notify/touchback_inner.png")
const TOP_NOTIFY_TOUCHBACK_STRIKE_OUTER = preload("res://images/aap_64/notify/touchback_outer.png")
const TOP_NOTIFY_2PT_SUCCESS = preload("res://images/aap_64/notify/2pt_success_inner.png")
const TOP_NOTIFY_2PT_SUCCESS_OUTER = preload("res://images/aap_64/notify/2pt_success_outer.png")
const TOP_NOTIFY_OOB = preload("res://images/aap_64/notify/oob_inner.png")
const TOP_NOTIFY_OOB_OUTER = preload("res://images/aap_64/notify/oob_outer.png")
const TOP_NOTIFY_SAFETY = preload("res://images/aap_64/notify/safety_inner.png")
const TOP_NOTIFY_SAFETY_OUTER = preload("res://images/aap_64/notify/safety_outer.png")
const TOP_NOTIFY_STRIKEOUT = preload("res://images/aap_64/notify/strikeout_inner.png")
const TOP_NOTIFY_STRIKEOUT_OUTER = preload("res://images/aap_64/notify/strikeout_outer.png")

const BOT_NOTIFY_TD = preload("res://images/aap_64/notify/touchdown_inner.png")
const BOT_NOTIFY_TD_OUTER = preload("res://images/aap_64/notify/touchdown_outer.png")
const BOT_NOTIFY_KICK_SUCCESS = preload("res://images/aap_64/notify/kick_success_inner.png")
const BOT_NOTIFY_KICK_SUCCESS_OUTER = preload("res://images/aap_64/notify/kick_success_outer.png")
const BOT_NOTIFY_KICK_FAILURE = preload("res://images/aap_64/notify/kick_failure_inner.png")
const BOT_NOTIFY_KICK_FAILURE_OUTER = preload("res://images/aap_64/notify/kick_failure_outer.png")
const BOT_NOTIFY_TOUCHBACK_STRIKE = preload("res://images/aap_64/notify/touchback_inner.png")
const BOT_NOTIFY_TOUCHBACK_STRIKE_OUTER = preload("res://images/aap_64/notify/touchback_outer.png")
const BOT_NOTIFY_2PT_SUCCESS = preload("res://images/aap_64/notify/2pt_success_inner.png")
const BOT_NOTIFY_2PT_SUCCESS_OUTER = preload("res://images/aap_64/notify/2pt_success_outer.png")
const BOT_NOTIFY_OOB = preload("res://images/aap_64/notify/oob_inner.png")
const BOT_NOTIFY_OOB_OUTER = preload("res://images/aap_64/notify/oob_outer.png")
const BOT_NOTIFY_SAFETY = preload("res://images/aap_64/notify/safety_inner.png")
const BOT_NOTIFY_SAFETY_OUTER = preload("res://images/aap_64/notify/safety_outer.png")
const BOT_NOTIFY_STRIKEOUT = preload("res://images/aap_64/notify/strikeout_inner.png")
const BOT_NOTIFY_STRIKEOUT_OUTER = preload("res://images/aap_64/notify/strikeout_outer.png")

const ARROW_INNER = preload("res://images/aap_64/generalized/arrow_inner.png")
const ARROW_OUTER = preload("res://images/aap_64/generalized/arrow_outer.png")

const RED_WINS_INNER = preload("res://images/aap_64/notify/red_wins_inner.png")
const RED_WINS_OUTER = preload("res://images/aap_64/notify/red_wins_outer.png")
const BLUE_WINS_INNER = preload("res://images/aap_64/notify/blue_wins_inner.png")
const BLUE_WINS_OUTER = preload("res://images/aap_64/notify/blue_wins_outer.png")
const GREEN_WINS_INNER = preload("res://images/aap_64/notify/green_wins_inner.png")
const GREEN_WINS_OUTER = preload("res://images/aap_64/notify/green_wins_outer.png")
const PURPLE_WINS_INNER = preload("res://images/aap_64/notify/purple_wins_inner.png")
const PURPLE_WINS_OUTER = preload("res://images/aap_64/notify/purple_wins_outer.png")
const YELLOW_WINS_INNER = preload("res://images/aap_64/notify/yellow_wins_inner.png")
const YELLOW_WINS_OUTER = preload("res://images/aap_64/notify/yellow_wins_outer.png")
const PINK_WINS_INNER = preload("res://images/aap_64/notify/pink_wins_inner.png")
const PINK_WINS_OUTER = preload("res://images/aap_64/notify/pink_wins_outer.png")

const REF_RETRO_GOOD = preload("res://images/aap_64/referee/ref_animation_td_retro.png")
const REF_RETRO_BAD = preload("res://images/aap_64/referee/ref_animation_no_good_retro.png")
const REF_RETRO_TB_TOP = preload("res://images/aap_64/referee/ref_animation_tb_top_retro.png")
const REF_RETRO_TB_BOT = preload("res://images/aap_64/referee/ref_animation_tb_bot_retro.png")
const REF_RETRO_BACK = preload("res://images/aap_64/ref_cam_back_retro.png")
const RETRO_SCOREBOARD = preload("res://images/aap_64/scoreboard_aap_wide_strikes_pause_retro.png")


enum LeagueColors {
	RED,
	BLUE,
	GREEN,
	PURPLE,
	YELLOW,
	PINK
}

enum LeagueGamefields {
	STRIPED_NUMBERS,
	STRIPED,
	GREEN_NUMBERS,
	GREEN
}


# aap_64 palette
var PaperColorDict = {
	"red": Color(.71, .13, .16),
	"red_dark": Color(.45, .09, .18),
	"blue": Color(.16, .36, .77),
	"blue_dark": Color(.08, .2, .39),
	"green": Color(.1, .48, .24) ,
	"green_dark": Color(.14, .32, .023),
	"purple": Color(.47, .23, .5),
	"purple_dark": Color(.25, .2, .33),
	"yellow": Color(1, .84, .25),
	"yellow_dark": Color(.98, .64, .11),
	"pink": Color(.91, .42, .45),
	"pink_dark": Color(.74, .29, .61)
}


onready var Main = get_parent()

const brown_border = preload("res://images/themes/normal_borders/brown_border.png")
const dark_brown_border = preload("res://images/themes/normal_borders/dark_brown_border.png")
const dark_grey_border = preload("res://images/themes/normal_borders/dark_grey_border.png")
const darker_grey_border = preload("res://images/themes/normal_borders/darker_grey_border.png")
const light_grey_border = preload("res://images/themes/normal_borders/light_grey_border.png")
const pink_border = preload("res://images/themes/normal_borders/pink_border.png")
const red_border = preload("res://images/themes/normal_borders/red_border.png")
const wood_dark_border = preload("res://images/themes/normal_borders/wood_dark_border.png")
const wood_light_border = preload("res://images/themes/normal_borders/wood_light_border.png")

onready var normal_borders = [
	brown_border,
	dark_brown_border,
	dark_grey_border,
	light_grey_border,
	pink_border,
	red_border,
	wood_dark_border,
	wood_light_border
]

# paper theme
const paper_notebook_gamefield = preload("res://images/themes/paper/field_notebook/paper_gamefield_notebook.png")
const paper_notebook_practicefield = preload("res://images/themes/paper/field_notebook/paper_practicefield_notebook.png")

const paper_cardboard_gamefield = preload("res://images/themes/paper/field_cardboard/paper_gamefield_cardboard.png")
const paper_cardboard_practicefield =  preload("res://images/themes/paper/field_cardboard/paper_practicefield_cardboard.png")

const paper_blueprint_gamefield = preload("res://images/themes/paper/field_blueprint/paper_gamefield_blueprint.png")
const paper_blueprint_practicefield = preload("res://images/themes/paper/field_blueprint/paper_practicefield_blueprint.png")

const paper_ball_white_1 = preload("res://images/themes/paper/balls/paper_ball_white_1.png")
const paper_ball_grey_1 = preload("res://images/themes/paper/balls/paper_ball_grey_1.png")
const paper_ball_burnt_red_1 = preload("res://images/themes/paper/balls/paper_ball_burnt_red_1.png")
const paper_ball_blue_green_1 = preload("res://images/themes/paper/balls/paper_ball_blue_green_1.png")
const paper_ball_tan_1 = preload("res://images/themes/paper/balls/paper_ball_tan_1.png")
const paper_ball_tan_2 = preload("res://images/themes/paper/balls/paper_ball_tan_2.png")
const paper_ball_white_blue_1 = preload("res://images/themes/paper/balls/paper_ball_white_blue_1.png")
const paper_ball_green_1 = preload("res://images/themes/paper/balls/paper_ball_green_1.png")
const paper_ball_green_2 = preload("res://images/themes/paper/balls/paper_ball_green_2.png")
const paper_ball_notebook_1 = preload("res://images/themes/paper/balls/paper_ball_notebook_1.png")
const paper_ball_notebook_2 = preload("res://images/themes/paper/balls/paper_ball_notebook_2.png")
const paper_ball_notebook_3 = preload("res://images/themes/paper/balls/paper_ball_notebook_3.png")
const paper_ball_notebook_4 = preload("res://images/themes/paper/balls/paper_ball_notebook_4.png")
const paper_ball_notebook_5 = preload("res://images/themes/paper/balls/paper_ball_notebook_5.png")
const paper_ball_notebook_6 = preload("res://images/themes/paper/balls/paper_ball_notebook_6.png")
const paper_ball_brown_1 = preload("res://images/themes/paper/balls/paper_ball_brown_1.png")
const paper_ball_brown_2 = preload("res://images/themes/paper/balls/paper_ball_brown_2.png")
const paper_ball_brown_3 = preload("res://images/themes/paper/balls/paper_ball_brown_3.png")

# paper  red
const paper_red_goalpost1 = preload("res://images/themes/paper/red/paper_goalpost_red1.png")
const paper_red_goalpost2 = preload("res://images/themes/paper/red/paper_goalpost_red2.png")
const paper_red_pointer = preload("res://images/themes/paper/red/paper_pointer_red.png")
const paper_red_endzone = preload("res://images/themes/paper/red/paper_endzone_red.png")
const paper_red_wins = preload("res://images/themes/paper/red/paper_red_wins.png")
const paper_red_oob_line = preload("res://images/themes/paper/red/paper_red_oob_line.png")
# paper blue
const paper_blue_goalpost1 = preload("res://images/themes/paper/blue/paper_goalpost_blue1.png")
const paper_blue_goalpost2 = preload("res://images/themes/paper/blue/paper_goalpost_blue2.png")
const paper_blue_pointer = preload("res://images/themes/paper/blue/paper_pointer_blue.png")
const paper_blue_endzone = preload("res://images/themes/paper/blue/paper_endzone_blue.png")
const paper_blue_wins = preload("res://images/themes/paper/blue/paper_blue_wins.png")
const paper_blue_oob_line = preload("res://images/themes/paper/blue/paper_blue_oob_line.png")
# paper green
const paper_green_goalpost1 = preload("res://images/themes/paper/green/paper_goalpost_green1.png")
const paper_green_goalpost2 = preload("res://images/themes/paper/green/paper_goalpost_green2.png")
const paper_green_pointer = preload("res://images/themes/paper/green/paper_pointer_green.png")
const paper_green_endzone = preload("res://images/themes/paper/green/paper_endzone_green.png")
const paper_green_wins = preload("res://images/themes/paper/green/paper_green_wins.png")
const paper_green_oob_line = preload("res://images/themes/paper/green/paper_green_oob_line.png")
# paper purple
const paper_purple_goalpost1 = preload("res://images/themes/paper/purple/paper_goalpost_purple1.png")
const paper_purple_goalpost2 = preload("res://images/themes/paper/purple/paper_goalpost_purple2.png")
const paper_purple_pointer = preload("res://images/themes/paper/purple/paper_pointer_purple.png")
const paper_purple_endzone = preload("res://images/themes/paper/purple/paper_endzone_purple.png")
const paper_purple_wins = preload("res://images/themes/paper/purple/paper_purple_wins.png")
const paper_purple_oob_line = preload("res://images/themes/paper/purple/paper_purple_oob_line.png")
# paper yellow
const paper_yellow_goalpost1 = preload("res://images/themes/paper/yellow/paper_goalpost_yellow1.png")
const paper_yellow_goalpost2 = preload("res://images/themes/paper/yellow/paper_goalpost_yellow2.png")
const paper_yellow_pointer = preload("res://images/themes/paper/yellow/paper_pointer_yellow.png")
const paper_yellow_endzone = preload("res://images/themes/paper/yellow/paper_endzone_yellow.png")
const paper_yellow_wins = preload("res://images/themes/paper/yellow/paper_yellow_wins.png")
const paper_yellow_oob_line = preload("res://images/themes/paper/yellow/paper_yellow_oob_line.png")
# paper pink
const paper_pink_goalpost1 = preload("res://images/themes/paper/pink/paper_goalpost_pink1.png")
const paper_pink_goalpost2 = preload("res://images/themes/paper/pink/paper_goalpost_pink2.png")
const paper_pink_pointer = preload("res://images/themes/paper/pink/paper_pointer_pink.png")
const paper_pink_endzone = preload("res://images/themes/paper/pink/paper_endzone_pink.png")
const paper_pink_wins = preload("res://images/themes/paper/pink/paper_pink_wins.png")
const paper_pink_oob_line = preload("res://images/themes/paper/pink/paper_pink_oob_line.png")


# retro theme
var RetroColorDict = {
	"red": Color(.87,.24,.14),
	"red_dark": Color(.45,.09,.18),
	"blue": Color(.14,.62,.87),
	"blue_dark": Color(.08,.2,.39),
	"green": Color(.35,.76,.21),
	"green_dark": Color(.35,.39,.42),
	"purple": Color(.74,.29,.61),
	"purple_dark": Color(.25,.2,.33),
	"yellow": Color(1,.99,.25),
	"yellow_dark": Color(.98,.42,.04),
	"pink": Color(.96,.63,.59),
	"pink_dark": Color(.74,.29,.61)
}

# retro balls
const retro_ball_purple = preload("res://images/themes/retro/balls/retro_ball_purple.png")
const retro_ball_red = preload("res://images/themes/retro/balls/retro_ball_red.png")
const retro_ball_yellow = preload("res://images/themes/retro/balls/retro_ball_yellow.png")
const retro_ball_aqua = preload("res://images/themes/retro/balls/retro_ball_aqua.png")
# retro red
const retro_red_goalpost1 = preload("res://images/themes/retro/red/retro_goalpost_red1.png")
const retro_red_goalpost2 = preload("res://images/themes/retro/red/retro_goalpost_red2.png")
const retro_red_pointer = preload("res://images/themes/retro/red/retro_pointer_red.png")
const retro_red_endzone = preload("res://images/themes/retro/red/retro_endzone_red.png")
const retro_red_wins = preload("res://images/themes/retro/red/retro_red_wins.png")
const retro_red_oob_line = preload("res://images/themes/retro/red/retro_red_oob_line.png")
# retro blue
const retro_blue_goalpost1 = preload("res://images/themes/retro/blue/retro_goalpost_blue1.png")
const retro_blue_goalpost2 = preload("res://images/themes/retro/blue/retro_goalpost_blue2.png")
const retro_blue_pointer = preload("res://images/themes/retro/blue/retro_pointer_blue.png")
const retro_blue_endzone = preload("res://images/themes/retro/blue/retro_endzone_blue.png")
const retro_blue_wins = preload("res://images/themes/retro/blue/retro_blue_wins.png")
const retro_blue_oob_line = preload("res://images/themes/retro/blue/retro_blue_oob_line.png")
# retro green
const retro_green_goalpost1 = preload("res://images/themes/retro/green/retro_goalpost_green1.png")
const retro_green_goalpost2 = preload("res://images/themes/retro/green/retro_goalpost_green2.png")
const retro_green_pointer = preload("res://images/themes/retro/green/retro_pointer_green.png")
const retro_green_endzone = preload("res://images/themes/retro/green/retro_endzone_green.png")
const retro_green_wins = preload("res://images/themes/retro/green/retro_green_wins.png")
const retro_green_oob_line = preload("res://images/themes/retro/green/retro_green_oob_line.png")
# retro purple
const retro_purple_goalpost1 = preload("res://images/themes/retro/purple/retro_goalpost_purple1.png")
const retro_purple_goalpost2 = preload("res://images/themes/retro/purple/retro_goalpost_purple2.png")
const retro_purple_pointer = preload("res://images/themes/retro/purple/retro_pointer_purple.png")
const retro_purple_endzone = preload("res://images/themes/retro/purple/retro_endzone_purple.png")
const retro_purple_wins = preload("res://images/themes/retro/purple/retro_purple_wins.png")
const retro_purple_oob_line = preload("res://images/themes/retro/purple/retro_purple_oob_line.png")
# retro yellow
const retro_yellow_goalpost1 = preload("res://images/themes/retro/yellow/retro_goalpost_yellow1.png")
const retro_yellow_goalpost2 = preload("res://images/themes/retro/yellow/retro_goalpost_yellow2.png")
const retro_yellow_pointer = preload("res://images/themes/retro/yellow/retro_pointer_yellow.png")
const retro_yellow_endzone = preload("res://images/themes/retro/yellow/retro_endzone_yellow.png")
const retro_yellow_wins = preload("res://images/themes/retro/yellow/retro_yellow_wins.png")
const retro_yellow_oob_line = preload("res://images/themes/retro/yellow/retro_yellow_oob_line.png")
# retro pink
const retro_pink_goalpost1 = preload("res://images/themes/retro/pink/retro_goalpost_pink1.png")
const retro_pink_goalpost2 = preload("res://images/themes/retro/pink/retro_goalpost_pink2.png")
const retro_pink_pointer = preload("res://images/themes/retro/pink/retro_pointer_pink.png")
const retro_pink_endzone = preload("res://images/themes/retro/pink/retro_endzone_pink.png")
const retro_pink_wins = preload("res://images/themes/retro/pink/retro_pink_wins.png")
const retro_pink_oob_line = preload("res://images/themes/retro/pink/retro_pink_oob_line.png")


# football league theme
var LeagueColorDict  = {
	"red": Color(.45, .09, .18),
	"red_dark": Color(.23, .09, .15),
	"blue": Color(.08, .2, .39),
	"blue_dark": Color(.07, .13, .13),
	"green": Color(.35, .76, .21) ,
	"green_dark": Color(.07, .13, .13),
	"purple": Color(.25, .2, .33),
	"purple_dark": Color(.14, .13, .2),
	"yellow": Color(1, .84, .25),
	"yellow_dark": Color(.98, .64, .11),
	"pink": Color(.74, .29, .61),
	"pink_dark": Color(.47, .23, .5)
}

const league_green_stripe_numbers_gamefield = preload("res://images/themes/league/field_green_stripe_numbers/league_gamefield_green_stripe_numbers.png")

const league_green_stripe_gamefield = preload("res://images/themes/league/field_green_stripe/league_gamefield_green_stripe.png")

const league_green_numbers_gamefield = preload("res://images/themes/league/field_green_numbers/league_gamefield_numbers.png")

const league_green_gamefield = preload("res://images/themes/league/field_green/league_gamefield_green.png")

const league_ball_pro_round = preload("res://images/themes/league/balls/league_ball_pro_round.png")
const league_ball_pro_triangle = preload("res://images/themes/league/balls/league_ball_pro_triangle.png")
const league_ball_college_round = preload("res://images/themes/league/balls/league_ball_college_round.png")
const league_ball_college_triangle = preload("res://images/themes/league/balls/league_ball_college_triangle.png")


# league red
const league_red_goalpost1 = preload("res://images/themes/league/red/league_goalpost_red1.png")
const league_red_goalpost2 = preload("res://images/themes/league/red/league_goalpost_red2.png")
const league_red_pointer = preload("res://images/themes/league/red/league_pointer_red.png")
const league_red_endzone = preload("res://images/themes/league/red/league_endzone_red.png")
const league_red_wins = preload("res://images/themes/league/red/league_red_wins.png")
const league_red_oob_line = preload("res://images/themes/league/red/league_red_oob_line.png")
# league blue
const league_blue_goalpost1 = preload("res://images/themes/league/blue/league_goalpost_blue1.png")
const league_blue_goalpost2 = preload("res://images/themes/league/blue/league_goalpost_blue2.png")
const league_blue_pointer = preload("res://images/themes/league/blue/league_pointer_blue.png")
const league_blue_endzone = preload("res://images/themes/league/blue/league_endzone_blue.png")
const league_blue_wins = preload("res://images/themes/league/blue/league_blue_wins.png")
const league_blue_oob_line = preload("res://images/themes/league/blue/league_blue_oob_line.png")
# league green
const league_green_goalpost1 = preload("res://images/themes/league/green/league_goalpost_green1.png")
const league_green_goalpost2 = preload("res://images/themes/league/green/league_goalpost_green2.png")
const league_green_pointer = preload("res://images/themes/league/green/league_pointer_green.png")
const league_green_endzone = preload("res://images/themes/league/green/league_endzone_green.png")
const league_green_wins = preload("res://images/themes/league/green/league_green_wins.png")
const league_green_oob_line = preload("res://images/themes/league/green/league_green_oob_line.png")
# league purple
const league_purple_goalpost1 = preload("res://images/themes/league/purple/league_goalpost_purple1.png")
const league_purple_goalpost2 = preload("res://images/themes/league/purple/league_goalpost_purple2.png")
const league_purple_pointer = preload("res://images/themes/league/purple/league_pointer_purple.png")
const league_purple_endzone = preload("res://images/themes/league/purple/league_endzone_purple.png")
const league_purple_wins = preload("res://images/themes/league/purple/league_purple_wins.png")
const league_purple_oob_line = preload("res://images/themes/league/purple/league_purple_oob_line.png")
# league yellow
const league_yellow_goalpost1 = preload("res://images/themes/league/yellow/league_goalpost_yellow1.png")
const league_yellow_goalpost2 = preload("res://images/themes/league/yellow/league_goalpost_yellow2.png")
const league_yellow_pointer = preload("res://images/themes/league/yellow/league_pointer_yellow.png")
const league_yellow_endzone = preload("res://images/themes/league/yellow/league_endzone_yellow.png")
const league_yellow_wins = preload("res://images/themes/league/yellow/league_yellow_wins.png")
const league_yellow_oob_line = preload("res://images/themes/league/yellow/league_yellow_oob_line.png")
# league pink
const league_pink_goalpost1 = preload("res://images/themes/league/pink/league_goalpost_pink1.png")
const league_pink_goalpost2 = preload("res://images/themes/league/pink/league_goalpost_pink2.png")
const league_pink_pointer = preload("res://images/themes/league/pink/league_pointer_pink.png")
const league_pink_endzone = preload("res://images/themes/league/pink/league_endzone_pink.png")
const league_pink_wins = preload("res://images/themes/league/pink/league_pink_wins.png")
const league_pink_oob_line = preload("res://images/themes/league/pink/league_pink_oob_line.png")


onready var MenuControl = Main.get_node("MenuControl")
var gamefield_main
var gamefield_border
var gamefield_xtra
var gamefield_xtra_orange
var top_game_endzone
var bot_game_endzone
# hard code for debug
var top_oob_graphic
var bot_oob_graphic
# I am moving away from the multi ball idea
var bot_pointer
var top_pointer
var bot_post1
var bot_post2
var top_post1
var top_post2
# to reference from other locations
# the specific color codes
var top_color_code
var top_color_code_dark
var bot_color_code
var bot_color_code_dark
var top_text = ""
var bot_text = ""
var orange_post

# practice specific
var gamefield_practice = preload("res://images/themes/paper_practicefield.png")
var endzone_practice_bot = preload("res://images/themes/paper_endzone_practice.png")
var endzone_practice_top = preload("res://images/themes/paper_endzone_practice.png")
var practice_ball = preload("res://images/themes/paper_ball_practice.png")
var practice_pointer = preload("res://images/themes/paper_pointer_practice.png")

# challenge specific
var endzone_challenge_bot = preload("res://images/themes/paper_endzone_challenge.png")
var endzone_challenge_top = preload("res://images/themes/paper_endzone_challenge.png")
var gamefield_challenge = preload("res://images/themes/paper_challengefield.png")
var fgf_post1 = preload("res://images/themes/fgf_post1.png")
var fgf_post2 = preload("res://images/themes/fgf_post2.png")

var practice_color = null
# theme selections
var selected_gamefield
var top_player_selected_color
var bot_player_selected_color
var selected_theme
var selected_ball



func _ready():
	Main = get_parent()

# don't judge me like VVVVVV for this huge switch

func set_theme_values():
	match selected_theme:
		Themes.PAPER:
			var _rand_norm_border = int(rand_range(0,8))
			gamefield_border = normal_borders[_rand_norm_border]
			match selected_gamefield:
				PaperGamefields.NOTEBOOK:
					gamefield_main = paper_notebook_gamefield
					gamefield_practice = paper_notebook_practicefield
				PaperGamefields.CARDBOARD:
					gamefield_main = paper_cardboard_gamefield
					gamefield_practice = paper_cardboard_practicefield
				PaperGamefields.BLUEPRINT:
					gamefield_main = paper_blueprint_gamefield
					gamefield_practice = paper_blueprint_practicefield
			match top_player_selected_color:
				PaperColors.RED:
					top_oob_graphic = paper_red_oob_line
					top_post1 = paper_red_goalpost1
					top_post2 = paper_red_goalpost2
					top_pointer = paper_red_pointer
					top_game_endzone = paper_red_endzone
					top_color_code = PaperColorDict["red"]
					top_color_code_dark = PaperColorDict["red_dark"]
					top_text = "RED"
				PaperColors.BLUE:
					top_oob_graphic = paper_blue_oob_line
					top_post1 = paper_blue_goalpost1
					top_post2 = paper_blue_goalpost2
					top_pointer = paper_blue_pointer
					top_game_endzone = paper_blue_endzone
					top_color_code = PaperColorDict["blue"]
					top_color_code_dark = PaperColorDict["blue_dark"]
					top_text = "BLUE"
				PaperColors.GREEN:
					top_oob_graphic = paper_green_oob_line
					top_post1 = paper_green_goalpost1
					top_post2 = paper_green_goalpost2
					top_pointer = paper_green_pointer
					top_game_endzone = paper_green_endzone
					top_color_code = PaperColorDict["green"]
					top_color_code_dark = PaperColorDict["green_dark"]
					top_text = "GREEN"
				PaperColors.PURPLE:
					top_oob_graphic = paper_purple_oob_line
					top_post1 = paper_purple_goalpost1
					top_post2 = paper_purple_goalpost2
					top_pointer = paper_purple_pointer
					top_game_endzone = paper_purple_endzone
					top_color_code = PaperColorDict["purple"]
					top_color_code_dark = PaperColorDict["purple_dark"]
					top_text = "PURPLE"
				PaperColors.YELLOW:
					top_oob_graphic = paper_yellow_oob_line
					top_post1 = paper_yellow_goalpost1
					top_post2 = paper_yellow_goalpost2
					top_pointer = paper_yellow_pointer
					top_game_endzone = paper_yellow_endzone
					top_color_code = PaperColorDict["yellow"]
					top_color_code_dark = PaperColorDict["yellow_dark"]
					top_text = "YELLOW"
				PaperColors.PINK:
					top_oob_graphic = paper_pink_oob_line
					top_post1 = paper_pink_goalpost1
					top_post2 = paper_pink_goalpost2
					top_pointer = paper_pink_pointer
					top_game_endzone = paper_pink_endzone
					top_color_code = PaperColorDict["pink"]
					top_color_code_dark = PaperColorDict["pink_dark"]
					top_text = "PINK"
			match bot_player_selected_color:
				PaperColors.RED:
					bot_oob_graphic = paper_red_oob_line
					bot_post1 = paper_red_goalpost1
					bot_post2 = paper_red_goalpost2
					bot_pointer = paper_red_pointer
					bot_game_endzone = paper_red_endzone
					bot_color_code = PaperColorDict["red"]
					bot_color_code_dark = PaperColorDict["red_dark"]
					bot_text = "RED"
				PaperColors.BLUE:
					bot_oob_graphic = paper_blue_oob_line
					bot_post1 = paper_blue_goalpost1
					bot_post2 = paper_blue_goalpost2
					bot_pointer = paper_blue_pointer
					bot_game_endzone = paper_blue_endzone
					bot_color_code = PaperColorDict["blue"]
					bot_color_code_dark = PaperColorDict["blue_dark"]
					bot_text = "BLUE"
				PaperColors.GREEN:
					bot_oob_graphic = paper_green_oob_line
					bot_post1 = paper_green_goalpost1
					bot_post2 = paper_green_goalpost2
					bot_pointer = paper_green_pointer
					bot_game_endzone = paper_green_endzone
					bot_color_code = PaperColorDict["green"]
					bot_color_code_dark = PaperColorDict["green_dark"]
					bot_text = "GREEN"
				PaperColors.PURPLE:
					bot_oob_graphic = paper_purple_oob_line
					bot_post1 = paper_purple_goalpost1
					bot_post2 = paper_purple_goalpost2
					bot_pointer = paper_purple_pointer
					bot_game_endzone = paper_purple_endzone
					bot_color_code = PaperColorDict["purple"]
					bot_color_code_dark = PaperColorDict["purple_dark"]
					bot_text = "PURPLE"
				PaperColors.YELLOW:
					bot_oob_graphic = paper_yellow_oob_line
					bot_post1 = paper_yellow_goalpost1
					bot_post2 = paper_yellow_goalpost2
					bot_pointer = paper_yellow_pointer
					bot_game_endzone = paper_yellow_endzone
					bot_color_code = PaperColorDict["yellow"]
					bot_color_code_dark = PaperColorDict["yellow_dark"]
					bot_text = "YELLOW"
				PaperColors.PINK:
					bot_oob_graphic = paper_pink_oob_line
					bot_post1 = paper_pink_goalpost1
					bot_post2 = paper_pink_goalpost2
					bot_pointer = paper_pink_pointer
					bot_game_endzone = paper_pink_endzone
					bot_color_code = PaperColorDict["pink"]
					bot_color_code_dark = PaperColorDict["pink_dark"]
					bot_text = "PINK"
		Themes.RETRO:
			# todo
			# theme sounds
			gamefield_main = RETRO_GAMEFIELD
			gamefield_border = RETRO_GAMEFIELD_BORDER
			Main.get_node("Border/ParallaxBackground/ParallaxLayer").set_motion_scale(Vector2(.5,.5))
			gamefield_practice = null
			match top_player_selected_color:
				RetroColors.RED:
					top_oob_graphic = retro_red_oob_line
					top_post1 = retro_red_goalpost1
					top_post2 = retro_red_goalpost2
					top_pointer = retro_red_pointer
					top_game_endzone = retro_red_endzone
					top_color_code = RetroColorDict["red"]
					top_color_code_dark = RetroColorDict["red_dark"]
					top_text = "RED"
				RetroColors.BLUE:
					top_oob_graphic = retro_blue_oob_line
					top_post1 = retro_blue_goalpost1
					top_post2 = retro_blue_goalpost2
					top_pointer = retro_blue_pointer
					top_game_endzone = retro_blue_endzone
					top_color_code = RetroColorDict["blue"]
					top_color_code_dark = RetroColorDict["blue_dark"]
					top_text = "BLUE"
				RetroColors.GREEN:
					top_oob_graphic = retro_green_oob_line
					top_post1 = retro_green_goalpost1
					top_post2 = retro_green_goalpost2
					top_pointer = retro_green_pointer
					top_game_endzone = retro_green_endzone
					top_color_code = RetroColorDict["green"]
					top_color_code_dark = RetroColorDict["green_dark"]
					top_text = "GREEN"
				RetroColors.PURPLE:
					top_oob_graphic = retro_purple_oob_line
					top_post1 = retro_purple_goalpost1
					top_post2 = retro_purple_goalpost2
					top_pointer = retro_purple_pointer
					top_game_endzone = retro_purple_endzone
					top_color_code = RetroColorDict["purple"]
					top_color_code_dark = RetroColorDict["purple_dark"]
					top_text = "PURPLE"
				RetroColors.YELLOW:
					top_oob_graphic = retro_yellow_oob_line
					top_post1 = retro_yellow_goalpost1
					top_post2 = retro_yellow_goalpost2
					top_pointer = retro_yellow_pointer
					top_game_endzone = retro_yellow_endzone
					top_color_code = RetroColorDict["yellow"]
					top_color_code_dark = RetroColorDict["yellow_dark"]
					top_text = "YELLOW"
				RetroColors.PINK:
					top_oob_graphic = retro_pink_oob_line
					top_post1 = retro_pink_goalpost1
					top_post2 = retro_pink_goalpost2
					top_pointer = retro_pink_pointer
					top_game_endzone = retro_pink_endzone
					top_color_code = RetroColorDict["pink"]
					top_color_code_dark = RetroColorDict["pink_dark"]
					top_text = "PINK"
			match bot_player_selected_color:
				RetroColors.RED:
					bot_oob_graphic = retro_red_oob_line
					bot_post1 = retro_red_goalpost1
					bot_post2 = retro_red_goalpost2
					bot_pointer = retro_red_pointer
					bot_game_endzone = retro_red_endzone
					bot_color_code = RetroColorDict["red"]
					bot_color_code_dark = RetroColorDict["red_dark"]
					bot_text = "RED"
				RetroColors.BLUE:
					bot_oob_graphic = retro_blue_oob_line
					bot_post1 = retro_blue_goalpost1
					bot_post2 = retro_blue_goalpost2
					bot_pointer = retro_blue_pointer
					bot_game_endzone = retro_blue_endzone
					bot_color_code = RetroColorDict["blue"]
					bot_color_code_dark = RetroColorDict["blue_dark"]
					bot_text = "BLUE"
				RetroColors.GREEN:
					bot_oob_graphic = retro_green_oob_line
					bot_post1 = retro_green_goalpost1
					bot_post2 = retro_green_goalpost2
					bot_pointer = retro_green_pointer
					bot_game_endzone = retro_green_endzone
					bot_color_code = RetroColorDict["green"]
					bot_color_code_dark = RetroColorDict["green_dark"]
					bot_text = "GREEN"
				RetroColors.PURPLE:
					bot_oob_graphic = retro_purple_oob_line
					bot_post1 = retro_purple_goalpost1
					bot_post2 = retro_purple_goalpost2
					bot_pointer = retro_purple_pointer
					bot_game_endzone = retro_purple_endzone
					bot_color_code = RetroColorDict["purple"]
					bot_color_code_dark = RetroColorDict["purple_dark"]
					bot_text = "PURPLE"
				RetroColors.YELLOW:
					bot_oob_graphic = retro_yellow_oob_line
					bot_post1 = retro_yellow_goalpost1
					bot_post2 = retro_yellow_goalpost2
					bot_pointer = retro_yellow_pointer
					bot_game_endzone = retro_yellow_endzone
					bot_color_code = RetroColorDict["yellow"]
					bot_color_code_dark = RetroColorDict["yellow_dark"]
					bot_text = "YELLOW"
				RetroColors.PINK:
					bot_oob_graphic = retro_pink_oob_line
					bot_post1 = retro_pink_goalpost1
					bot_post2 = retro_pink_goalpost2
					bot_pointer = retro_pink_pointer
					bot_game_endzone = retro_pink_endzone
					bot_color_code = RetroColorDict["pink"]
					bot_color_code_dark = RetroColorDict["pink_dark"]
					bot_text = "PINK"

		Themes.LEAGUE:
			randomize()
			var _rand_norm_border = int(rand_range(0,8))
			gamefield_border = normal_borders[_rand_norm_border]
			match selected_gamefield:
				LeagueGamefields.STRIPED_NUMBERS:
					gamefield_main = league_green_stripe_numbers_gamefield
				LeagueGamefields.STRIPED:
					gamefield_main = league_green_stripe_gamefield
				LeagueGamefields.GREEN_NUMBERS:
					gamefield_main = league_green_numbers_gamefield
				LeagueGamefields.GREEN:
					gamefield_main = league_green_gamefield
			match top_player_selected_color:
				LeagueColors.RED:
					top_oob_graphic = league_red_oob_line
					top_post1 = league_red_goalpost1
					top_post2 = league_red_goalpost2
					top_pointer = league_red_pointer
					top_game_endzone = league_red_endzone
					top_color_code = LeagueColorDict["red"]
					top_color_code_dark = LeagueColorDict["red_dark"]
					top_text = "RED"
				LeagueColors.BLUE:
					top_oob_graphic = league_blue_oob_line
					top_post1 = league_blue_goalpost1
					top_post2 = league_blue_goalpost2
					top_pointer = league_blue_pointer
					top_game_endzone = league_blue_endzone
					top_color_code = LeagueColorDict["blue"]
					top_color_code_dark = LeagueColorDict["blue_dark"]
					top_text = "BLUE"
				LeagueColors.GREEN:
					top_oob_graphic = league_green_oob_line
					top_post1 = league_green_goalpost1
					top_post2 = league_green_goalpost2
					top_pointer = league_green_pointer
					top_game_endzone = league_green_endzone
					top_color_code = LeagueColorDict["green"]
					top_color_code_dark = LeagueColorDict["green_dark"]
					top_text = "GREEN"
				LeagueColors.PURPLE:
					top_oob_graphic = league_purple_oob_line
					top_post1 = league_purple_goalpost1
					top_post2 = league_purple_goalpost2
					top_pointer = league_purple_pointer
					top_game_endzone = league_purple_endzone
					top_color_code = LeagueColorDict["purple"]
					top_color_code_dark = LeagueColorDict["purple_dark"]
					top_text = "PURPLE"
				LeagueColors.YELLOW:
					top_oob_graphic = league_yellow_oob_line
					top_post1 = league_yellow_goalpost1
					top_post2 = league_yellow_goalpost2
					top_pointer = league_yellow_pointer
					top_game_endzone = league_yellow_endzone
					top_color_code = LeagueColorDict["yellow"]
					top_color_code_dark = LeagueColorDict["yellow_dark"]
					top_text = "YELLOW"
				LeagueColors.PINK:
					top_oob_graphic = league_pink_oob_line
					top_post1 = league_pink_goalpost1
					top_post2 = league_pink_goalpost2
					top_pointer = league_pink_pointer
					top_game_endzone = league_pink_endzone
					top_color_code = LeagueColorDict["pink"]
					top_color_code_dark = LeagueColorDict["pink_dark"]
					top_text = "PINK"
			match bot_player_selected_color:
				LeagueColors.RED:
					bot_oob_graphic = league_red_oob_line
					bot_post1 = league_red_goalpost1
					bot_post2 = league_red_goalpost2
					bot_pointer = league_red_pointer
					bot_game_endzone = league_red_endzone
					bot_color_code = LeagueColorDict["red"]
					bot_color_code_dark = LeagueColorDict["red_dark"]
					bot_text = "RED"
				LeagueColors.BLUE:
					bot_oob_graphic = league_blue_oob_line
					bot_post1 = league_blue_goalpost1
					bot_post2 = league_blue_goalpost2
					bot_pointer = league_blue_pointer
					bot_game_endzone = league_blue_endzone
					bot_color_code = LeagueColorDict["blue"]
					bot_color_code_dark = LeagueColorDict["blue_dark"]
					bot_text = "BLUE"
				LeagueColors.GREEN:
					bot_oob_graphic = league_green_oob_line
					bot_post1 = league_green_goalpost1
					bot_post2 = league_green_goalpost2
					bot_pointer = league_green_pointer
					bot_game_endzone = league_green_endzone
					bot_color_code = LeagueColorDict["green"]
					bot_color_code_dark = LeagueColorDict["green_dark"]
					bot_text = "GREEN"
				LeagueColors.PURPLE:
					bot_oob_graphic = league_purple_oob_line
					bot_post1 = league_purple_goalpost1
					bot_post2 = league_purple_goalpost2
					bot_pointer = league_purple_pointer
					bot_game_endzone = league_purple_endzone
					bot_color_code = LeagueColorDict["purple"]
					bot_color_code_dark = LeagueColorDict["purple_dark"]
					bot_text = "PURPLE"
				LeagueColors.YELLOW:
					bot_oob_graphic = league_yellow_oob_line
					bot_post1 = league_yellow_goalpost1
					bot_post2 = league_yellow_goalpost2
					bot_pointer = league_yellow_pointer
					bot_game_endzone = league_yellow_endzone
					bot_color_code = LeagueColorDict["yellow"]
					bot_color_code_dark = LeagueColorDict["yellow_dark"]
					bot_text = "YELLOW"
				LeagueColors.PINK:
					bot_oob_graphic = league_pink_oob_line
					bot_post1 = league_pink_goalpost1
					bot_post2 = league_pink_goalpost2
					bot_pointer = league_pink_pointer
					bot_game_endzone = league_pink_endzone
					bot_color_code = LeagueColorDict["pink"]
					bot_color_code_dark = LeagueColorDict["pink_dark"]
					bot_text = "PINK"
	apply_gamefield()
	apply_endzone_background()


# apply the themes
#func apply_fg_background(turn):
#	match turn:
#		Main.Turn.BOT:
#			Main.get_node("Gamefield/Sprite").set_rotation_degrees(0)
#			Main.get_node("Gamefield/Sprite").set_texture(gamefield_xtra)
#			Main.get_node("Gamefield/Sprite/EndZone").show()
#			Main.get_node("Gamefield/Sprite/EndZone").color = top_color_code
#			Main.get_node("Gamefield/Sprite/Wall").show()
#			Main.get_node("Gamefield/Sprite/Wall").color = top_color_code_dark
#		Main.Turn.TOP:
#			Main.get_node("Gamefield/Sprite").set_rotation_degrees(180)
#			Main.get_node("Gamefield/Sprite").set_texture(gamefield_xtra)
#			Main.get_node("Gamefield/Sprite/EndZone").show()
#			Main.get_node("Gamefield/Sprite/EndZone").color = bot_color_code
#			Main.get_node("Gamefield/Sprite/Wall").show()
#			Main.get_node("Gamefield/Sprite/Wall").color = bot_color_code_dark
#		Main.Turn.CHALLENGE_PRACTICE:
#			Main.get_node("Gamefield/Sprite").set_texture(gamefield_challenge_xtra)
#			Main.get_node("Gamefield/Sprite/EndZone").show()
#			Main.get_node("Gamefield/Sprite/EndZone").color = bot_color_code
#			Main.get_node("Gamefield/Sprite/Wall").show()
#			Main.get_node("Gamefield/Sprite/Wall").color = bot_color_code_dark


func apply_gamefield():
	Main.get_node("Gamefield/Sprite/EndZone").hide()
	Main.get_node("Gamefield/Sprite/Wall").hide()
	Main.get_node("Gamefield/Sprite").set_texture(gamefield_main)
	Main.get_node("Gamefield/Sprite").set_rotation_degrees(0)
	Main.get_node("OobMarker/TopOobGraphic").set_texture(top_oob_graphic)
	Main.get_node("OobMarker/BotOobGraphic").set_texture(bot_oob_graphic)
	Main.get_node("Border/ParallaxBackground/ParallaxLayer/GameBorder").set_texture(gamefield_border)
	if gamefield_main == RETRO_GAMEFIELD:
		Main.get_node("MenuLayer/RefCam/RefCam/RefCamGood").set_texture(REF_RETRO_GOOD)
		Main.get_node("MenuLayer/RefCam/RefCam/RefCamBad").set_texture(REF_RETRO_BAD)
		Main.get_node("MenuLayer/RefCam/RefCam/RefCamTBTop").set_texture(REF_RETRO_TB_TOP)
		Main.get_node("MenuLayer/RefCam/RefCam/RefCamTBBot").set_texture(REF_RETRO_TB_BOT)
		Main.get_node("MenuLayer/BotScoreboard/ScoreBack").set_texture(RETRO_SCOREBOARD)
		Main.get_node("MenuLayer/TopScoreboard/ScoreBack").set_texture(RETRO_SCOREBOARD)
		Main.get_node("MenuLayer/RefCam/RefCam/RefCamBackground").set_texture(REF_RETRO_BACK)
		Main.get_node("Gamefield/Sprite").set_material(null)
	# border


func apply_endzone_background():
	Main.get_node("BotTd/Sprite").modulate = bot_color_code
	Main.get_node("Bot2Pt/Sprite").modulate = bot_color_code
	Main.get_node("TopTd/Sprite").modulate = top_color_code
	Main.get_node("Top2Pt/Sprite").modulate = top_color_code
	#Main.get_node("BotTd/Sprite2").set_texture(bot_game_endzone)
	#Main.get_node("Bot2Pt/Sprite2").set_texture(bot_game_endzone)
	#Main.get_node("TopTd/Sprite2").set_texture(top_game_endzone)
	#Main.get_node("Top2Pt/Sprite2").set_texture(top_game_endzone)

func apply_practice_theme():
	var gamefield_practice_border
	var _rand_norm_border = int(rand_range(0,8))
	gamefield_practice_border = normal_borders[_rand_norm_border]
	top_post1 = fgf_post1
	top_post2 = fgf_post2
	bot_post1 = fgf_post1
	bot_post2 = fgf_post2
	bot_pointer = practice_pointer
	selected_ball = practice_ball
	bot_color_code = Color(.98,.42,.04)
	bot_color_code_dark = Color(.87,.24,.14)
	Main.get_node("Gamefield/Sprite/EndZone").hide()
	Main.get_node("Gamefield/Sprite/Wall").hide()
	Main.get_node("BotTd/Sprite").modulate = bot_color_code
	Main.get_node("Bot2Pt/Sprite").modulate = bot_color_code
	Main.get_node("TopTd/Sprite").modulate = bot_color_code
	Main.get_node("Top2Pt/Sprite").modulate = bot_color_code
	Main.get_node("Gamefield/Sprite").set_texture(gamefield_practice)
	Main.get_node("Border/ParallaxBackground/ParallaxLayer/GameBorder").set_texture(gamefield_practice_border)


func apply_challenge_theme():
	var gamefield_challenge_border
	var _rand_norm_border = int(rand_range(0,8))
	gamefield_challenge_border = normal_borders[_rand_norm_border]
	bot_pointer = practice_pointer
	selected_ball = practice_ball
	bot_color_code = Color(.98,.42,.04)
	bot_color_code_dark = Color(.87,.24,.14)
	top_post1 = fgf_post1
	top_post2 = fgf_post2
	bot_post1 = fgf_post1
	bot_post2 = fgf_post2
	Main.get_node("Gamefield/Sprite/EndZone").hide()
	Main.get_node("Gamefield/Sprite/Wall").hide()
	Main.get_node("BotTd/Sprite").modulate = bot_color_code
	Main.get_node("Bot2Pt/Sprite").modulate = bot_color_code
	Main.get_node("TopTd/Sprite").modulate = bot_color_code
	Main.get_node("Top2Pt/Sprite").modulate = bot_color_code
	Main.get_node("Gamefield/Sprite").set_texture(gamefield_challenge)
	Main.get_node("Border/ParallaxBackground/ParallaxLayer/GameBorder").set_texture(gamefield_challenge_border)

func apply_selected_theme_sounds():
	pass
	#todo
	# theme sound logic

