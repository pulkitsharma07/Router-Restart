#MASSIVE TODO: CLEANUP
require 'selenium-webdriver'
require 'terminal-notifier'
HOME_SSID = ENV["SSID"]
state = ""

def restart_router
  return unless can_ping?("192.168.1.1")
  return if are_you_fcking_sure_you_can_ping?("8.8.8.8")
  state = update_state("Offline, Restarting.", state)
  p "Restarting router at #{Time.now}"
  driver = Selenium::WebDriver.for :firefox
  driver.get("http://admin:admin@192.168.1.1")
  driver.switch_to.frame(1)
  driver.execute_script("document.getElementById('a52').click();");
  driver.switch_to.parent_frame
  driver.switch_to.frame(2)
  sleep 2
  driver.find_element(:id, "reboot").click()
  unless can_ping?("8.8.8.8")
    driver.switch_to.alert.accept
  else
    driver.switch_to.alert.dismiss
  end
  driver.quit
end


def update_state(new_state, state)
  return state if new_state == state
  state = new_state
  TerminalNotifier.notify(state, :title => 'Router Restart v0.0.1', :subtitle => 'Connection Status')

  new_state
end

def can_ping?(address)
  packet_loss = `ping #{address} -c1 -s1 -W1000 | cut -d"," -f 3 | tail -1`.strip

  packet_loss =~ /^0.0% packet loss/
end

def are_you_fcking_sure_you_can_ping?(address)
  return true if can_ping?("8.8.8.8")
  sleep 1
  return true if can_ping?("8.8.8.8")
  sleep 0.5
  return true if can_ping?("8.8.8.8")

  false
end


def current_SSID
 `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`.strip
end

def home_network?
  current_SSID == HOME_SSID
end

def internet_connected?
  return true unless home_network? # Only restart when connected to home network
  can_ping?("8.8.8.8")
end

loop do
  if internet_connected?
    state = update_state("Online !", state)
  else
    restart_router
  end

  sleep 1
end
