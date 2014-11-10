class AirplayDemoViewController < UIViewController
  attr_accessor :textLayer
  def viewDidAppear(animated)
    layer = nil
    window = nil
    self.view.backgroundColor = UIColor.whiteColor

    @textLayer = CATextLayer.alloc.init
    @textLayer.foregroundColor = UIColor.blackColor.CGColor
    @textLayer.frame = self.view.bounds
    @textLayer.alignmentMode = KCAAlignmentCenter

    screenNumber = screen_number
    @textLayer.string = screenNumber.to_s

    layer = self.view.layer
    layer.addSublayer(@textLayer)

    window = self.view.window
    scale = window.screen.scale
    layer.setRasterizationScale(scale)
    layer.setShouldRasterize(true)
  end

  def screen_number
    result = 1
    window = nil
    screen = nil
    screens = UIScreen.screens

    if screens.size > 1
      window = self.view.window
      screen = window.screen
      unless screen.nil?
        screens.each_with_index do |s, index|
          if s == screen
            result = index
          end
        end
      end
    end

    result
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    # Return YES for supported orientations
    interfaceOrientation == UIInterfaceOrientationPortrait
  end
end