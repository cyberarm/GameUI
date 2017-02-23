class EditLine
  def initialize(text = "", x, y, secret = false, auto_manage = true)
    @text = text
    @x    = x
    @y    = y
    @secret = secret
    @auto_manage = auto_manage
    @visible_text = ""
    @text_object = Text.new(@text, x: x, y: y)
  end

  def draw
    @text_object.draw
  end

  def update
    @text_object
  end
end
