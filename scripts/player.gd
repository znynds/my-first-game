extends CharacterBody2D

@export var speed : float = 150 #expert可以使得该变量可在右侧被修改	使用var来定义变量，冒号来确定变量类型（可省略）
@export var animator : AnimatedSprite2D #定义一个类型为动画精灵的变量，后面可以用该类型的方法操作它
@export var bullet_speed : float = 800
var is_game_over : bool = false
@export var bullet_scene : PackedScene	#将场景作为一种变量保存，可以操作被保存的场景中的节点（按照文档，好像只能保存直接拥有的节点，而不能保存孙节点）
#接上行，此时packedscene没有被指定，还需要在监视器中（右边）将其设置为bullet场景
signal player_died(dead : bool)

func _ready() -> void:			#ready即开始时运行
	velocity = Vector2(0,0)		
	

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$"running sound".stop()
	elif not $"running sound".playing:
		$"running sound".play()


func _physics_process(delta: float) -> void:	#每一帧运行
	if is_game_over == false:
		velocity = Input.get_vector("left", "right", "up", "down") * speed
		if velocity == Vector2.ZERO:
			animator.play("idle")	#设置动画为待机
		else:
			animator.play("run")	#设置动画为跑步
		move_and_slide()
		
 
func game_over():
	if is_game_over == false:
		is_game_over = true
		$"game over sound".play()
		animator.play("game_over")
		emit_signal("player_died", true)  # 发射死亡信号
		print("Player死亡，已发射player_died信号")  # 新增日志，验证信号发射
		


func _fire() -> void:
	if velocity != Vector2.ZERO or is_game_over:	#不移动时发射子弹
		return
	$"fire sound".play()
	# ✅ 修改：获取子弹后给子弹赋值速度（原代码未传递速度，子弹不会移动）
	var bullet = BulletPool.get_bullet(position + Vector2(150,-12),Vector2(bullet_speed, 0))
	if bullet: 
		bullet.velocity = Vector2(bullet_speed, 0)
	
