# Pixel Push Football - 2020 Brandon Thacker  
# didn't end up using IAP, but I had it working at one point

extends Node2D

onready var Main = get_parent()
var iap_timer
var license_timer
var license_check_passed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AndroidIAP.connect("purchase_success", self, "on_purchase_success")
	AndroidIAP.connect("purchase_fail", self, "on_purchase_fail")
	AndroidIAP.connect("purchase_cancel", self, "on_purchase_cancel")
	AndroidIAP.connect("purchase_owned", self, "on_purchase_owned")
	AndroidIAP.connect("has_purchased", self, "on_has_purchased")
	AndroidIAP.connect("sku_details_complete", self, "on_sku_details_complete")
	AndroidIAP.connect("has_purchased",self,"android_iap_has_purchased")

	# consume button for testing purposes
	AndroidIAP.set_auto_consume(false)
	AndroidIAP.connect("consume_success", self, "on_consume_success")
	AndroidIAP.connect("consume_fail", self, "on_consume_fail")

	# delay check for IAP to make sure AndroidIAP is initialized
	var _delay_time = 3
	iap_timer = Timer.new()
	add_child(iap_timer)
	iap_timer.connect("timeout",self, "delay_iap_check")
	iap_timer.set_wait_time(_delay_time)
	iap_timer.set_one_shot(true)
	iap_timer.start()


func delay_iap_check():
	AndroidIAP.request_purchased()
	var _delay_time = 5
	license_timer = Timer.new()
	add_child(license_timer)
	license_timer.connect("timeout",self, "delay_license_check")
	license_timer.set_wait_time(_delay_time)
	license_timer.set_one_shot(true)
	license_timer.start()



# this will callback if the user has purchased
# this complies with googles policy to restore a product
# if a user reinstalls the application and has entitlement
func android_iap_has_purchased(item_name):
	if item_name == "ppf_full_unlock":
		Main.unlock_full_game()
		license_check_passed = true
		SaveSettings.pixel_push_save_data["unlicensed_remaining"] = 5
		SaveSettings.pixel_push_save_data["is_full_game_unlocked"] = true
		SaveSettings.close_settings_save()


func delay_license_check():
	if SaveSettings.pixel_push_save_data["unlicensed_remaining"] < 1 and !license_check_passed:
		Main.lock_game()
		SaveSettings.pixel_push_save_data["unlicensed_remaining"] = 5
		SaveSettings.pixel_push_save_data["is_full_game_unlocked"] = false
		SaveSettings.close_settings_save()
	match SaveSettings.pixel_push_save_data["is_full_game_unlocked"]:
		true:
			if !license_check_passed:
				SaveSettings.pixel_push_save_data["unlicensed_remaining"] -= 1
				SaveSettings.close_settings_save()
		false:
			pass
	


func purchase_full_game():
	AndroidIAP.purchase("ppf_full_unlock")


func reset_full_purchase():
	AndroidIAP.consume_all()


func get_info_ppf_full_unlock():
	AndroidIAP.sku_details_query(["ppf_full_unlock"])


func on_purchase_success(item_name):
	SaveSettings.pixel_push_save_data["is_full_game_unlocked"]  = true
	SaveSettings.close_settings_save()
	Main.unlock_full_game()


func on_purchase_fail():
	pass


func on_purchase_cancel():
	pass


func on_purchase_owned(item_name):
	pass


func on_sku_details_complete():
	# get information about possible IAP
	pass


func on_consume_success(item_name):
	pass


func on_consume_fail():
	pass

