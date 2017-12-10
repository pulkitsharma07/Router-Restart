require 'selenium-webdriver'
require_relative 'state_manager'
require_relative 'network_analyzer'
require_relative 'router_automation'

NetworkAnalyzer.configure(ENV["SSID"])

def restart_router
  return unless NetworkAnalyzer::ping?("192.168.1.1")
  return if NetworkAnalyzer::are_you_fcking_sure_you_can_ping?("8.8.8.8")
  StateManager::update_state("Offline, Restarting.")
  RouterAutomation.do_restart
end

loop do
  if NetworkAnalyzer::internet_connected?
    StateManager::update_state("Online !")
  else
    restart_router
  end

  sleep 1
end
