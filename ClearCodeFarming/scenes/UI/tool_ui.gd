extends Control

var tool_texture_scene = preload("res://scenes/UI/tool_ui_texture.tscn")

var TOOL_TEXTURES = {
	Global.Tools.HOE: preload("res://graphics/icons/hoe.png"),
	Global.Tools.AXE: preload("res://graphics/icons/axe.png"),
	Global.Tools.WATER: preload("res://graphics/icons/water.png"),
	Global.Tools.FISH: preload("res://graphics/icons/fish.png"),
	Global.Tools.SEED: preload("res://graphics/icons/wheat.png"),
	Global.Tools.SWORD: preload("res://graphics/icons/sword.png"),
}
var SEED_TEXTURES = {
	Global.Seeds.CORN: preload("res://graphics/icons/corn.png"),
	Global.Seeds.TOMATO: preload("res://graphics/icons/tomato.png"),
	Global.Seeds.PUMPKIN: preload("res://graphics/icons/pumpkin.png"),
	Global.Seeds.WHEAT: preload("res://graphics/icons/wheat.png"),
}

func _ready() -> void:
	$ToolContainer.hide()
	$SeedContainer.hide()
	texture_setup(Global.Tools.values(), TOOL_TEXTURES, $ToolContainer)
	texture_setup(Global.Seeds.values(), SEED_TEXTURES, $SeedContainer)

func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer):
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		tool_texture.setup(enum_id, textures[enum_id])
		container.add_child(tool_texture)
	
func reveal(option: String = "tool"):
	$HideTimer.start()
	for container in [$ToolContainer, $SeedContainer]:
		container.hide()
	var current_container =  $ToolContainer if option == "tool" else $SeedContainer
	current_container.show()
	var target = get_parent().current_tool if option == "tool" else get_parent().current_seed
	for texture in current_container.get_children():
		texture.highlight(target == texture.tool_enum)
		
func _on_hide_timer_timeout() -> void:
	$ToolContainer.hide()
	$SeedContainer.hide()
