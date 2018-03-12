# VIM 的配置与插件

VIM 采用 Vundle 管理插件。除去 `.vimrc` 之外，首次使用前需要确保 `.vim/.vimrc.bundles` 文件以及 `vundle` 文件夹已经就位。如果没有网络，其余插件也需要一并到位。

需要注意，和 Emacs 24 以后自带的 melpa 不同，Vundle 不能自动安装插件。更新列表后需进入 VIM，手动输入 `:BundleInstall` 方可安装。

## 插件

 - nerdtree : 文件树

 - rainbow : 括号着色器

 - vim-airline : 状态栏

 - vim-buftabline : 标签页

   - 标签页的切换方式绑定为 <C-Left>/<C-Right> 或 <M-Left>/<M-Right>

 - vim-colors-github : 抄来的，目前不知道有什么用

 - vim-monokai : Monokai 主题

 - vundle : 插件管理器

具体内容与 github 路径以 `.vimrc` 内的设置为准。

## 键配置

 - C-t : 切换块折叠

 - [F2] : 打开设置页

 - [F8] : 打开文件树

 和 Emacs 是一致的，只不过没有绑定多光标操作。
