extends Area2D

@export var bullet_speed : float = 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout	#创建寿命计时器
	queue_free()	#自动销毁
	


# 与slime相同的运动方式，都是直接变换坐标
func _physics_process(delta: float) -> void:
	position += Vector2(bullet_speed, 0) * delta
	
