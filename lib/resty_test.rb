require 'fileutils'
require 'excon'
require 'singleton'
require 'logger'

module RestyTest
  require 'resty_test/config'
  require 'resty_test/paths'
  require 'resty_test/installer'

  class << self
    attr_reader :running

    def configure
      yield config
    end

    def config
      self::Config.instance
    end

    def installer
      self::Installer.instance
    end

    def paths
      RestyTest::Paths.instance
    end

    def logger
      config.logger
    end

    def start!
      installer.install!
      system "#{paths.nginx_bin} -c #{config.config_file}"
      @running = true
    end

    def stop!
      return unless File.file?(paths.nginx_bin) && running
      system "#{paths.nginx_bin} -s stop"
      @running = nil
    end

    def reload!
      return unless File.file?(paths.nginx_bin) && running
      system "#{paths.nginx_bin} -s reload"
    end

  end

  root = caller.detect {|path| path =~ /^(.+?\/(?:test|spec|features))\// }
  config.root = "#{$1}/resty" if root

  at_exit do
    stop!
  end
end
