extends Area2D

const SPEED = 130
@export var direction = -1
var velocity = Vector2()

var is_wall = false

func _physics_process(delta):
	if not is_wall:
		velocity.x = SPEED * delta * direction
		if(direction != -1):
			$AnimatedSprite2D.flip_h = true
		translate(velocity)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	is_wall = true
	if body.name == "Player":
		body.on_death()
	$SpikeD.play()
	$AnimatedSprite2D.play("Destroyed")
	await $AnimatedSprite2D.animation_finished
	queue_free()
