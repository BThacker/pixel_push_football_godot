# Pixel Push Football - 2020 Brandon Thacker 

extends RigidBody2D

onready var Main = get_tree().get_root().get_node("Main")
onready var TC = Main.get_node("ThemeControl")
var can_sound = false

func start(spawn_position, turn):
	match turn:
		# bot
		1:
			$SpriteOuter/SpriteInner1.modulate = TC.top_color_code
			$SpriteOuter/SpriteInner1/SpriteInner2.modulate = TC.top_color_code_dark
		# top
		2:
			$SpriteOuter/SpriteInner1.modulate = TC.bot_color_code
			$SpriteOuter/SpriteInner1/SpriteInner2.modulate = TC.bot_color_code_dark
	randomize()
	position = spawn_position
	can_sound = true

func _on_red_defender_body_entered(body):
	if can_sound and body.is_in_group("football"):
		$ImpactSound.play()
		can_sound = false
