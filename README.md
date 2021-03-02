# AppAssistant-开发小助手

## 介绍

 为了提升开发效率，尽量多的在集成测试中发现问题，小助手提供了各种辅助工具。也适用于测试与UI快速定位为题，具体功能介绍移步[DoraemonKit](https://github.com/didi/DoraemonKit)。

由于DoraemonKit官方部分模块没有Swift化，结合实际情况修改了面板入口

## 功能

##### 现有模块：

常用工具、性能检测、视觉工具

##### 增加模块：

环境切换

##### 重写模块：

模拟定位、帧率监控、CPU监控、内存监控、流量控制、卡顿监控、方法耗时，启动耗时、crash、内存泄漏


## 集成

##### 私有Repo:

```ruby
pod 'AppAssistant', :path => '../', :inhibit_warnings => false
```

##### 源码集成：

引入源码文件和资源文件

```ruby
s.source_files = 'AppAssistant/Src/**/**/*.{h,m,c,mm,swift}'
s.resource_bundles = {
    'AppAssistant' => 'AppAssistant/Resource/**/*'
}
```

##### framework集成：

<!--如未装xcpretty，请执行gem install xcpretty-->

在`shell`目录下执行`framework.sh`脚本生成`framework`

成功生产会打印如下语句

```sh
************************************************************ Create framework success

```

生成产物在build目录下的`AppAssistant.framework`

之后拷贝`AppAssistant.framework`到framework目录下

注释源码引入`s.source_files`、`s.resource_bundles` 

进入Example目录重新执行pod install

## 使用

一键显示


```swift
AppAssistantKit.install()
```

注册当前网络环境


```swift
AppAssistantKit.registerEnv(["开发", "测试"]) { (env) in
   print("选择了\(env)")
}
```

