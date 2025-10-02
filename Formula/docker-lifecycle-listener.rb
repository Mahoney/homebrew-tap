class DockerRequirement < Requirement
  fatal true

  satisfy(build_env: false) { which("docker") }

  def message
    <<~EOS
      docker is required; install it via:
        brew install --cask docker
    EOS
  end
end

class DockerLifecycleListener < Formula
  desc "Allows running arbitrary commands on start and stop of the docker daemon"
  homepage "https://github.com/Mahoney/docker-lifecycle-listener"
  url "https://github.com/Mahoney/docker-lifecycle-listener/refs/tags/1.0.3"
  sha256 "51a5e5d20389065e19be4011072d5032507f2a5db68d6e5a9c8c067e0093511b"
  license "AGPL-3.0-or-later"

  depends_on DockerRequirement

  NOTIFIER_NAME = "docker-lifecycle-notifier".freeze

  def install
    sbin.install "docker-lifecycle-listener.sh"

    system "docker", "build", ".", "-t", NOTIFIER_NAME
    begin
      system "docker", "rm", "-f", NOTIFIER_NAME
    rescue BuildError
      # deliberately swallowing - don't care if the container doesn't exist
    end
    system "docker", "run",
           "--detach",
           "--restart", "always",
           "--name", NOTIFIER_NAME,
           NOTIFIER_NAME

    (etc/"docker-lifecycle-listener.d/on_start").mkpath
    (etc/"docker-lifecycle-listener.d/on_stop").mkpath
  end

  def caveats
    <<~EOS
      A full uninstall requires removing the docker container and image:
        docker rm -f #{NOTIFIER_NAME}
        docker image rm #{NOTIFIER_NAME}

      To prevent docker-lifecycle-listener being a backdoor for untrusted code
      it requires #{etc}/docker-lifecycle-listener.d and everything
      within it to be owned by root and only writable by root.

      You must change the ownership manually:
        sudo chown -R root:admin #{etc}/docker-lifecycle-listener.d
    EOS
  end

  service do
    run [opt_sbin/"docker-lifecycle-listener.sh", etc/"docker-lifecycle-listener.d"]
    log_path var/"log/docker-lifecycle-listener.log"
    error_log_path var/"log/docker-lifecycle-listener.log"
    keep_alive true
    require_root true
  end

  test do
    script_dir=Dir.mktmpdir
    r, w = IO.pipe
    pid = Process.spawn("#{sbin}/docker-lifecycle-listener.sh #{script_dir} 47202", out: w, err: [:child, :out])
    sleep 3
    Process.kill "TERM", pid
    Process.waitpid pid
    w.close

    output = r.read
    r.close

    assert_includes output, "Listening for commands on port 47202"
    assert_includes output, "Stopped"
  end
end
