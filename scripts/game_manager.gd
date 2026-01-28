extends Node2D

@export var slime_scene : PackedScene
@export var spawn_timer : Timer
@export var score : int = 0
@export var score_label : Label
@export var game_over_label : Label


func _ready() -> void:
	game_over_label.visible = false
	$player.connect("player_died", _show_game_over)
	$enemy.connect("died", _score)


func _score(point : int):
	score += point
	print("史莱姆死亡，当前分数：", score) # 新增日志，验证分数累加


func _show_game_over(dead : bool):
	game_over_label.visible = true  # 确保节点有效时才设置显示
	await get_tree().create_timer(3).timeout	#需要知道tree指哪个树，如果是当前树的话，为何会把enemy一起重置？
	get_tree().reload_current_scene()			#目前猜测为被链接到的那棵树

func _process(delta: float) -> void:
	if spawn_timer.wait_time >= 1.6:
		spawn_timer.wait_time -= 0.2 * delta 
	
	score_label.text = "Score: " + str(score)


#该函数同player中的子弹生成函数，除了增加了一个随机数
func _spawn_slime() -> void:
	var slime_node = slime_scene.instantiate()
	slime_node.position = Vector2(350, randf_range(-180, 190))
	get_tree().current_scene.add_child(slime_node)
	# 核心修改：动态生成节点后，立即连接其died信号到_score函数（解决静态获取enemy的null问题），同时函数的参数也要保持一致，否则返回null
	slime_node.died.connect(_score)
	print("史莱姆生成，已绑定死亡信号")
	# 静态获取enemy由于其只判定其在场景中的静态节点而不会判断后面的动态生成的节点，所以在第一个史莱姆被消灭后会返回null，即场景内不再有静态的enemy
	# 信号名与slime.gd中定义的died完全一致
