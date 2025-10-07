extends StaticBody2D

@export var direction = -1

@export var timer_time = 1.0

const SPIKE = preload("res://_release/Traps/Totem/spike.tscn")

var is_firing = false

func _physics_process(delta):
	if direction == -1:
		# Залишаємо спрайт у правильному вигляді для напряму -1
		$AnimatedSprite2D.flip_h = false
		$Position2D.position.x = abs($Position2D.position.x) * -1		
	elif direction == 1:
		# Інвертуємо вигляд спрайта для напряму 1
		$AnimatedSprite2D.flip_h = true
		$Position2D.position.x = abs($Position2D.position.x)
		$AnimatedSprite2D.position = Vector2(4, $AnimatedSprite2D.position.y)

	if not is_firing:
		is_firing = true
		await get_tree().create_timer(timer_time).timeout
		$AnimatedSprite2D.play("Attack")
		$Spit.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Attack":
		var spike = SPIKE.instantiate()
		spike.direction = direction  # Напрямок шипа має залежати від напряму стрільби
		spike.position = $Position2D.global_position
		get_parent().add_child(spike)
		is_firing = false
