extends TextureButton

var label

func _ready():
	label = get_node("Label")  # 调整路径以匹配你的节点结构
	connect("pressed", Callable(self, "_on_Button_pressed"))

func _on_Button_pressed():
	label.text = "1"
	print("Button pressed")
