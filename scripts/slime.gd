extends Area2D		#Y sort enable指根据y轴大小确认渲染的先后，即y越大其渲染优先级越高s

@export var slime_speed : float = randf_range(-70,-50)	#可变速度敌人
@export var slime_animator : AnimatedSprite2D	#同player，创建一个控制动画的变量
var is_dead : bool = false
@export var special_enemy : float

signal died(point)		#定义信号

func _ready() -> void:
	special_enemy = randf()
	if special_enemy <= 0.9:
		return 
	else:
		position += Vector2(-100, 0)

func _physics_process(delta: float) -> void:
	if is_dead == false:
		if special_enemy <= 0.84:
			position += Vector2(slime_speed, 0) * delta 
		else:
			position += Vector2(-140, 0) * delta
	else:
		await get_tree().create_timer(0.6).timeout
		queue_free()
		
	if position.x < -600:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.game_over()	#调用game over函数
		

func _is_shoot(area: Area2D) -> void:	#检测是否与子弹碰撞
	if area.is_in_group("bullet"):		#将子弹分组为bullet，此处分组是为了防止史莱姆和其他史莱姆碰撞时也被消灭
		$"enemy died".play()
		slime_animator.play("defeated")	#播放死亡动画
		is_dead = true
		emit_signal("died", 1)	#声明死亡信号，等待被其他场景接收
		#注：该信号必须与定义的信号严格符合，包括大小写和缩进
