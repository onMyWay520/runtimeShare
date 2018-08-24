# runtimeShare
OC底层runtime知识点总结分享
1、objc_msgSend
这是个最基本的用于发送消息的函数。
其实编译器会根据情况在objc_msgSend， objc_msgSend_stret,，objc_msgSendSuper， 或 objc_msgSendSuper_stret 四个方法中选择一个来调用。如果消息是传递给超类，那么会调用名字带有 Super 的函数；如果消息返回值是数据结构而不是简单值时，那么会调用名字带有stret的函数。

2、SEL

objc_msgSend函数第二个参数类型为SEL，它是selector在Objc中的表示类型（Swift中是Selector类）。selector是方法选择器，可以理解为区分方法的 ID，而这个 ID 的数据结构是SEL:

typedef struct objc_selector *SEL;

其实它就是个映射到方法的C字符串，你可以用 Objc 编译器命令@selector()``或者 Runtime 系统的sel_registerName函数来获得一个SEL类型的方法选择器。
3、id
objc_msgSend第一个参数类型为id，大家对它都不陌生，它是一个指向类实例的指针：

typedef struct objc_object *id;

那objc_object又是啥呢：

struct objc_object { Class isa; };

objc_object结构体包含一个isa指针，根据isa指针就可以顺藤摸瓜找到对象所属的类。

4、runtime.h里Class的定义

struct objc_class {

Class isa  OBJC_ISA_AVAILABILITY;//每个Class都有一个isa指针

#if !__OBJC2__

Class super_class                                        OBJC2_UNAVAILABLE;//父类

const char *name                                         OBJC2_UNAVAILABLE;//类名

long version                                             OBJC2_UNAVAILABLE;//类版本

long info                                                OBJC2_UNAVAILABLE;//!*!供运行期使用的一些位标识。如：CLS_CLASS (0x1L)表示该类为普通class; CLS_META(0x2L)表示该类为metaclass等(runtime.h中有详细列出)

long instance_size                                       OBJC2_UNAVAILABLE;//实例大小

struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;//存储每个实例变量的内存地址

struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;//!*!根据info的信息确定是类还是实例，运行什么函数方法等

struct objc_cache *cache                                 OBJC2_UNAVAILABLE;//缓存

struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;//协议

#endif



} OBJC2_UNAVAILABLE;

可以看到运行时一个类还关联了它的超类指针，类名，成员变量，方法，缓存，还有附属的协议。

在objc_class结构体中：`ivars是objc_ivar_list指针；methodLists是指向objc_method_list指针的指针。也就是说可以动态修改*methodLists的值来添加成员方法，这也是Category`实现的原理。

