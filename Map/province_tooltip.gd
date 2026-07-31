extends Control

@export var OFFSET: Vector2
var province: Province

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	province = get_parent()
	update_values()

# tracks the mouse position
func _process(_delta: float) -> void:
	if visible:
		position = get_global_mouse_position() + OFFSET

func update_values():
	if province != null:
		if province.has_army:
			%Armies.show()
		else:
			%Armies.hide()
		
		%Name.text = province.province_name
		if province.get_curr_owner() != province.Owner.KING:
			%Name.text = "[color=red]" + province.province_name + "[/color]"
			
			%Food.text = "+0 Food [color=red](Revolted)[/color]"
			%Gold.text = "+0 Gold [color=red](Revolted)[/color]"
			
			%Loyalty/Label.text = "Loyalty: 0%" 
			%Loyalty.value = 0
			%Fervor/Label.text = "Fervor: 100%"
			%Fervor.value = 59
			$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Label.hide()
		else:
			var format_string = "[color={color}]{0} {yield}[/color] ([color=#37472a]{1} Yield[/color], [color=red]{2} Consumption[/color])"
			var food_string = format_string.format(["%+.f" % province.calculate_food(), "%+.f" % province.food_yield, "-%.f" % province.food_consumption, ["yield", "Food"], ["color", "#37472a" if province.calculate_food() >= 0 else "red"]])
			%Food.text = food_string
			var gold_string = format_string.format(["%+.f" % province.calculate_gold(), "%+.f" % province.gold_yield, "-%.f" % province.gold_consumption, ["yield", "Gold"], ["color", "#37472a" if province.calculate_gold() >= 0 else "red"]])
			%Gold.text =  gold_string
			
			var loyaltyperc = str(province.loyalty * 2)
			%Loyalty/Label.text = "Loyalty: %s%%" % loyaltyperc
			%Loyalty.value = province.loyalty
			var fervorperc = str(province.fervor * 2)
			%Fervor/Label.text = "Fervor: %s%%" % fervorperc
			%Fervor.value = province.fervor
			$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Label.show()
