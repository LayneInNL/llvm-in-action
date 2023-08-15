# 编译clang

## 网络资料
官方文档很好的阐述了编译需要的前提条件和步骤。同学们可参阅[Getting Started with the LLVM System](https://llvm.org/docs/GettingStarted.html#getting-started-with-the-llvm-system)和[Getting Started: Building and Running Clang](https://clang.llvm.org/get_started.html)理解如何编译。

以下一些中文文章阐述了如何在Windows，Linux和MacOS上进行编译操作。
1. [Windows下编译LLVM](https://www.cnblogs.com/qiuweidong/p/16215647.html)
2. [LLVM的编译安装和基本使用](https://www.cnblogs.com/robotech/p/16370415.html)
3. [编译和安装LLVM整个流程](https://zhuanlan.zhihu.com/p/636632899)


## 本人操作

本人使用MacBook Pro 14-inch。我的编译步骤如下：
1. 在此项目根目录创建build文件夹。`mkdir build`
2. 切入build文件夹。`cd build`
3. 执行cmake命令生成编译配置文件。`cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_TARGETS_TO_BUILD="AArch64" ../llvm`
4. 执行ninja命令进行编译。`ninja`
5. 查看编译产物。可执行程序在bin目录下，你也可以看到编译得到的clang可执行程序。`ls bin/clang++`
6. cmake命令中的各个参数都代表什么？可参阅(Building LLVM with CMake)[https://llvm.org/docs/CMake.html]。