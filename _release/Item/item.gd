extends Area2D

enum item_type {ITEM_FRUIT, ITEM_KEY}
@export var type : item_type
@export var number_items : int
@export var points : int = 10
var is_picked : bool = false

func _ready() -> void:
	if GlobalVars.number_keys >= number_items and name == "Key":
		queue_free()
	if str(number_items) in GlobalVars.number_blue_diamonds and name == "BlueDiamond":
		queue_free()
	if str(number_items) in GlobalVars.number_green_diamonds and name == "GreenDiamond":
		queue_free()
	if str(number_items) in GlobalVars.number_red_diamonds and name == "RedDiamond":
		queue_free()

func on_pickup(body):
	if is_picked:
		return
	is_picked = true
	var tween1 = get_tree().create_tween().set_parallel(true)
	if type == item_type.ITEM_FRUIT:
		tween1.tween_property($".", "position:y", position.y - 20, 1)
		tween1.tween_callback(Callable($AnimatedSprite2D, "play").bind("Effect"))
	else :
		tween1.tween_property($".", "position", get_tree().current_scene.get_node("Padlock").position, 1)
		
	
	

	
	match type:
		item_type.ITEM_FRUIT:
			if name == "GreenDiamond":
				GlobalVars.number_green_diamonds = GlobalVars.number_green_diamonds + str(number_items)
			elif name == "BlueDiamond":
				GlobalVars.number_blue_diamonds = GlobalVars.number_blue_diamonds + str(number_items)
			elif name == "RedDiamond":
				GlobalVars.number_red_diamonds = GlobalVars.number_red_diamonds + str(number_items)
		item_type.ITEM_KEY:
			GlobalVars.number_keys += 1
			if get_tree().current_scene.get_node("Padlock"):
				get_tree().current_scene.get_node("Padlock").play("Open")
	
	GlobalVars.score += points
	if(GlobalVars.score > GlobalVars.hi_score):
		GlobalVars.hi_score = GlobalVars.score
	$Sound.play()
	await $Sound.finished
	await tween1.finished
	
	queue_free()
