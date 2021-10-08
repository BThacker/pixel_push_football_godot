# 2020 Pixel Push Football - Brandon Thacker 
extends Sprite


func _ready():
	$GhostTween.interpolate_property(self, "modulate", Color(1,1,1,.5), Color(1,1,1,0), .5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$GhostTween.start()

func _on_GhostTween_tween_completed(object, key):
	queue_free()
