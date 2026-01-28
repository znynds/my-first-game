extends Node2D

@export var bullet_scene : PackedScene
@export var bullet_pool_size : int = 10
var bullet_pool : Array[Area2D] = []
var active_bullet : Array[Area2D] = []

func _ready() -> void:
	# 确保路径正确，此处使用 load 加载场景
	bullet_scene = load("res://scenes/bullet.tscn")
	for x in range(bullet_pool_size):
		var bullet = bullet_scene.instantiate()
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED	# 禁用子弹的处理模式，节省性能
		add_child(bullet)	# 将实例化的子弹加入场景树
		bullet_pool.append(bullet)	# 加入闲置对象池

func get_bullet(position : Vector2, velocity : Vector2) -> Area2D:
	var bullet : Area2D
	if bullet_pool.size() > 0:
		bullet = bullet_pool.pop_back()		# 从池中获取闲置子弹
	else:
		bullet = bullet_scene.instantiate()	# 若池容量不足，则动态实例化
		add_child(bullet)
	
	# 设置子弹状态
	bullet.position = position
	# 确保子弹具有 velocity 属性或变量以供移动逻辑使用
	if "velocity" in bullet:
		bullet.velocity = velocity
		
	# --- 关键修复：重置计时器 ---
	# 子弹会继承上一次发射时的“剩余寿命”，导致刚出生就消失
	bullet.current_time = 0.0
		
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	active_bullet.append(bullet)			# 将对象加入活跃列表
	return bullet

func recycle_bullet(bullet : Area2D) -> void:
	if bullet in active_bullet:
		active_bullet.erase(bullet)
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		bullet.position = Vector2.ZERO
		bullet_pool.append(bullet) # 将子弹归还至闲置池
