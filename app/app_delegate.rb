class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window = nil
    screens = UIScreen.screens
    @windows = []

    screens.each do |screen|
      viewController = AirplayDemoViewController.alloc.init
      window = self.createWindowForScreen(screen)

      self.addViewController(viewController, toWindow: window)
      viewController = nil

      # If you don't do this here, you will get the "Applications are expected to have a root view controller" message.
      if screen == UIScreen.mainScreen
        window.makeKeyAndVisible
      end
    end

    # Register for notification
    NSNotificationCenter.defaultCenter.
        addObserver(self,
                    selector: 'screenDidConnect:',
                    name: UIScreenDidConnectNotification,
                    object:nil)

    NSNotificationCenter.defaultCenter.
        addObserver(self,
                    selector: 'screenDidDisconnect:',
                    name: UIScreenDidDisconnectNotification,
                    object:nil)

    true
  end

  def applicationWillTerminate(application)
    # Unregister for notifications
    NSNotificationCenter.defaultCenter.removeObserver(self, name: UIScreenDidConnectNotification, object: nil)
    NSNotificationCenter.defaultCenter.removeObserver(self, name: UIScreenDidDisconnectNotification, object:nil)
  end

  def dealloc
    @windows = nil
    super
  end

  def createWindowForScreen(screen)
    window = nil

    @windows.each do |w|
      if w.screen == screen
        window = w
      end
    end

    if window.nil?
      window = UIWindow.alloc.initWithFrame(screen.bounds)
      window.setScreen(screen)
      @windows << window
    end

    window
  end

  def addViewController(controller, toWindow: window)
    window.setRootViewController(controller)
    window.setHidden(false)
  end

  def screenDidConnect(notification)
    screen = nil
    window = nil
    viewController = nil

    screen = notification.object
    viewController = AirplayDemoViewController.alloc.init
    window = self.createWindowForScreen(screen)

    self.addViewController(viewController, toWindow: window)
  end

  def screenDidDisconnect(notification)
    screen = nil
    NSLog "Screen disconnected"

    screen = notification.object
    @windows.each do |window|
      if window.screen == screen
        window_index = @windows.index(window)
        @windows.delete_at(window_index)
        window = nil
      end
    end
  end
end
