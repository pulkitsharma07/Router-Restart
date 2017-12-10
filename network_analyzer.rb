module NetworkAnalyzer
  @@home_ssid

  def self.configure(home_ssid)
    @@home_ssid = home_ssid
  end

  def self.current_SSID
   `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`.strip
  end

  def self.connected_to_home_network?
    self::current_SSID == @@home_ssid
  end

  def self.internet_connected?
    return true unless self::connected_to_home_network? # Only restart when connected to home network
    self::ping?("8.8.8.8")
  end

  # Returns true, if no packet loss
  def self.ping?(address)
    packet_loss = `ping #{address} -c1 -s1 -W1000 | cut -d"," -f 3 | tail -1`.strip

    packet_loss =~ /^0.0% packet loss/
  end

  def self.are_you_fcking_sure_you_can_ping?(address)
    return true if self::ping?(address)
    sleep 1
    return true if self::ping?(address)
    sleep 0.5
    return true if self::ping?(address)

    false
  end
end
