require 'timeout'
require 'resolv'

module NetworkAnalyzer

  def self.configure(home_ssid)
    @@is_win = RbConfig::CONFIG['host_os'] =~ /mingw/

    raise "Please give your Wifi Network's SSID as an environment variable." if !@@is_win && home_ssid.nil?
    @@home_ssid = home_ssid
  end

  def self.current_SSID
   `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`.strip
  end

  def self.connected_to_home_network?
    if @@is_win # Stay_Home
      return true
    else
      self::current_SSID == @@home_ssid
    end
  end

  def self.internet_connected?(tries = 4)
    return true unless self::connected_to_home_network? # Only restart when connected to home network
    can_connect = 0

    tries.times do
      begin
        Timeout::timeout(1) do
          Resolv.getaddress('a.root-servers.net')
          can_connect += 1
        end
        sleep 1
      rescue => e
      end
    end

    can_connect > tries/2
  end

  # Returns true, if no packet loss
  def self.ping?(address)
    packet_loss = `ping #{address} -c1 -s1 -W1000 | cut -d"," -f 3 | tail -1`.strip
    packet_loss =~ /^0.0% packet loss/ && $?.exitstatus == 0
  end
end
