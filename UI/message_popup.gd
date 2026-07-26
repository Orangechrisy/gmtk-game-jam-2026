extends TempPopup

@export var message: String = ""

func changetext():
	$RichTextLabel.text = message
