require_relative './lib/state_manager'
require_relative './lib/network_analyzer'
require_relative './lib/router_automation'

NetworkAnalyzer.configure(ENV["SSID"])
RouterAutomation.configure("192.168.1.1", "admin", "admin")

def restart_router
  StateManager::update_state("Offline, Restarting.")
  RouterAutomation.do_restart
  RouterAutomation.do_restart
  p "SSD"
end

loop do
  if NetworkAnalyzer::internet_connected?
    StateManager::update_state("Online !")
  else
    restart_router
  end

  sleep 1
end
