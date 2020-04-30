extends Area2D

func _on_Area2D_body_enter(body):
    print("hoop")
    print(str('Body entered: ', body.get_name())) 
    
