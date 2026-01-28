extends Area2D

var velocity: Vector2 = Vector2.ZERO
var life_time: float = 2.0
var current_time: float = 0.0

# 当子弹从对象池取出时，调用此函数重置计时
func reset_timer() -> void:
	current_time = 0.0

func _physics_process(delta: float) -> void:
	# 基础移动逻辑
	position += velocity * delta
	
	# 对象池专用的计时回收逻辑
	current_time += delta
	if current_time >= life_time:
		_recycle()

# 处理碰撞信号
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		# 这里可以通知敌人受伤
		# if area.has_method("take_damage"): area.take_damage(1)
		_recycle()

func _recycle() -> void:
	# 修复报错：在物理回调期间回收子弹，必须使用 call_deferred
	# 这能确保在当前物理帧结束后，再执行回收（修改 process_mode 和禁用碰撞）
	BulletPool.call_deferred("recycle_bullet", self)
