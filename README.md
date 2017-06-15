<!--
 # iPhuan Open Source
 # iPhuanLib
 # Created by iPhuan on 2017/2/22.
 # Copyright © 2017年 iPhuan. All rights reserved.
 -->

<a name="iPhuanLib">iPhuanLib</a>
=============================================================  
iPhuanLib是本人在平时的开发过程中知识积累后整理出来的一套可直接用于开发的框架，包含了平时自己写的一些基础类，工具类，视图控件，以及基于别人的代码修改优化后的类库等。用意在于跟大家一起分享自己在平时工作中所摸索的技术和成果，同时也方便一些开发者可以直接基于iPhuanLib来快速启动项目。  
目前集成在iPhuanLib里的类并不多，日后会不断更新资源并跟进优化，当前iPhuanLib已发布1.0.1版本，提供了完整demo，并且提供Pod库支持，方便开发者下载使用。  


目录
-------------------------------------------------------------
* [如何获取iPhuanLib](#GetiPhuanLib)
* [介绍说明](#Introduce)
    * [Foundation](#Foundation)
        * [IPHCommonMacros](#IPHCommonMacros)
        * [IPHBaseModel](#IPHBaseModel)
        * [IPHBaseModelProtocal](#IPHBaseModelProtocal)
        * [IPHViewNibUtils](#IPHViewNibUtils)
        * [UIView+IPHAdditions](#UIView+IPHAdditions)
    * [Utils](#Utils)
        * [IPHPathUtils](#IPHPathUtils)
    * [Additions](#Additions)
        * [NSTimer+IPHBlockSupport](#NSTimer+IPHBlockSupport)
        * [UIAlertController+IPHAdditions](#UIAlertController+IPHAdditions)
        * [UIViewController+IPHAlertController](#UIViewController+IPHAlertController)
    * [Views](#Views)
        * [IPHHorizontalTableView](#IPHHorizontalTableView)
        * [IPHConditionSelectorView](#IPHConditionSelectorView)
    * [Others](#Others)
        * [IPHLocationManager](#IPHLocationManager)
* [JSCoreBridge](#JSCoreBridge)
* [风险声明](#RiskStatement)
* [开源说明](#OpenSourceDesc)
* [如何联系我](#ContactInfo)  
* [版本更新记录](#UpdateInfo)  



<br />
<br />


<a name="GetiPhuanLib">如何获取iPhuanLib</a>   
-------------------------------------------------------------
1. 直接在GitHub上[获取](https://github.com/iPhuan/iPhuanLib.git)   
2. 通过[CocoaPods](http://guides.cocoapods.org/using/using-cocoapods.html)添加到工程：  

> * 如果你想使用完整版的iPhuanLib，添加以下命令行到Podfile：  

```ruby
pod 'iPhuanLib'
```

> * 如果你想使用iPhuanLib部分模块，可分模块添加：  

```ruby
pod 'iPhuanLib/Foundation'
pod 'iPhuanLib/Utils'
pod 'iPhuanLib/Additions'
pod 'iPhuanLib/Additions/UIKit'
pod 'iPhuanLib/Views'
pod 'iPhuanLib/Views/IPHHorizontalTableView'
pod 'iPhuanLib/Views/IPHConditionSelectorView'
pod 'iPhuanLib/Others'
```  

<br />


<a name="Introduce">介绍说明</a>
=============================================================  

<br />


<a name="Foundation">Foundation</a>
-------------------------------------------------------------  
**Foundation为基础类库目录，一般来说整个iPhuanLib的类都依赖于Foundation基础库。**  


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

**A类属性说明：** 
> * 1、如果一个对象的属性为IPHBaseModel的子类，或者遵循IPHBaseModelProtocal协议，在本文档中称为A类属性；   
> * 2、如果一个对象的属性为数组类型，且该数组中所有的元素都为1中所提的A类属性，则该属性也被称为A类属性。  

<br />


* **`- (NSDictionary *)attributeMapDictionary;`**  

> 对象属性映射字典。开发者在子类中重写该方法，并返回一个可用的字典。其中字典的Key为属性的名称，Value为方法`initWithDictionary:`中字典参数的Key，通过该映射方法，IPHBaseModel在初始化对象时才知道怎么从数据字典中取值并进行初始化。   
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



* **`- (NSDictionary *)attributeDefaultValueMapDictionary;`**  

> 属性默认值的映射。当属性的值在初始化后为nil时，通过该映射可以对属性设定默认值。代码示例：  


```objective-c
    - (NSDictionary*)attributeTypesMapDictionary{
        return @{@"address":@"地址未知"};
    }
```    


* **`- (NSArray<NSString *> *)filterStrings;`**  

> 需要过滤的字段。当属性在初始化数据后，如果值为`filterStrings`数组里面的某个过滤字符串时，该属性会自动被设置为nil。目前过滤的字符串如下：  


```objective-c
    - (NSArray *)filterStrings{
        // 当值为以下字符串时直接设为nil
        return @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null", @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
    }
```  

子类可重写该方法返回自己需要过滤的字符串。`filterStrings`的作用在于屏蔽掉一些从服务器获取的数据中包含空字符串的问题。  



* **`- (NSDictionary *)attributeTypesMapDictionary;`**    

> A类属性其对应数据的类型映射。在`attributeMapDictionary`方法的介绍中，我们有提到Json数据中`recommended_room`和`room_list`对应于字典和数组数据，相应的`IPHHotle`对象中，`recommendedRoom`对应于`IPHRoom`对象，`rooms`为一个数组，数组中的元素都为`IPHRoom`对象，那么IPHBaseModel在给`IPHHotle`初始化的时候怎么就能将单纯的字典和数组数据，转化为符合要求的对象数据呢，此时`attributeTypesMapDictionary`就起了至关重要的作用。如以下代码示例：  

```objective-c
    - (NSDictionary*)attributeTypesMapDictionary{
        return @{@"recommendedRoom":@"IPHRoom",
                @"rooms":@"IPHRoom"};
        }
```  

> 我们在映射中指定了`recommendedRoom`和`rooms`属性其数据类型为`IPHRoom`对象，通过该映射IPHBaseModel才能对二级数据进行处理，否则只能直接赋值没有经过处理的字典和数组数据。  

> 同理，在`IPHRoom`中我们同样可以拥有A类属性，通过这种响应链方式的映射关系，一级一级的将数据初始化下去。   

> 当然该映射你也可以不重写返回空字典，然后自己手动对`recommended_room`和`room_list`字段的数据进行特殊处理。IPHBaseModel在初始化数据的时候调用了属性的Set方法，所以你只需要重写set方法，代码示例：  

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
> 1.0.1版本对于数据的特殊处理做了很好的优化，详细用法请参考`handleAttributeValue:forAttributeName:`。
> IPHBaseModel目前只支持对A类属性进行数据再次处理，这两种类型已基本满足大部分开发者的需求。  


<a name="handleAttributeValue"></a>    
* **`- (__kindof IPHBaseModel *)handleAttributeValue:(__kindof IPHBaseModel *)object forAttributeName:(NSString *)attributeName;`**   

> 对应于`attributeTypesMapDictionary`，1.0.1新增方法，为了方便解决特殊数据处理问题。当IPHBaseModel通过`attributeTypesMapDictionary`映射将对应字典转化为A类属性值之后，会调用该方法，将对象传递过来允许开发人员在该方法中对该对象数据进行二次处理，处理完后IPHBaseModel才将最终的值赋给A类属性。object即为传递过来的对象，通过attributeName可判断对应于哪个A类属性。如`setRooms:`示例中的特殊处理可以通过`handleAttributeValue:forAttributeName:`方法快速实现：   

```objective-c
    - (__kindof IPHBaseModel *)handleAttributeValue:(__kindof IPHBaseModel *)object forAttributeName:(NSString *)attributeName {
        if ([@"rooms" isEqualToString:attributeName]) {
            IPHRoom *room = object;
            room.hotel = self;
            return room;
        }
        return object;
    }

```       


<a name="setup"></a>    
* **`- (void)setup;`**    

> `IPHBaseModel`通过`initWithDictionary:`初始化对象后会调用该方法，开发者可在该方法中进行相关初始化操作。代码示例：

```objective-c
    - (void)setup {
        // 在setup进行其他初始化操作
        self.country = @"美国";
    }

```       



* **`- (instancetype)initWithDictionary:(NSDictionary *)dictionary;`**     

> 通过一个字典对对象进行初始化。注意，`initWithDictionary:`只对`attributeMapDictionary`中映射的属性进行初始化。其他属性在通过该方法初始化后值依然为nil。  


* **`- (NSDictionary *)toDictionary;`**   

> 与`initWithDictionary:`对应，反向将对象转化为字典。如果对象的属性为A类属性则可继续进行字典转化。


* **`- (NSData *)archivedData;`**   

> 获取适用于存档的Data数据，注意，存档时先调用该方法获取Data数据，再通过`[NSUserDefaults standardUserDefaults]`的`setObject:forKey:`方法存档。NSUserDefaults本身不支持自定义对象的存储。



<br />

:warning:注意：
* `IPHBaseModel`会将`Number`类型的字典数据转化为字符串，你在使用`IPHBaseModel`创建类时，其对应的属性应当以字符串的形式创建。  




### <a name="IPHBaseModelProtocal">IPHBaseModelProtocal</a>    

1.0.1版本新增协议类，1.0.0时`IPHBaseModel`基础模型是通过继承来实现，为了便于开发者对对象进行扩展，现提供协议的方式来实现基础模型。    
对象需遵循`IPHBaseModelProtocal`协议并结合`NSObject+IPHBaseModel`分类一起使用来达到`IPHBaseModel`实现的效果。`IPHBaseModelProtocal`协议方法就不需要再详细介绍，和`IPHBaseModel`中对应的方法使用一致，具体对`NSObject+IPHBaseModel`分类的方法进行说明。   


* **`- (instancetype)initWithIphDictionary:(nullable NSDictionary *)dictionary;`**    

> 在使用上和`IPHBaseModel`一致，需要注意的是只有遵循`IPHBaseModelProtocal`协议的对象，才可以通过该方法正常初始化。   


* **`- (nullable NSDictionary *)iph_toDictionary;`**    

> 将一个遵循`IPHBaseModelProtocal`协议的对象反向转化为字典。如果对象不遵循`IPHBaseModelProtocal`协议，则直接返回nil；如果对象的属性为A类属性则可继续进行字典转化。  


* **`- (nullable NSString *)iph_description;`**     

> 通过`iph_toDictionary`方法转化为字典，并输出该字典的UTF-8的`description`，开发者可在对象中重写`description`方法，并调用`iph_description`，如：   
    
```objective-c
    - (NSString *)description {
        return [self iph_description];
    }
 
```      


* **`- (id)iph_copyWithZone:(NSZone *)zone;`**     

> 提供`copyWithZone:`批量处理方法，如你希望某个对象遵循`NSCopying`协议，可调用该方法来进行快速处理，如：   

```objective-c
    - (id)copyWithZone:(NSZone *)zone {
        return [self iph_copyWithZone:zone];
    }

```      



* **`- (void)iph_decodeWithCoder:(NSCoder *)decoder;`**     
* **`- (void)iph_encodeWithCoder:(NSCoder *)encoder;`**     


> 提供`initWithCoder:`和`encodeWithCoder:`批量处理方法，如你希望某个对象遵循`NSCoding`协议，可调用该方法来进行快速处理，如：   

```objective-c
    - (instancetype)initWithCoder:(NSCoder *)aDecoder {
        self = [super init];
        if (self) {
            [self iph_decodeWithCoder:aDecoder];
        }
        return self;
    }

    - (void)encodeWithCoder:(NSCoder *)aCoder {
        [self iph_encodeWithCoder:aCoder];
    }


``` 




### <a name="IPHViewNibUtils">IPHViewNibUtils</a>   
IPHViewNibUtils为Nib加载工具类，方便开发者从xib文件中加载视图或者object对象。  



### <a name="UIView+IPHAdditions">UIView+IPHAdditions</a>   
UIView+IPHAdditions为`UIView`的扩展类，包含了一些图形几何的属性和视图操作的方法。  


<br />

<a name="Utils">Utils</a>
-------------------------------------------------------------  
**Utils为工具类库目录，包含了一些常用的工具类。**    


### <a name="IPHPathUtils">IPHPathUtils</a>  
IPHPathUtils为资源路径获取工具类，通过该工具类可以获取到bundle和沙盒对应资源文件的路径。  


<br />

<a name="Additions">Additions</a>
-------------------------------------------------------------  
**Additions为扩展类库目录，包含了一些常用的扩展类。**    


### <a name="NSTimer+IPHBlockSupport">NSTimer+IPHBlockSupport</a>  
NSTimer的扩展类，使NSTimer能够通过block的方式使用，通过block实现在一定程度上减少了使用NSTimer导致循环引用的问题。  



### <a name="UIAlertController+IPHAdditions">UIAlertController+IPHAdditions</a>  
UIAlertController的扩展类，通过不同的参数来初始化不同的UIAlertController，并提供直接弹出显示的方法。  

:warning:注意：
* `IPHAlertActionHandeler` block中`index`的下标对应的action按钮顺序为`otherActions`，`destructiveAction`，`cancelAction`；  
* 在iPad上请不要直接调用和`show`Action的方法，而应该调用初始化的方法获取实例后，设置`popoverPresentationController`的`sourceView`和`sourceRect`属性后再通过`presentViewController`的方式弹出，否则将不进行弹出操作。因为`show`方法中并没有对`sourceView`和`sourceRect`进行设置，也无法设置。代码实例：  


```objective-c
    UIAlertController *alertController = [UIAlertController
                                            iph_actionSheetControllerWithTitle:@"提示"
                                            message:nil
                                            handler:^(UIAlertAction *action, NSUInteger index) {
                                                switch (index) {
                                                    case 0:
                                                        // 保存图片
                                                        break;
                                                    case 1:
                                                        // 分享图片
                                                        break;
                                                    case 2:
                                                        // 删除图片
                                                        break;
                                            }
                                        }
                                        destructiveActionTitle:@"删除图片"
                                        cancelActionTitle:@"取消"
                                        otherActionTitles:@"保存图片", @"分享图片", nil];
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.sourceRect = self.view.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:alertController animated:YES completion:nil];
```    



### <a name="UIViewController+IPHAlertController">UIViewController+IPHAlertController</a>  
基于UIAlertController+IPHAdditions对UIViewController的扩展，可直接通过UIViewController来弹出UIAlertController的视图。  



<br />

<a name="Views">Views</a>
-------------------------------------------------------------  
**Views为自定义视图类库目录，包含了一些自定义的视图控件**   



### <a name="IPHHorizontalTableView">IPHHorizontalTableView</a>  
可以理解为横向TableView或者为水平的TableView。IPHHorizontalTableView是我13年突发奇想所写的一个很有创新意义的控件，它的奇妙之处在于是将一个正常的TableView逆时针旋转了90°来使用。  
当时在做很多项目的时候经常会遇到横向滑动的需求，比如首页的广告banner，图片预览等，而当时使用的一些自定义控件，在视图的重用上效率并不是很好，滑动的流畅度也有待提高，而系统也并没有给我们提供这样的控件，我当时就想，能不能想办法直接利用系统自带控件的重用机制呢，那样效率会好很多，比如TableView本身，我是不是可以将其旋转一下就可以得到我想要的横向滑动的控件？这一突发奇想激起了我极大的研究兴趣，于是我开始去尝试，发现在实现上特别简单，只需要把TableView逆时针旋转90°，然后所有的cell再顺时针旋转90°，而所有其他API用法也基本都保持和UITableView的一致。我将IPHHorizontalTableView放到项目中进行测试，发现其流畅度特别高，而且兼容性也出乎意料的稳定。  

时隔4年，我再次在项目中添加了IPHHorizontalTableView，依然觉得它用起来非常的方便，因为它基本保留了UITableView能兼容的所有API，用法与UITableView的API几乎相近，而UITableView又是我们平常特别常用的一个控件。 虽然现在系统已提供UIStackView这样的控件可实现横向滑动的效果，但是如果需要兼容9.0系统以下的版本IPHHorizontalTableView还是最佳的选择。  

IPHHorizontalTableView在13年的时候只实现了最基本的功能，抽取了UITableView的部分常用API来作为IPHHorizontalTableView的API进行使用，而当前修改后的IPHHorizontalTableView已把所有能兼容使用的API都抽取了出来。  


IPHHorizontalTableView因为被旋转，对于其`frame`,`x`和`y`,`width`和`height`都已经被互换，所以部分属性在使用上会略有不同，比如没有`rowHeight`属性而换成了`rowWidth`，没有`contentOffset`属性而是`contentOffsetX`等等，这些都是由于旋转后所做的一些兼容适配。但是开发者在看到这些属性后应该会很快明白其中的道理。所以具体IPHHorizontalTableView的API也没有必要很详细的在这里去讲解，只需引入`IPHHorizontalTableView+UIScrollView.h`头文件，按照UITableView和UIScrollView API的用法去使用即可。   



### <a name="IPHConditionSelectorView">IPHConditionSelectorView</a>   
条件选择器控件。在做酒店相关模块写的一个控件。比如搜索酒店的条件：价格范围，星级等。通过代理的方法去实现，用法也跟UITableView相近。  

***IPHConditionSelectorView：***

* **`- (NSInteger)numberOfSectionsInConditionSelectorView:(IPHConditionSelectorView *)selectorView;`**   

> 多少种类型的条件在视图中，比如价格范围和星级，则返回2。  


* **`- (nullable NSString *)conditionSelectorView:(IPHConditionSelectorView *)selectorView titleForHeaderInSection:(NSInteger)section;`**   

> 条件类型的标题，比如根据不同的`section`返回“价格范围”和“星级”字符串。  


* **`- (nullable NSArray<id <IPHConditionProtocol>> *)conditionSelectorView:(IPHConditionSelectorView *)selectorView conditionsInSection:(NSInteger)section;`**   

> 供选择的条件，根据不同的`section`返回该类型中提供选择的条件。   


* **`- (nullable id <IPHConditionProtocol>)conditionSelectorView:(IPHConditionSelectorView *)selectorView defaultConditionSelectInSection:(NSInteger)section;`**   

> 默认选中的条件，根据不同的`section`返回该类型中默认选中的条件。不实现该方法则默认选中第一个。  


* **`- (void)conditionSelectorView :(IPHConditionSelectorView *)selectorView didSelectConditions:(NSArray<NSArray<id <IPHConditionProtocol>> *> *)conditions;`**   

> 选择完条件后的回调。conditions中为选中的所有条件。`section`有多少个，则conditions数组里面的元素有多少个，每个元素中又是该`section`分类中选择的条件数组。   


* **`headerTitleColor`**   

> 条件类型的标题字体颜色  



* **`buttonNormalColor`**   

> 条件按钮未选中状态下文字的颜色  


* **`buttonSelectedColor`**   

> 条件按钮选中状态下文字的颜色，其中选中状态下按钮的边框颜色和确定按钮的背景色都保持和该颜色值一样。   


***IPHConditionProtocol：***  
提供给conditionSelectorView的数据源对象，必须遵循IPHConditionProtocol系统。`conditionId`提供ID的支持，`isUnlimited`为该条件是否为无限制条件的标志，比如星级条件可能从一星分到五星，那么我们可能还需要添加一个条件为“不限”，表示条件不限制，这个时候我们可以添加一个不限的条件对象，`title`值为“不限”，`conditionId`设置一个固定的id，把`isUnlimited`设置为`YES`,这样我们就能轻易在选择操作结束后的回调中区分哪个条件为不限条件。  


***IPHConfirmCell：***  
用于显示确定按钮的Cell。开发者可添加对应的IPHConfirmCell xib文件来自定义确定按钮样式，否则该按钮将通过IPHConfirmCell默认创建。


<br />

<a name="Others">Others</a>
-------------------------------------------------------------  
**其他写的一些未归属的类**  


### <a name="IPHLocationManager">IPHLocationManager</a>  

定位管理类。以单列形式存在，通过它可以定位获取到坐标，城市信息，详细地址等地理信息。


<br />

<a name="JSCoreBridge">JSCoreBridge</a>
=============================================================  

<br />

JSCoreBridge是基于iOS平台[Apache Cordova](http://cordova.apache.org/)修改的开源框架，Cordova的用处在于作为桥梁通过插件的方式实现了Web与Native之间的通信，而JSCoreBridge参考其进行删减修改（移除了开发者在平时用不上的类和方法），改写了其传统的通信机制，在保留了Cordova实用的功能前提下，精简优化了框架占用大小，并且省去了繁琐的工程设置选项，通过的新的实现方式大大提供了通信效率。JSCoreBridge开源框架力在为开发者提供更便捷的Hybird开发体验。 

<br />

**[点击查看JSCoreBridge详细说明](https://github.com/iPhuan/JSCoreBridge.git)**



<br />

:warning: <a name="RiskStatement">风险声明</a>
-------------------------------------------------------------
* 本框架虽然已进行过多次自测，但是并未进行大范围的试用，避免不了会有未知的bug产生，如果您使用本框架，由于未知bug所导致的风险需要您自行承担。 

> 欢迎各位使用者给本人反馈在使用中遇到的各种问题和bug。


<br />

<a name="OpenSourceDesc">开源说明</a>
-------------------------------------------------------------
iPhuanLib框架意在分享和交流，本着开源的思想，现已上传至[GitHub](https://github.com/iPhuan/iPhuanLib.git)，之后会一直跟进更新，如果您在使用本框架，欢迎及时反馈您在使用过程中遇到的各种问题和bug，也欢迎大家跟本人交流和分享更多互联网技术。iPhuan更多开源资源将会不定期的更新至 [iPhuanLib](https://github.com/iPhuan/iPhuanLib.git)  


<br />

<a name="ContactInfo">如何联系我</a>
-------------------------------------------------------------  
邮箱：iphuan@qq.com  
QQ：519310392  

> 添加QQ时请备注iPhuanLib


<br />
<br />
<br />

<a name="UpdateInfo">版本更新记录</a>
=============================================================  

### [V1.0.0](https://github.com/iPhuan/iPhuanLib/tree/1.0.0)
更新日期：2017年4月20日  
更新说明：  
> * 发布`iPhuanLib`第一个版本。  

-------------------------------------------------------------  

### [V1.0.1](https://github.com/iPhuan/iPhuanLib/tree/1.0.1)
更新日期：2017年6月15日  
更新说明：  
> * 解决`IPHBaseModel`通过`initWithDictionary:`初始化数据时，执行`objc_msgSend`崩溃的问题；    
> * 优化实现`NSCopying`协议，`NSCoding`协议，`toDictionary`方法的数据处理不受限于`attributeMapDictionary:`映射；
> * [新增`handleAttributeValue:forAttributeName:`数据处理方法，优化模型转化的特殊数据处理；](#handleAttributeValue)  
> * [新增`setup`初始化操作方法；](#setup) 
> * [新增`IPHBaseModel`基础模型协议实现方式的支持，提高对象的扩展灵活性；](#IPHBaseModelProtocal)    
> * 优化相关宏定义（废弃相关单列宏的使用；废弃`IPHFitSize`，新增`IPH6FitSize`和`IPH6RatioFitSize`；优化字符串是否可用的相关宏定义判断）。

------------------------------------------------------------- 

















