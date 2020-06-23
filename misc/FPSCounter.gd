extends CanvasLayer

func _process(_delta):
    $RichTextLabel.set_text(str(Engine.get_frames_per_second()))
