extends Node

@onready var score = $HBoxContainer/MarginContainer2/Score
@onready var hi_score = $HBoxContainer/MarginContainer3/HiScore
var number_keys : int 

func _ready() -> void:
	number_keys = GlobalVars.number_keys
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		# показать меню подтверждения по ESC
		if not $ConfirmationMenu.visible:
			show_confirmation_menu()
		else:
			hide_confirmation_menu()

	if not score or not hi_score:
		return
	score.text = "SCORE: " + str( GlobalVars.score )
	hi_score.text = "RECORD: " +str( GlobalVars.hi_score )
	
func show_confirmation_menu():
	$HBoxContainer/MarginContainer/TextureButton.disabled = true
	$ButtonPushed.play()
	await get_tree().create_timer(0.3).timeout
	$ConfirmationMenu.show()
	get_tree().paused = true # для ОСТАНОВА process во всей игре
	
func hide_confirmation_menu():
	$ConfirmationMenu.hide() # для запуска process
	$HBoxContainer/MarginContainer/TextureButton.disabled = false
	get_tree().paused = false

func _on_texture_button_pressed() -> void:
	show_confirmation_menu()

func _on_button_no_pressed() -> void:
	$ButtonPushed.play()
	await get_tree().create_timer(0.3).timeout
	hide_confirmation_menu()

func _on_button_yes_pressed() -> void:
	if GlobalVars.number_keys == number_keys + 1:
		GlobalVars.number_keys -= 1
	$ButtonPushed.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false # для запуска process
	get_tree().change_scene_to_file("res://_release/Menu/LevelsMenu.tscn")


func _on_try_again_pressed() -> void:
	if GlobalVars.number_keys == number_keys + 1:
		GlobalVars.number_keys -= 1
	$ButtonPushed.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_levels_pressed() -> void:
	if GlobalVars.number_keys == number_keys + 1:
		GlobalVars.number_keys -= 1
	$ButtonPushed.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://_release/Menu/LevelsMenu.tscn")


func _on_main_menu_pressed() -> void:
	if GlobalVars.number_keys == number_keys + 1:
		GlobalVars.number_keys -= 1
	$ButtonPushed.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://_release/Menu/MainMenu.tscn")
