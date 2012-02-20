/**
 * 用于演示在objectjs中如何编写jsdoc
 * @author zhifu.wang(zhifu.wang@renren-inc.com)
 */

/**
 * 演示为objectjs的模块添加jsdoc注释
 * @author zhifu.wang(zhifu.wang@renren-inc.com)
 * @version 1.0
 */
object.add('JSDOCDemo', function(exports) {
	/**
	 * 模块常量示例
	 * @const
	 * @type int
	 */
	exports.CONST_OF_MODULE = 1;
	
	/**
	 * 模块变量示例
	 * @type int
	 */
	exports.variableOfModule = 1;
	
	/**
	 * 模块方法示例
	 * @param {String|Object} paramA 第一个参数
	 * @param {String} paramB 第二个参数
	 * @return {String} 返回值
	 * @exception MyException 抛出此类异常的情况描述
	 */
	exports.methodOfModule = function(paramA, paramB) {};

	/**
	 * 第一个Class，member将会生成占位注释
	 */
	this.ClassA = new Class(function() {this.member = 1;});
	/**
	 * 第二个Class，member将会生成占位注释
	 */
	this.ClassB = new Class({member:1});

	/**
	 * 经典的写法，则必须添加class的声明，才会认为是该模块下的一个class
	 * @class
	 */
	this.ClassC = function() {};
	/**
	 * 经典写法中，利用prototype定义方法
	 */
	this.ClassC.prototype.method2 = function() {}

	/**
	 * 这是一个ObjectJS标准方式定义的类，不用jsdoc class声明，会自动声明为一个class<br>
	 * 这个类继承了B，不需要添加augment，在插件中会自动添加
	 */
	this.ObjectjsStyleClassDefinition = new Class(exports.ClassA, function() {
		this.__mixins__ = [exports.ClassC];
		Class.mixin(this, exports.ClassB);
		/**
		 * 类似于模块变量，这里可以通过@const和@type描述此常量
		 * @const
		 * @type int
		 */
		this.CONST_OF_CLASS = 1;
		
		/** 
		 * 类似于模块变量，这里可以通过@type描述此常量 
		 * @type int
		 */
		this.variableOfClass = 1;
		
		/**
		 * @description 一个比较详细的方法注释示例<br>
		 * 对这个方法的详细描述，一般很长~~~~~~~~~~~~~~~~~~~~
		 * @summary 一个简短版的总结，一般很短
		 * @param {这里写参数类型} a 这里写说明
		 * @param {这里写参数类型} [b=1] 这里写说明 []意味着是一个可选参数，=1说明默认值是1
		 * @see module:JSDOCDemo#ClassA 
		 * @see <a href='http://www.renren.com'>参考文献1</a>
		 * @fires 事件名1 什么时候触发事件1
		 * @fires 事件名2 什么时候触发事件2
		 * @event 说明这是一个事件
		 * @exception 异常名称 什么时候抛出此异常
		 * @since 从哪个版本开始
		 * @todo 还有什么事情要做
		 * @version 版本号
		 * @deprecated 这个方法不建议使用了，改用别的方法吧
		 * @example
		 * 这是一个例子
		 * @example
		 * 这是另外一个例子
		 */
		this.methodWithCompleteJsdoc = function(self, a, b) {
			/** 这个变量是实例变量，如果添加了注释会自动识别，如果不添加注释，就没有jsdoc */
			self.instanceAttributeDefinedInMethod = 1;
			// 这个变量没有jsdoc，不会生成文档
			self.instanceAttributeDefinedInMethod2 = 2;
		};

		// 没有jsdoc的方法，将会自动生成一个占位的jsdoc
		this.methodWithoutJsdoc = function(self) {}

		/**
		 * 类方法注释示例
		 * @param {String} a 参数A
		 * @return {String} 返回值
		 */
		this.classmethodDemo = classmethod(function(cls, a) {
			/** 在classmethod中定义的类变量 */
			cls.classAttributeDefinedInFunction = a;
			// 这个变量没有jsdoc，不会生成文档
			cls.classAttributeDefinedInFunction2 = a;
		});

		/**
		 * 静态方法注释示例
		 * @param {String} a 参数A
		 * @return {String} 返回值
		 */
		this.staticmethodDemo = staticmethod(function(a) {});
	});
});
