extends Node

enum Seeds {CORN, TOMATO, PUMPKIN, WHEAT}
enum Tools {HOE, AXE, WATER, FISH, SEED, SWORD}
enum Style {BASIC, BASEBALL, COWBOY, ENGLISH, STRAW, BEANIE}
enum State {DEFAULT, FISHING, BUILDING, SHOP}
enum Machine {SPRINKLER, FISHER, SCARECROW, DELETE}
enum Item {WOOD, APPLE, TOMATO, CORN, WHEAT, PUMPKIN, FISH}
enum Shop {MAIN, HAT}
var forecast_rain: bool = false

var unlocked_styles = [
	Global.Style.BASIC,
	Global.Style.ENGLISH,
]
var unlocked_machines = [
	Global.Machine.DELETE
]
var shop_connection = {
	Global.Shop.HAT: {
		'tracker': unlocked_styles,
		'all': Global.STYLE_UPGRADES.keys(),
	},
	Global.Shop.MAIN: {
		'tracker': unlocked_machines,
		'all': Global.MACHINE_UPGRADE_COST.keys(),
	},
}

const STYLE_UPGRADES = {
	Style.BASIC: {},
	Style.COWBOY: {
		'name': 'Cowboy',
		'cost': {Item.WOOD: 8, Item.CORN: 6},
		'icon': preload("res://graphics/icons/cowboy.png"),
		'color': Color.SANDY_BROWN,
	},
	Style.ENGLISH: {
		'name': 'Oldie',
		'cost': {Item.CORN: 8, Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/english.png"),
		'color': Color.LIGHT_GREEN,
	},
	Style.BASEBALL: {
		'name': 'Baseball',
		'cost': {Item.TOMATO: 8, Item.APPLE: 6},
		'icon': preload("res://graphics/icons/blue.png"),
		'color': Color.SKY_BLUE,
	},
	Style.BEANIE: {
		'name': 'Beanie',
		'cost': {Item.PUMPKIN: 8, Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/beanie.png"),
		'color': Color.INDIAN_RED,
	},
	Style.STRAW: {
		'name': 'Straw',
		'cost': {Item.WOOD: 8, Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/straw.png"),
		'color': Color.BURLYWOOD,
	},
}

const MACHINE_UPGRADE_COST = {
	Machine.SPRINKLER: {
		'name': 'Sprinkler',
		'cost': {Item.TOMATO: 30, Item.WHEAT: 20},
		'icon': preload("res://graphics/icons/sprinkler.png"),
		'color': Color.SEA_GREEN,
	},
	Machine.FISHER: {
		'name': 'Fisher',
		'cost': {Item.WOOD: 25, Item.FISH: 15},
		'icon': preload("res://graphics/icons/fisher.png"),
		'color': Color.SLATE_GRAY,
	},
	Machine.SCARECROW: {
		'name': 'Scarecrow',
		'cost': {Item.PUMPKIN: 15, Item.CORN: 15},
		'icon': preload("res://graphics/icons/scarecrow.png"),
		'color': Color.BURLYWOOD,
	},
	Machine.DELETE: {},
	}
	
const ITEM_IMAGES = {
	Item.WOOD: preload("res://graphics/icons/wood.png"), 
	Item.APPLE: preload("res://graphics/icons/apple.png"), 
	Item.TOMATO: preload("res://graphics/icons/tomato.png"), 
	Item.CORN: preload("res://graphics/icons/corn.png"), 
	Item.WHEAT: preload("res://graphics/icons/wheat.png"), 
	Item.PUMPKIN: preload("res://graphics/icons/pumpkin.png"), 
	Item.FISH: preload("res://graphics/icons/goldfish.png")
}

var items = {
	Item.WOOD: 0,
	Item.APPLE: 0,
	Item.TOMATO: 40,
	Item.CORN: 40,
	Item.WHEAT: 40,
	Item.PUMPKIN: 40,
	Item.FISH: 1,
}

func change_item(item: Global.Item, amount: int = 1, auto_hide: bool = true):
	items[item] += amount
	get_tree().get_first_node_in_group("ResourceUI").reveal(auto_hide)
	
