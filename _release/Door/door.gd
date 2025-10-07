extends Node2D

@export var needs_key : bool = false
@export var menu_door : bool = false
@export var menu_scene : String
@export var number_keys : int

@onready var animated_door: AnimatedSprite2D = $AnimatedSprite2D

var player_inside: bool = false 
var player: Node2D

func _ready() -> void:
	animated_door.play("Idle")

func _on_animate_door_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	if GlobalVars.number_keys >= number_keys or menu_door:
		animated_door.play("Opening")
		$DoorOpening.play()

func _on_animate_door_body_exited(body: Node2D) -> void:
	if body.name != "Player":
		return
	if GlobalVars.number_keys >= number_keys or menu_door:
		animated_door.play("Closing")
		$DoorClosing.play()

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("ui_action"):
		go_to_next_scene()

func go_to_next_scene() -> void:
	var body = player
	if not body:
		return
	if GlobalVars.number_keys >= number_keys or menu_door:
		player.move_player_to_nearest_door()
		player.is_door = true
		player.anim.play("DoorIn")
		await player.anim.animation_finished
		player.is_door = false
	else:
		$DoorLock.play()
	if needs_key:
		if GlobalVars.number_keys >= number_keys:
			GlobalVars.save_game()
			if get_tree():
				get_tree().change_scene_to_file(menu_scene)
	elif menu_door:
		if menu_scene == "exit":
			get_tree().quit()
		elif menu_scene == "reset":
			GlobalVars.score = 0;
			GlobalVars.deaths_n = 0;
			GlobalVars.kills_n = 0;
			GlobalVars.number_keys = 0;
			GlobalVars.number_blue_diamonds = "";
			GlobalVars.number_green_diamonds = "";
			GlobalVars.number_red_diamonds = "";
			GlobalVars.save_game()
			if get_tree():
				get_tree().reload_current_scene()
		else:
			if get_tree():
				get_tree().change_scene_to_file(menu_scene)


func _on_go_to_next_scene_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	player = body
	player_inside = true


func _on_go_to_next_scene_body_exited(body: Node2D) -> void:
	if body.name != "Player":
		return
	player_inside = false
