extends Area2D

signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400
var screen_size
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if position.distance_to(target) > 10:
		velocity = target - position
	
	# if Input.is_action_pressed("ui_right"):
	# 	velocity.x += 1
	# if Input.is_action_pressed("ui_left"):
	# 	velocity.x -= 1
	# if Input.is_action_pressed("ui_up"):
	# 	velocity.y -= 1
	# if Input.is_action_pressed("ui_down"):
	# 	velocity.y += 1
	# if velocity.length() > 0:
	# 	velocity = velocity.normalized() * speed
	# 	$AnimatedSprite.play()
	# else:
	# 	$AnimatedSprite.stop()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"	
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		
	$AnimatedSprite.flip_h = velocity.x < 0
	$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body: Node) -> void:
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
