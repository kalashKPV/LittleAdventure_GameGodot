extends CharacterBody2D

var tilemap_for_camera : TileMap

var is_door: bool = false
var is_dead: bool = false

var points_on_level = 0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var cam = $Camera2D as Camera2D

# берет значение гравитации из настроек проекта
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:	
	var screen_size = DisplayServer.window_get_size()
	tilemap_for_camera = get_parent().find_child("TileMap")
	#resize_and_position_buttons()
	var r = tilemap_for_camera.get_used_rect()
	var vp = tilemap_for_camera.get_viewport_rect()
	var qs = tilemap_for_camera.cell_quadrant_size
	var padding_x = screen_size.x - abs(r.position.x * qs) - abs(r.end.x * qs)
	var padding_y = screen_size.y - abs(r.position.y * qs) - abs(r.end.y * qs)
	cam.limit_left = r.position.x * qs
	cam.limit_top = r.position.y - padding_y/2
	cam.limit_right = r.end.x * qs + padding_x
	cam.limit_bottom = r.end.y * qs + padding_y/2
	
	is_door = true
	anim.play("DoorOut")
	await anim.animation_finished
	is_door = false
	GlobalVars.action_open_door = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$Jump.play()
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animation()
	if not is_door and not is_dead:
		move_and_slide()
		
	if Input.is_action_just_pressed("ui_action"):
		GlobalVars.action_open_door = true
		
	
	var screenSize = get_viewport_rect().size
	var tolerance = 10
	if position.y > screenSize.y + tolerance and not is_dead:
		on_death()
	
func update_animation():
	if is_dead or is_door:
		return
	if velocity.x < 0:
		anim.position = Vector2(-8, 0)
		anim.flip_h = true
	elif velocity.x > 0:
		anim.position = Vector2(8, 0)
		anim.flip_h = false
	if velocity.x:
		anim.play("Run")
		if not $Run.playing:
			$Run.play()
		$Idle.stop()
	else:
		anim.play("Idle")
		if not $Idle.playing and randi() % 1000 == 0:
			$Idle.play()
		$Run.stop()
	if velocity.y < 0:
		anim.play("Jump")
		$Run.stop()
		$Idle.stop()
	elif velocity.y > 0:
		anim.play("Fall")
		$Run.stop()
		$Idle.stop()
		
func on_death():
	if GlobalVars.score == GlobalVars.hi_score:
		GlobalVars.hi_score = GlobalVars.hi_score - points_on_level
	GlobalVars.score = GlobalVars.score - points_on_level
	points_on_level = 0
	is_dead = true
	$Dead.play()
	anim.play("Dead")
	await anim.animation_finished
	is_dead = false
	GlobalVars.deaths_n += 1
	get_tree().paused = true
	get_tree().current_scene.get_node("InGameMenu").get_node("GameOver").show()
	
func move_player_to_nearest_door() -> void:
	var scene = get_tree().current_scene
	# Список всех дверей
	var doors = scene.get_children().filter(
		func(child):
			return child is Node2D and child.name.begins_with("Door")
	)
	if doors.size() == 0:
		return
	# Находим ближайшую дверь
	var nearest_door = null
	var nearest_distance = INF
	for door in doors:
		var distance = position.distance_to(door.position)
		if distance < nearest_distance:
			nearest_door = door
			nearest_distance = distance

	if nearest_door:
		var offset = Vector2(0, -14)
		position = nearest_door.position + offset


func _on_pickup_area_entered(area: Area2D) -> void:
	if area.has_method("on_pickup"):
		area.on_pickup(self)
		if area.type == 1:
			points_on_level = 10 
			
func resize_and_position_buttons():
	var screen_size = get_viewport().size
	var padding = tilemap_for_camera.cell_quadrant_size
	$"CanvasLayer/left".position = Vector2(screen_size.x / 8 - padding, $"CanvasLayer/right".position.y)
	
	$"CanvasLayer/right".position = Vector2(
		screen_size.x / 8 + 30*6 + padding,
		$"CanvasLayer/right".position.y
	)
	
	$"CanvasLayer/jump".position = Vector2(
		screen_size.x - (screen_size.x / 8 + 30*6 + padding),
		$"CanvasLayer/right".position.y
	)
	
	$"CanvasLayer/action".position = Vector2(
		screen_size.x - (screen_size.x / 8),
		$"CanvasLayer/right".position.y
	)
	$CanvasLayer.show()
