# shellkit —— 写运维 shell 的起点：Bash 库 + 脚手架生成器 + CLI 框架。
#
# 这个文件是**生成物**：改它没用，下次发版会被 tools/brew_formula.sh 覆盖。
# 要改内容就改生成器（tools/brew_formula.sh）。
class Shellkit < Formula
  desc "Bash library and project scaffolding generator (Bash 3.2 baseline)"
  homepage "https://yi-nology.github.io/shellkit/"
  version "1.7.0"
  url "https://github.com/yi-nology/shellkit/releases/download/v1.7.0/shellkit-1.7.0.tar.gz"
  sha256 "7aae0ec73b95cfd61c49c6cdafb240f66bb272d2258e9d824d499236dbe8f316"

  def install
    # 库、模板、语言包、文档、skill 包 —— CLI 靠自己在旁边的目录里找它们
    %w[lib templates locale po tools docs skills].each do |dir|
      libexec.install dir
    end
    libexec.install "shellkit"
    # VERSION 必须装：CLI 的版本就是从**旁边**的 VERSION 读的（lib/bootstrap.sh）。
    # 漏了它 ⇒ SK_VERSION 退成 "dev" ⇒ ① --version 报 dev（用户看不到真实
    # 版本）；② 更要命的是 "shellkit skill install" 把 dev 当成「期望版本」
    # ⇒ 期望版本成了 unknown ⇒ **任何一次 skill 安装/升级都被自己的版本
    # 检查挡住**（连 --force 也救不了）—— 这正是「旧副本永远升不上」的形态。
    libexec.install "VERSION" if File.exist?("VERSION")
    libexec.install "README.md" if File.exist?("README.md")
    libexec.install "LICENSE" if File.exist?("LICENSE")
    libexec.install "NOTICE" if File.exist?("NOTICE")
    bin.install_symlink libexec/"shellkit"
    # 装完当场自检。不能只靠下面 test 块里的断言：brew test 只有跑
    # "brew test" 或 CI 时才执行 ⇒ 普通的 "brew install" 不跑
    # ⇒ 漏文件会一路溜到用户手里（2026-11-20 实测：用户拿到的是
    # 「--version 报 dev，且 skill 装不上」）。这里当场 raise
    # ⇒ 漏文件当场炸，发版的人立刻看见，而不是等用户来报。
    ver_file = libexec/"VERSION"
    raise "VERSION was not installed: the CLI would report 'dev'" unless ver_file.exist?
    got = ver_file.read.strip
    raise "VERSION says #{got.inspect}, expected #{version}" unless got == version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellkit --version")
    assert_match "library modules", shell_output("#{bin}/shellkit list")
  end
end
