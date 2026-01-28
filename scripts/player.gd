extends CharacterBody2D

@export var speed : float = 150 #expert可以使得该变量可在右侧被修改	使用var来定义变量，冒号来确定变量类型（可省略）
@export var animator : AnimatedSprite2D #定义一个类型为动画精灵的变量，后面可以用该类型的方法操作它
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
		await get_tree().create_timer(3).timeout	#需要知道tree指哪个树，如果是当前树的话，为何会把enemy一起重置？
		get_tree().reload_current_scene()			#目前猜测为被链接到的那棵树


func _fire() -> void:
	if velocity != Vector2.ZERO or is_game_over:	#不移动时发射子弹
		return
	$"fire sound".play()
	var bullet_node = bullet_scene.instantiate()	#实例化子弹模板，即创建一个子弹实体
	bullet_node.position = position + Vector2(150,-12)
	get_tree().current_scene.add_child(bullet_node)	#在当前场景中加一个子节点，即子弹节点
