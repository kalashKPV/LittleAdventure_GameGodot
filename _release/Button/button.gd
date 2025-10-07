extends Node2D

@export var is_level : bool = true
@export var minus : bool = false
@export var timer_visibility = 10.0
@export var map_name : String = "levelMap"
@onready var animated_button: AnimatedSprite2D = $AnimatedSprite2D

var is_pressed : bool = false
var is_pressed_process : bool =  true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_button.play("Idle")
	if get_tree().current_scene.get_node(map_name):
		get_tree().current_scene.get_node(map_name).set_layer_enabled(0, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_pressed_process:
		start_action()

func start_action() -> void:
	is_pressed_process = false
	while is_pressed:
		if is_level:
			if get_tree().current_scene.get_node(map_name):
				get_tree().current_scene.get_node(map_name).show()
				get_tree().current_scene.get_node(map_name).set_layer_enabled(0, true)
				await get_tree().create_timer(timer_visibility).timeout
				get_tree().current_scene.get_node(map_name).hide()
				await get_tree().create_timer(0.25).timeout
				get_tree().current_scene.get_node(map_name).show()
				await get_tree().create_timer(0.25).timeout
				get_tree().current_scene.get_node(map_name).hide()
				await get_tree().create_timer(0.25).timeout
				get_tree().current_scene.get_node(map_name).show()
				await get_tree().create_timer(0.25).timeout
				get_tree().current_scene.get_node(map_name).hide()
				get_tree().current_scene.get_node(map_name).set_layer_enabled(0, false)
		else:
			if minus and GlobalVars.sound > 0:
				GlobalVars.sound -= 1
			elif not minus and GlobalVars.sound < 100:
				GlobalVars.sound += 1
				
			var sounds_node = get_tree().current_scene.get_node("Sounds")
			if sounds_node:
				sounds_node.text = str(GlobalVars.sound)
			GlobalVars.save_game()
			await get_tree().create_timer(0.2).timeout


func _on_pressed_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	animated_button.play("Pressed")
	$ButtonPushed.play()
	is_pressed = true
	is_pressed_process =  true


func _on_pressed_exited(body: Node2D) -> void:
	if body.name != "Player":
		return
	animated_button.play("NotPressed")
	$Button.play()
	is_pressed = false
