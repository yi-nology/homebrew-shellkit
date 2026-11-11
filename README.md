# shellkit tap

Homebrew tap for [shellkit](https://github.com/yi-nology/shellkit) —— 写运维 shell 的起点：
一个约束清晰的 Bash 库、一个脚手架生成器、一套 CLI 框架。基线是 Bash 3.2+。

## 装

    brew install yi-nology/shellkit/shellkit

装完直接用：

    shellkit new ./ops-tool --cmd deploy --cmd status
    shellkit doctor

## 关于这个仓

只有 `Formula/shellkit.rb` 一个文件，而且它是**生成物**：
上游仓的 `tools/brew_formula.sh` 生成它，sha256 取自对应 release 的
`SHA256SUMS`（Homebrew 要求逐字节一致，手抄必错）。

发新版本之后，这个 formula 会跟着更新到新版本号。
