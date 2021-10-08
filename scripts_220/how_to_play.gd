# 2020 Pixel Push Football - Brandon Thacker 
extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal close_htp
# Called when the node enters the scene tree for the first time.


func _on_how_to_play_back_button_up():
	emit_signal("close_htp")
