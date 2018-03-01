# Frameworks

保存手工导入的第三方依赖。

Realm 官方 pod 对网络要求太高（还是源码编译的），如果是预编译的包也上百 MB，如果通过 git 传也是痛苦。于是没包含在仓库内，需要手工导入。
方法：到 https://github.com/realm/realm-cocoa/releases 下载 objc 的预编译包，解压，把静态库拷过来就行了。
