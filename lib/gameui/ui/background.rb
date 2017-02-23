module GameUI
  class Background
    def initialize(container, color, z)
      @container = container
      @color = color
      @z     = z
    end

    def draw
      @container.fill_rect(@container.x, @container.y, @container.width, @container.height, @color, @z)
    end

    def update
    end
  end
end
