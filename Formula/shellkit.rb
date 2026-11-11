# shellkit —— 写运维 shell 的起点：Bash 库 + 脚手架生成器 + CLI 框架。
#
# 这个文件是**生成物**：改它没用，下次发版会被 tools/brew_formula.sh 覆盖。
# 要改内容就改生成器（tools/brew_formula.sh）。
class Shellkit < Formula
  desc "Bash library and project scaffolding generator (Bash 3.2 baseline)"
  homepage "https://yi-nology.github.io/shellkit/"
  version "0.15.0"
  url "https://github.com/yi-nology/shellkit/releases/download/v0.15.0/shellkit-0.15.0.tar.gz"
  sha256 "eb177aa24d49e37f8c0032bb138b193926d6277822d86928e4af27fb7670224b"

  def install
    # 库、模板、语言包、文档、skill 包 —— CLI 靠自己在旁边的目录里找它们
    %w[lib templates locale po tools docs skills].each do |dir|
      libexec.install dir
    end
    libexec.install "shellkit"
    libexec.install "README.md" if File.exist?("README.md")
    libexec.install "LICENSE" if File.exist?("LICENSE")
    libexec.install "NOTICE" if File.exist?("NOTICE")
    bin.install_symlink libexec/"shellkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellkit --version")
    assert_match "library modules", shell_output("#{bin}/shellkit list")
  end
end
