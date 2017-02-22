<!--
 # iPhuan Open Source
 # iPhuanLib
 # Created by iPhuan on 2017/2/22.
 # Copyright © 2017年 iPhuan. All rights reserved.
 -->

<a name="iPhuanLib">iPhuanLib</a>
=============================================================  
iPhuanLib是本人在平时的开发过程中知识积累后整理出来的一套可直接用于开发的框架，包含了平时自己写的一些工具类，视图控件，以及基于别人的代码修改优化后的基础类等。用意在于跟大家一起分享自己在平时工作中所摸索的技术和成果，同时也方便一些开发者可以直接基于iPhuanLib来快速启动项目。  
目前集成在iPhuanLib里的类并不多，日后会不断更新资源并跟进优化，当前版本的iPhuanLib还在自测中，等到自测完成后会发布release版本，提供完整demo，并且提供Pod库支持，方便开发者下载使用。  


<br />
<a name="Introduce">介绍说明</a>
=============================================================  
<br />


<a name="Foundation">Foundation</a>
-------------------------------------------------------------  
Foundation为基础类库目录，一般来说整个iPhuanLib的类都依赖于Foundation基础库。  


### <a name="IPHDebug">IPHDebug</a>  
IPHDebug方便开发者在Debug模式下进行项目调试和相关信息的打印。  

> * `IPHLog`，Debug模式下用来打印log；  
> * `IPH_PRINT_METHOD_NAME`，Debug模式下打印函数名； 
> * `IPH_CONDITION_PRINT`，Debug模式下根据一定的条件来打印log；  


### <a name="IPHCommonMacros">IPHCommonMacros</a>  
IPHCommonMacros为一些常用的宏定义命令，为开发者在编写代码时提供便捷。  
IPHCommonMacros包含了一些单列类的宏定义，几何宏定义，条件判断宏定义等等，直接查看`IPHCommonMacros.h`文件便可一目了然。  


### <a name="IPHBaseModel">IPHBaseModel</a>  
IPHBaseModel为基础模型类，主要方便开发者可直接通过数据字典对对象进行初始化。与大家平常使用的主流的基础模型类不同的是，IPHBaseModel做了更大的改进和优化，IPHBaseModel不仅可以直接对字符串的属性进行映射初始化，还能对对象属性，数组属性进行映射，类似于响应链的模式可进行多级的数据处理和初始化。  
  
开发者需要继承于IPHBaseModel来进行使用，以下是对各个API做的相关说明：  

* **`- (NSDictionary *)attributeMapDictionary;`**  

> 对象属性映射字典。开发者在子类中重写该方法，并返回一个可用的字典。其中字典的Key为属性的名称，Value为方法`initWithDictionary:`中字典参数的Key，通过该映射方法，IPHBaseModel在初始化对象时才知道怎么从数据字典中取值并进初始化。   
> 假设Json数据中root为一个酒店信息字典，包含了`name`，`hotle_id`，`recommended_room`，`room_list`等字段，其中`recommended_room`对应于一个推荐房间的字典，包含了房间的各个信息，room_list为一个数组，数组里面也是房间的字典，我们首先建立了一个叫`IPHRoom`的对象用来接收房间的信息，再建立一个`IPHHotle`的对象用来接收整个酒店的信息，`IPHRoom`和`IPHHotle`都继承于`IPHBaseModel`，于是我们可以在`IPHHotle`对象的`attributeMapDictionary`方法中这么写：  

```objective-c
    - (NSDictionary*)attributeMapDictionary{
        return @{@"hotleName":@"name",
                 @"hotleId":@"hotle_id",
                 @"recommendedRoom":@"recommended_room",
                 @"rooms":@"room_list",
                 @"address":@"address"};
    }
```   

> Key都为`IPHHotle`的属性名称，Value则为Json数据中对应的字段，通过该映射IPHBaseModel则自动给对应属性赋值。  


* **`- (NSDictionary *)attributeTypesMapDictionary;`**    

> 个别对象属性，数组属性其对应数据的类型映射。在`attributeMapDictionary`方法的介绍中，我们有提到Json数据中`recommended_room`和`room_list`对应于字典和数组数据，相应的`IPHHotle`对象中，`recommendedRoom`对应于`IPHRoom`对象，`rooms`为一个数组，数组中的元素都为`IPHRoom`对象，那么IPHBaseModel在给`IPHHotle`初始化的时候怎么就能将单纯的字典和数组数据，转化为符合要求的对象数据呢，此时`attributeTypesMapDictionary`就起了至关重要的作用。如以下代码示例：  

```objective-c
    - (NSDictionary*)attributeTypesMapDictionary{
        return @{@"recommendedRoom":@"IPHRoom",
                 @"rooms":@"IPHRoom"};
    }
```  

> 我们在映射中指定了`recommendedRoom`和`rooms`属性其数据类型为`IPHRoom`对象，通过该映射IPHBaseModel才能对二级数据进行处理，否则只能直接赋值没有经过处理的字典和数组数据。  

> 同理，在`IPHRoom`中我们同样可以拥有对象和数组属性，当然前提是数据类型都为`IPHBaseModel`的子类对象，通过这种响应链方式的映射关系，一级一级的将数据初始化下去。   

> 当然该映射你也可以不重新返回空字典，然后自己手动对`recommended_room`和`room_list`字段的数据进行特别处理。IPHBaseModel在初始化数据的时候调用了属性的Set方法，所以你只需要重写set方法，代码示例：  

```objective-c
    - (void)setRooms:(NSArray *)rooms{
        id obj = nil;
        if ([rooms isKindOfClass:[NSArray class]] && rooms.count > 0) {
            obj = rooms[0];
        }

        // 如果rooms元素的类型为字典则手动进行数据处理
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *roomList = [[NSMutableArray alloc] initWithCapacity:rooms.count];
            for (NSDictionary *roomDic in rooms) {
            IPHRoom *room = [[IPHRoom alloc] initWithDictionary:roomDic];

            // 特殊数据处理
            room.hotel = self;
            [roomList addObject:room];
            }
            _rooms = [[NSArray alloc] initWithArray:roomList];
            return;
        }

        // 如果rooms元素已经为IPHRoom对象，则直接赋值
        _rooms = rooms;
    }
```    

> 一般建议通过`attributeTypesMapDictionary`映射的方式让IPHBaseModel自动处理数据，除非你对数据的处理有特别要求，比如代码示例，需要单独再给数组中的`IPHRoom`对象设定`hotel`，此时可以进行手动处理。  
> IPHBaseModel目前只支持对IPHBaseModel对象的属性，以及存储IPHBaseModel对象的数组属性进行再次数据处理后赋值，这两种类型已基本满足大部分开发者的需求。  



* **`- (NSDictionary *)attributeDefaultValueMapDictionary;`**  

> 属性默认值的映射。当属性的值在初始化后为nil时，通过该映射可以对属性设定默认值。代码示例：  


```objective-c
    - (NSDictionary*)attributeTypesMapDictionary{
        return @{@"address":@"地址未知"};
    }
```    


* **`- (NSArray<NSString *> *)filterStrings;`**  

> 需要过滤的字段。当属性在初始化数据后，值为`filterStrings`数组里面的过滤字符串时，该属性会自动被设置为nil。目前过滤的字段如下：  


```objective-c
    - (NSArray *)filterStrings{
        // 当值为以下字符串时直接设为nil
        return @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null", @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
    }
```  

子类可重写该方法返回自己需要过滤的字符串。`filterStrings`的作用在于屏蔽掉一些从服务器获取的数据中包含空字符串的问题。  



* **`- (instancetype)initWithDictionary:(NSDictionary *)dictionary;`**     

> 通过一个字典对对象进行初始化。注意，`initWithDictionary:`只对`attributeMapDictionary`中映射的属性进行初始化。其他属性在通过该方法初始化后值依然为nil。  


* **`- (NSDictionary *)toDictionary;`**   

> 与`initWithDictionary:`对应，将对象转化为字典，也是基于`attributeMapDictionary`映射来进行转化的，映射中不包含某个属性，其转化后的字典也不包含对应属性的Key。  


<br />
:warning:注意：
* IPHBaseModel会将Number类型的字典数据转化为字符串，你在使用IPHBaseModel创建类时，其对应的属性应当以字符串的形式创建。  
* 不仅仅是`initWithDictionary:`和`toDictionary`基于`attributeMapDictionary`映射来进行数据操作的。其在实现`NSCoding`和`NSCopying`协议时也都是基于`attributeMapDictionary`来处理的，所以一般建议在`attributeMapDictionary`中添加所有对象属性的映射。




















