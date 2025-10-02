class MahoneyGradleCompletion < Formula
  desc "Gradle tab completion for bash and zsh"
  homepage "https://github.com/Mahoney-forks/gradle-completion"
  url "https://github.com/Mahoney-forks/gradle-completion/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "873ee5d3fcd416d6400bbeff0729343e3a85d60914a7dc3d664baf9ff726caa5"
  license "MIT"

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
