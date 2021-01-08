class DockerTuntapOsx < Formula
  desc "Allows access to docker containers by IP address from the host"
  homepage "https://github.com/Mahoney-forks/docker-tuntap-osx"
  url "https://github.com/Mahoney-forks/docker-tuntap-osx/archive/0.4.0.tar.gz"
  sha256 "6ee477e1b9813070a381a448ddf67cb4c894236025e171ae0b97166be3988a6a"
  license "MIT"

  bottle :unneeded

  depends_on :tuntap
  depends_on "docker-lifecycle-listener"

  def install
    sbin.install "sbin/docker.hyperkit.tuntap.sh"
    sbin.install "sbin/docker_tap_install.sh"
    sbin.install "sbin/docker_tap_up.sh"
    sbin.install "sbin/docker_tap_up_routes.sh"

    bin.install "sbin/docker_tap_uninstall.sh"

    on_start_dir = etc/"docker-lifecycle-listener.d/on_start"
    begin
      on_start_dir.install_symlink opt_sbin/"docker_tap_install.sh"
      on_start_dir.install_symlink opt_sbin/"docker_tap_up.sh"
      on_start_dir.install_symlink opt_sbin/"docker_tap_up_routes.sh"
    rescue
      puts <<~EOS
        Unable to link into #{on_start_dir}; you must do this manually:
          sudo ln -sf #{opt_sbin}/docker_tap_* #{on_start_dir}/
      EOS
    end
  end

  def caveats
    <<~EOS
      A full uninstall requires running the uninstall script *before* doing a
      brew uninstall:
        #{opt_bin}/docker_tap_uninstall.sh

      You must manually make root own the scripts:
        sudo chown root #{sbin}/docker_tap_*
    EOS
  end

  test do
    system "true"
  end
end
