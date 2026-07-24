extends Control

@export var OFFSET: Vector2
var province: Province

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	province = get_parent()


# tracks the mouse position
func _process(delta: float) -> void:
	if visible:
		position = get_global_mouse_position() + OFFSET

func update_values():
	if province != null:
		var format_string = "[color={color}]{0} {yield}[/color] ([color=green]{1} {yield} Yield[/color], [color=red]{2} {yield} Consumption[/color])"
		var food_string = format_string.format(["%+.f" % province.calculate_food(), "%+.f" % province.food_yield, "-%.f" % province.food_consumption, ["yield", "Food"], ["color", "green" if province.calculate_food() >= 0 else "red"]])
		%Food.text = food_string
		var gold_string = format_string.format(["%+.f" % province.calculate_gold(), "%+.f" % province.gold_yield, "-%.f" % province.gold_consumption, ["yield", "Gold"], ["color", "green" if province.calculate_gold() >= 0 else "red"]])
		%Gold.text =  gold_string
		%Loyalty.value = province.loyalty
		%Fervor.value = province.fervor
