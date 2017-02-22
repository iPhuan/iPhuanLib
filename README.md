<!--
 # iPhuan Open Source
 # iPhuanLib
 # Created by iPhuan on 2017/2/22.
 # Copyright © 2017年 iPhuan. All rights reserved.
 -->

<a name="iPhuanLib">iPhuanLib</a>
=============================================================  
iPhuanLib是本人在平时的开发过程中知识积累后整理出来的一套可直接用于开发的框架，包含了平时自己写的一些工具类，视图控件，以及基于别人的代码修改优化后的基础类等。用意在于跟大家一起分享自己在平时工作中所摸索的技术和成果，同时也方便一些开发者可以直接基于iPhuanLib来快速启动项目。  
目前集成在iPhuanLib里的类并不多，日后会不断更新资源并跟进优化，当前版本的iPhuanLib还在自测中，等到自测完成后会发布release版本，提供完整demo,并且提供Pod库支持，方便开发者下载使用。  



<a name="Introduce">介绍说明</a>
=============================================================  


<a name="Foundation">Foundation</a>
-------------------------------------------------------------  
Foundation为基础类库目录，一般来说整个iPhuanLib的类都依赖于基础库。  


### <a name="IPHDebug">IPHDebug</a>  
IPHDebug方便开发者在Debug模式下进行项目调试和相关信息的打印。  

> * `IPHLog`，Debug模式下用来打印log；  
> * `IPH_PRINT_METHOD_NAME`，Debug模式下打印函数名； 
> * `IPH_CONDITION_PRINT`，Debug模式下根据一定的条件来打印log；  


### <a name="IPHCommonMacros">IPHCommonMacros</a>  
IPHCommonMacros为一些常用的宏定义命令，为开发者在编写代码时提供便捷。  

IPHCommonMacros包含了一些单列类的宏定义，几何宏定义，条件判断宏定义等等，直接查看`IPHCommonMacros.h`文件便一目了然。





