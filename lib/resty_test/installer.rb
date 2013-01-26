class RestyTest::Installer
  include Singleton

  def download!
    return if File.file?(paths.tar)

    log "Downloading #{File.basename(paths.tar)}", :info
    FileUtils.mkdir_p(paths.root)
    File.open(paths.tar, "wb") do |file|
      Excon.get RestyTest.config.source, response_block: lambda {|c, _, _| file.write(c) }
    end
  end

  def extract!
    download!
    return if File.file?(File.join(paths.src, "configure"))

    log "Extracting source", :info
    sh  "cd #{paths.root} && mkdir -p src && /usr/bin/env tar xzf #{paths.tar} -C src --strip-components 1"
  end

  def configure!
    extract!
    return if File.file?(File.join(paths.src, "Makefile"))

    log "Configuring", :info
    sh  "cd #{paths.src} && ./configure --prefix='#{paths.root}' #{opts}"
  end

  def install!
    configure!
    return if File.file?(paths.nginx_bin)

    log "Building & installing", :info
    sh  "cd #{paths.src} && make && make install"
  end

  protected

    def sh(cmd)
      log cmd
      log `#{cmd}`
      raise "Abort!" unless $? == 0
    end

    def paths
      RestyTest.paths
    end

    def opts
      RestyTest.config.build_opts.join(" ")
    end

    def log(message, level = :debug)
      RestyTest.logger.send(level, message)
    end

end