extends Node

signal overhead_activ
signal overhead_close
var overhead_is_activ = false;

func _ready() -> void:
	#InputMap.add_action("open_overhead")

	#var ev = InputEventJoypadButton.new()
	#ev.button_index = JOY_BUTTON_BACK

	#InputMap.action_add_event("open_overhead", ev)
	print("overhead ready")
	
	
func _process(delta: float) -> void:
	if(Input.is_action_just_released("overhead_open")):
		print("open overhead")
		JavaScriptBridge.eval("activate_overhead();")
		var status = JavaScriptBridge.eval("get_status_overhead();");
		print(status)
		if status == 1.0:
			overhead_is_activ = true;
			overhead_activ.emit()
		else:
			overhead_is_activ = false;
			overhead_close.emit()
	if(Input.is_action_just_released("overhead_left") and overhead_is_activ):
		JavaScriptBridge.eval("arrow_left();")
	if(Input.is_action_just_released("overhead_right") and overhead_is_activ):
		JavaScriptBridge.eval("arrow_right();")
	if(Input.is_action_just_released("overhead_a") and overhead_is_activ):
		JavaScriptBridge.eval("button_A();")
