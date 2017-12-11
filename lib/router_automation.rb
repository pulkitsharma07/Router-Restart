require 'selenium-webdriver'

module RouterAutomation
  def self.configure(address, username, password)
    @@address = address
    @@username = username
    @@password = password
  end

  def self.do_restart
    return unless NetworkAnalyzer::connected_to_home_network? # Only restart when connected to home network
    return unless self::can_connect_to_router?
    print "Restarting router at #{Time.now}\n"
    driver = Selenium::WebDriver.for :firefox
    driver.get("http://#{@@username}:#{@@password}@#{@@address}")
    driver.switch_to.frame(1)
    driver.execute_script("document.getElementById('a52').click();");
    driver.switch_to.parent_frame
    driver.switch_to.frame(2)
    sleep 2
    driver.find_element(:id, "reboot").click()
    driver.switch_to.alert.accept
    driver.quit
  end

  def self.can_connect_to_router?
    NetworkAnalyzer::ping?(@@address)
  end
end
