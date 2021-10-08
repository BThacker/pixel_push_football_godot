# Pixel Push Football - 2020 Brandon Thacker 

extends Node

onready var Main = get_tree().get_root().get_node("Main")
onready var MenuControl = Main.get_node("MenuControl")


func _on_resume_pressed():
	get_tree().paused = false
	$CanvasPause/PauseBack.hide()
	$CanvasPause/Resume.hide()
	$CanvasPause/QuitMainMenu.hide()
	$CanvasPause/PauseSettings.hide()


func _on_quit_main_menu_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_pause_settings_pressed():
	MenuControl.show_settings()
