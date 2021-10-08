# 2020 Pixel Push Football - Brandon Thacker 

extends RigidBody2D


var shadow_offset = Vector2(5,5)
var can_sound = false
var is_off_table = false
var turn = 0
var is_defense_spawned = false
onready var Main = get_tree().get_root().get_node("Main")
onready var TC = Main.get_node("ThemeControl")
onready var def_material = $SpriteOuter.get_material()
onready var def_material_1 = $SpriteOuter/SpriteInner1.get_material()
onready var def_material_2 = $SpriteOuter/SpriteInner1/SpriteInner2.get_material()
onready var DefenderTween = $DefenderTween
onready var screen_size_mid_point = get_viewport().get_visible_rect().size / 2
onready var board_left = screen_size_mid_point.x - 360
onready var board_right = screen_size_mid_point.x + 360
onready var board_top = screen_size_mid_point.y - 540
onready var board_bottom = screen_size_mid_point.y + 540

func _ready():
	match turn:
		# bot
		1:
			$SpriteOuter/SpriteInner1.modulate = TC.top_color_code
			$SpriteOuter/SpriteInner1/SpriteInner2.modulate = TC.top_color_code_dark
		# top
		2:
			$SpriteOuter/SpriteInner1.modulate = TC.bot_color_code
			$SpriteOuter/SpriteInner1/SpriteInner2.modulate = TC.bot_color_code_dark



func start(spawn_position, turn_provided):
	turn = turn_provided
	randomize()
	position = spawn_position
	can_sound = true
	# additional bool due to weird placing order bug
	is_defense_spawned = true


func _on_red_defender_body_entered(body):
	if can_sound and body.is_in_group("football"):
		$ImpactSound.play()
		can_sound = false

# we have to get fancy with the location validation on this
# due to the fact the node is the parent, we can't reference hard coded
# locations or coordinates

func _physics_process(_delta):
	var _current_position = get_global_position()
	if is_defense_spawned:
		if _current_position.x > 720 or _current_position.x < 0 or _current_position.y > 1180 or _current_position.y < 100:
			fall_off_table()
	var _current_scale = $SpriteOuter.get_scale()
	var _def_rotation = get_rotation()
	_def_rotation = -1 * _def_rotation
	var _new_position = shadow_offset.rotated(_def_rotation) * (_current_scale - Vector2(.5,.5))
	def_material.set_shader_param("offset", _new_position)
	def_material_1.set_shader_param("offset", _new_position)
	def_material_2.set_shader_param("offset", _new_position)


func fall_off_table():
	if !is_off_table:
		is_off_table = true
		var _def_start_size = $SpriteOuter.get_scale()
		var _def_end_size = Vector2(.6,.6)
		var _sprite_outer = $SpriteOuter
		$SpriteOuter.z_index = -1
		shadow_offset = shadow_offset * 4
		if TC.gamefield_main == TC.RETRO_GAMEFIELD:
			_def_end_size = Vector2(0,0)
			DefenderTween.interpolate_property(_sprite_outer, "scale", _def_start_size, _def_end_size, .50, Tween.TRANS_EXPO, Tween.EASE_IN)
		else:
			DefenderTween.interpolate_property(_sprite_outer, "scale", _def_start_size, _def_end_size, 1.75, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		DefenderTween.start()
