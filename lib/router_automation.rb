require 'selenium-webdriver'

module RouterAutomation
  def self.do_restart
    p "Restarting router at #{Time.now}"
    driver = Selenium::WebDriver.for :firefox
    driver.get("http://admin:admin@192.168.1.1")
    driver.switch_to.frame(1)
    driver.execute_script("document.getElementById('a52').click();");
    driver.switch_to.parent_frame
    driver.switch_to.frame(2)
    sleep 2
    driver.find_element(:id, "reboot").click()
    driver.switch_to.alert.accept
    driver.quit
  end
end
