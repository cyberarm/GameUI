module GameUI
  class EditLine
    def initialize(text = "", x = 0, y = 0, secret = false, auto_manage = true)
      @text = text
      @x    = x
      @y    = y
      @secret = secret
      @auto_manage = auto_manage
      @visible_text = ""
      @text_object = Text.new(@text, x: x, y: y)
    end

    def draw
      Gosu.clip_to(@x, @y, @width, @height) do
        @text_object.draw
      end
    end

    def update
      @text_object
    end
  end
end
