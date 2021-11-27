class DockerTuntapOsx < Formula
  desc "Allows access to docker containers by IP address from the host"
  homepage "https://github.com/Mahoney-forks/docker-tuntap-osx"
  url "https://github.com/Mahoney-forks/docker-tuntap-osx/archive/0.6.0.tar.gz"
  sha256 "563a4c2a801e67bce9237d73fea45c7c3614c65d1d8c43a9cff2b2b265cc5b49"
  license "MIT"

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
      This formula requires tuntap formula; see:
      https://formulae.brew.sh/cask/tuntap

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
