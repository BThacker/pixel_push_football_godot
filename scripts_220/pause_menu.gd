# 2020 Pixel Push Football - Brandon Thacker 

extends Node

onready var Main = get_tree().get_root().get_node("Main")
onready var MenuControl = Main.get_node("MenuControl")
onready var GameCamera = Main.get_node("GameCamera")


func _on_resume_pressed():
	get_tree().paused = false
	GameCamera.camera_action_move(GameCamera.CameraPosition.DEFAULT)
	$CanvasPause/PauseBack.hide()
	$CanvasPause/PauseSelectSound.play()
	$CanvasPause/Resume.hide()
	$CanvasPause/QuitMainMenu.hide()
	$CanvasPause/PauseSettings.hide()
	$CanvasPause/PauseHowToPlay.hide()


func _on_quit_main_menu_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_pause_settings_pressed():
	MenuControl.show_settings()
	$CanvasPause/PauseSelectSound.play()


func _on_PauseHowToPlay_pressed():
	$CanvasPause/PauseHowToPlayBack.show()
	$CanvasPause/PauseHowToPlayLabel.show()
	$CanvasPause/GotIt.show()
	$CanvasPause/PauseSelectSound.play()
	$CanvasPause/Resume.hide()
	$CanvasPause/QuitMainMenu.hide()
	$CanvasPause/PauseSettings.hide()
	$CanvasPause/PauseHowToPlay.hide()

func _on_GotIt_pressed():
	$CanvasPause/PauseSelectSound.play()
	$CanvasPause/Resume.show()
	$CanvasPause/QuitMainMenu.show()
	$CanvasPause/PauseSettings.show()
	$CanvasPause/PauseHowToPlay.show()
	$CanvasPause/PauseHowToPlayBack.hide()
	$CanvasPause/PauseHowToPlayLabel.hide()
	$CanvasPause/GotIt.hide()
