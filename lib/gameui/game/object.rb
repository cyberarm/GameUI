module GameUI
  class GameObject
    DEFAULT_IMAGE = Gosu::Image.from_text("DEFAULT", 11)
    def initialize(options = {})
      @options = options
      @options[:image]   ||= DEFAULT_IMAGE
      @options[:x]       ||= 0
      @options[:y]       ||= 0
      @options[:z]       ||= 0
      @options[:angle]   ||= 0
      @options[:visable] ||= true
      @options[:active]  ||= true

      @image   = @options[:image]
      @x       = @options[:x]
      @y       = @options[:y]
      @z       = @options[:z]
      @angle   = @options[:angle]
      @visable = @options[:visable]
      @active  = @options[:active]

      setup
    end

    def setup
    end

    def draw
      @image.draw_rot(x, y, z, angle) if @visable
    end

    def update
      if @active
        refresh
        if bounding_box_clicked?
          on_click
        end
      end
    end

    def refresh
    end

    def on_click
    end

    def visable(set_visable)
      raise "Must true or false" unless set_visable.is_a?(TrueClass|FalseClass)
      @visable = set_visable
    end
  end
end
