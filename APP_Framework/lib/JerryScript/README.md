# jerryscript编译步骤，注意本文档依赖 Ubuntu 20.04 操作系统.
## 1、jerryscript编译依赖工具链安装

第一次编译需要安装依赖，在APP_Framework/lib/JerryScript路径下，依次执行:

```
jerryscript/tools/apt-get-install-deps.sh
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi
sudo apt install \
    bison flex gettext texinfo libncurses5-dev libncursesw5-dev \
    gperf automake libtool pkg-config build-essential gperf genromfs \
    libgmp-dev libmpc-dev libmpfr-dev libisl-dev binutils-dev libelf-dev \
    libexpat-dev gcc-multilib g++-multilib picocom u-boot-tools util-linux
```

## 2、jerryscript源码编译

当前在XiZi操作系统下，支持HC32F4A0单片机和STM32F4单片机两个系列的开发板，在APP_Framework/lib/JerryScript路径下，以edu-arm32开发板(HC32F4A0单片机)为例，进入到APP_Framework/lib/JerryScript下执行:

```bash
jerryscript/tools/build.py \
    --clean \
    --lto=OFF \
    --jerry-cmdline=OFF \
    --jerry-math=ON \
    --amalgam=ON \
    --mem-heap=70 \
    --profile=es.next \
    --toolchain=${PWD}/jerryscript/cmake/toolchain_mcu_hc32f4a0.cmake
```

如果是STM32F4的单片机，将.cmake指定为toolchain_mcu_stm32f4.cmake即可，这一步完成后在APP_Framework/lib/JerryScript/jerryscript/build目录下会编译出几个.a文件，这些文件是接下来的bin包构建过程中需要的。

## 3、开发板bin包构建

以edu-arm32开发板为例进行构建，进入到xiuos/Ubiquitous/XiZi_IIoT目录下，执行:

```makefile
make BOARD=edu-arm32 menuconfig
```

然后在menuconfig界面进入APP_Framework → app lib → lib using JerryScript ，完成勾选；

为了支持javascript文件解析，需要存储.js文件，勾选edu-arm32 feature → Using SD CARD device，使用sd卡进行.js文件的保存;

保存并退出menuconfig，然后执行编译:

```makefile
make BOARD=edu-arm32
```

完成编译后，进行bin包的烧录，edu-arm32开发板的烧录方式参考xiuos/Ubiquitous/XiZi_IIoT/board/edu-arm32/目录下的README.md。

APP_Framework/lib/JerryScript/testfile目录下存放了几个.js文件，可以将这些文件拷贝到内存卡中，也可以自行创建一些.js文件，完成烧录后，插入存有.js文件的内存卡，正确完成挂载后执行:

```shell
jerrytest demo.js
```

会执行一个数组的快速排序demo，打印排序后的数组。
