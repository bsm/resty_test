class RestyTest::Paths
  include Singleton

  def root
    RestyTest.config.root
  end

  def tar
    File.join(root, File.basename(RestyTest.config.source))
  end

  def src
    File.join(root, "src")
  end

  def nginx_bin
    File.join(root, "nginx", "sbin", "nginx")
  end

end