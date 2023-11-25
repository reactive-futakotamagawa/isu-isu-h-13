# isu-isu-h

ISUCONで競技者の代わりにsshしていろいろやってくれるツール群

## 中身

### [ansible](./ansible/)

名前の通り

### [observer](./observer/)

計測機器

### [bin](./bin/)

いろいろな実行ファイル

### [files](./files/)

いろいろなファイル

## 運用(2023/11/2時点)

変更はmainブランチに加える。

練習や本番で使うときは、ブランチを切って変数を指定し、共有する。
例:

- ISUCON12予選 -> `isucon12q`
- 2023年の1回目のPISCONで9の予選 -> `23piscon1-9q`

適当に
