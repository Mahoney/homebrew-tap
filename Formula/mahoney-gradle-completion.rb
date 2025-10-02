class MahoneyGradleCompletion < Formula
  desc "Gradle tab completion for bash and zsh"
  homepage "https://github.com/Mahoney-forks/gradle-completion"
  url "https://github.com/Mahoney-forks/gradle-completion/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "22d33881a6ad66f6ea5cce14f3424fb10d03f732cdc16f185c5623c8a24961b7"
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
