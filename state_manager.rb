require 'terminal-notifier'

module StateManager
  @@state = ""

  def self.update_state(new_state)
    return @@state if new_state == @@state

    @@state = new_state
    TerminalNotifier.notify(@@state, :title => 'Router Restart v0.0.1', :subtitle => 'Connection Status', :sound => 'default')
  end

end
