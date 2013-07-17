class RestyTest::Config
  include Singleton

  attr_writer :source, :logger, :build_opts, :config_file
  attr_accessor :root

  def source
    @source ||= "http://openresty.org/download/ngx_openresty-1.2.8.6.tar.gz"
  end

  def logger
    @logger ||= Logger.new(STDOUT).tap do |l|
      l.level = Logger::INFO
    end
  end

  def config_file
    @config_file ||= File.expand_path("../nginx.conf", RestyTest.paths.root)
  end

  def build_opts
    @build_opts ||= ["--with-luajit", *platform_specific_build_options]
  end

  private

    def platform_specific_build_options
      case RUBY_PLATFORM
      when /darwin/i
        pcre = Dir["/usr/local/Cellar/pcre/*/include", "/usr/local/pcre/*/include"].sort[-1]
        if pcre
          ["--with-cc-opt='-I#{pcre}'", "--with-ld-opt='-L#{File.dirname(pcre)}/lib'"]
        else
          []
        end
      else
        []
      end
    end

end
