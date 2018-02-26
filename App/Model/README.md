# Model 目录

存放数据模型和其他数据相关的类。

定义一个 model 不应该简单的只是声明几个属性，我们推荐在 model 上承担更多的业务逻辑。
比如请求发送、发送状态变化通知、状态判断、结构转换等任务。


JSON Model 放在 JSON 子文件夹下，类名用 Entity 结尾。Realm 的 model 放在 Realm 子文件夹下，类名用 Model 结尾。

请求发送、接收时有时需要建立只在该场景下的中转 model，此时类名用 RequestEntity 或 ResponseEntity 结尾，此类 model 只是用做封装，不应在其中包含业务逻辑。
