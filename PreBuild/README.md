# PreBuild

<!--
查看渲染好的页面：
https://github.com/BB9z/iOS-Project-Template/blob/master/PreBuild/README.md
-->

项目预编译，整合依赖，加快编译的同时，简化对依赖进行修改的流程。

## 背景

> 对于比较大的项目，编译一次动辄十几甚至几十分钟，不少项目会把项目的一部分提取出来编译成二进制库，用以减少编译时间。
>
> 预编译一般有两种选择，动态库、静态库。动态库绝大多数需要自包含，不能引入外部文件但不包含进来（虽然技术上是可行的）。静态库适合大多数情况，比如 CocoaPods 源码编译出来的中间文件就是静态库。
>
> 编译库时的配置会影响行为，比如说 debug 和 release 的区别，正常分发时应该以 release 编译，但带来的不便是调试项目时可能看不到依赖源码的。想要支持调试只能用 debug 再编译。
>
> 除了配置外，还需要考虑如何分发，是打压缩包上传再 HTTP 下载，用包管理工具，还是直接拷贝？

PreBuild 把依赖结构整合到项目中，解决了调试时看不到依赖源码的问题，而且便于对依赖进行测试、修改。

<details>
<summary>原理详解</summary>
预编译就是通过事先把代码、资源准备好了，不用在每次跑或者打包时再去编译、处理，从而节省了时间。

正常我们 debug 跑的时候，因为有编译缓存，每次只编译修改的文件，所以很快。但一但换到另一个不同架构的设备或者打包，缓存失效就要等比较长的时间。

预编译麻烦的地方之一是需要把各种架构的二进制合在一起，这要写点脚本才能自动化。project-framework 大概干的就是把每个组件打成一个 .a 静态库，带着头文件一起拷贝到指定目录里。
再利用 CocoaPods 提供的管理功能，可以避免手动把包加到项目里。

如果通过 CocoaPods 引入源码库，每次 pod install、打包时都要重新编译一次，比较烦。为了解决这个问题引入了 pods-combine，把这些源码依赖再打成一个通用的二进制包。
</details>

## Howto

### 安装依赖

<details>
<summary>我只想让项目跑起来</summary>

执行 fastlane 命令即可

```shell
fastlane setup_project
```

</details>

### 修改依赖

<details>
<summary>添加（移除）第三方库</summary>

你需要先了解一下上面的 原理详解。

* 如果第三方库是编译好的二进制包（拿到的是 .a 文件或 framework 包），且能通过 CocoaPods 引入

    通过主项目的 pod 直接引入

* 如果第三方库是编译好的二进制包（拿到的是 .a 文件或 framework 包），但不能通过 CocoaPods 引入
    
    手动添加到 App 所在的项目里

* 如果第三方是源码分发的，但因为一些原因不能通过 CocoaPods 引入
    
    1. 创建 target，可以直接复制「样例」target；
    2. 手动源码添加到 project-framework.xcodeproj，添加的时候可以选中添加到哪个 target，免去后面在 target 中手动添加需要编译的源文件；
    3. 检查 target 的 Compile Source，把头文件和 libxxx.a 输出添加到「拷贝输出」中；
    4. 把新加的 target 作为依赖添加到 build-all-parts 中；
    5. 执行 fastlane setup_project 更新项目。

* 第三方通过源码分发，可通过 CocoaPods 引入

    1. 修改 pods-combine 的 Podfile，把依赖加进来；
    2. 打开 pods-combine 项目，把新增的头文件加入到「Headers From Pods」中
    3. 修改 pods-combine.framework 的头文件配置；
    4. 把新增的 lib.a 加入到 pods-combine.framework 的 Link Binary With Libraries 中；
    5. 执行 fastlane update_pods_combine 更新项目。

</details>

### 调试依赖

一般这种情况都是通过源码方式引入到 project-framework 中的情形，如果没有增删文件、项目已经设置好了的话，每次修改只需要重新 build 一下对应的 target 即可。
