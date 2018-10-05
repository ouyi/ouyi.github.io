## 基本语法

JavaScript并不强制要求在每个语句的结尾加;

一个字符串，可以视为一个完整的语句

不区分整数和浮点数，统一用Number表示

字符串是以单引号'或双引号"括起来的任意文本

### 比较

第一种是==比较，它会自动转换数据类型再比较，很多时候，会得到非常诡异的结果；
第二种是===比较，它不会自动转换数据类型，如果数据类型不一致，返回false，如果一致，再比较。

由于JavaScript这个设计缺陷，不要使用==比较，始终坚持使用===比较

NaN === NaN; // false

isNaN(NaN); // true

JavaScript的设计者希望用null表示一个空的值，而undefined表示值未定义。事实证明，区分两者的意义不大。大多数情况下，我们都应该用null。undefined仅仅在判断函数参数是否传递的情况下有用。

数组可以包括任意数据类型。例如：

[1, 2, 3.14, 'Hello', null, true];

对象是一组由键-值组成的无序集合

对象的键都是字符串类型，值可以是任意数据类型

### 变量

变量本身类型不固定的语言称之为动态语言(JavaScript)，与之对应的是静态语言(Java)
var a = 123; // a的值是整数123
a = 'ABC'; // a变为字符串

i = 10; // i现在是全局变量

'use strict';
i = 10; //

ReferenceError: i is not defined

不用var申明的变量会被视为全局变量，为了避免这一缺陷，所有的JavaScript代码都应该使用strict模式

### Strings and arrays

转义字符\

'I\'m \"OK\"!';
\n表示换行，\t表示制表符，字符\本身也要转义，所以\\表示的字符就是\

ASCII字符可以以\x##形式的十六进制表示
'\x41'; // 完全等同于 'A'

\u####表示一个Unicode字符：
'\u4e2d\u6587'; // 完全等同于 '中文'

最新的ES6标准新增了一种多行字符串的表示方法，用反引号 ` ... ` 表示：
`这是一个
多行
字符串`;

ES6新增了一种模板字符串
var name = '小明';
var age = 20;
var message = `你好, ${name}, 你今年${age}岁了!`;
alert(message);

获取字符串某个指定位置的字符，使用类似Array的下标操作

var s = 'Hello, world!';
s.length; // 13
s[0]; // 'H'
s[13]; // undefined 超出范围的索引不会报错，但一律返回undefined

需要特别注意的是，字符串是不可变的，如果对字符串的某个索引赋值，不会有任何错误，但是，也没有任何效果：

var s = 'Test';
s[0] = 'X';
alert(s); // s仍然为'Test'

请注意，直接给Array的length赋一个新的值会导致Array大小的变化
var arr = [1, 2, 3];
arr.length; // 3
arr.length = 6;
arr; // arr变为[1, 2, 3, undefined, undefined, undefined]
arr.length = 2;
arr; // arr变为[1, 2]

请注意，如果通过索引赋值时，索引超过了范围，同样会引起Array大小的变化：

var arr = [1, 2, 3];
arr[5] = 'x';
arr; // arr变为[1, 2, 3, undefined, undefined, 'x']

对Array的索引进行赋值会直接修改这个Array, this is different from strings

push and pop for the tail, unshift and shift for the head

splice: modifies
concat: creates

### objects

xiaohong['name']来访问xiaohong的name属性，不过xiaohong.name的写法更简洁, 属性名如果是无效的变量名，就需要用''括起来，访问这个属性也无法使用.操作符，必须用['xxx']来访问： xiaohong['first-name']  尽量使用标准的变量名

if x is a variable, you can only do xiaohong[x]

可以自由地给一个对象添加或删除属性

delete xiaoming.age; // 删除age属性

'toString' in xiaoming; // true
xiaoming.hasOwnProperty('toString'); // false

### true or false

JavaScript把null、undefined、0、NaN和空字符串''视为false，其他值一概视为true

### iterable

var o = {
    name: 'Jack',
    age: 20,
    city: 'Beijing'
};
for (var key in o) {
    console.log(key); // 'name', 'age', 'city'
}

ES6标准引入了新的iterable类型，Array、Map和Set都属于iterable类型。

具有iterable类型的集合可以通过新的for ... of循环来遍历。

for ... of循环和for ... in循环有何区别？

forEach()方法 (ES5.1) 函数调用不要求参数必须一致

### Function

arguments，它只在函数内部起作用，并且永远指向当前函数的调用者传入的所有参数。arguments类似Array但它不是一个Array

两种定义完全等价

function abs(x) {
}

var abs = function (x) {
};

ES6标准引入了rest参数 rest参数只能写在最后，前面用...标识

函数可以嵌套，此时，内部函数可以访问外部函数定义的变量，反过来则不行

内部函数定义了与外部函数重名的变量，则内部函数的变量将“屏蔽”外部函数的变量

函数定义有个特点，它会先扫描整个函数体的语句，把所有申明的变量“提升”到函数顶部
JavaScript引擎自动提升了变量y的声明，但不会提升变量y的赋值

怪异的“特性” 请严格遵守“在函数内部首先申明所有变量”这一规则。

不在任何函数内定义的变量就具有全局作用域。实际上，JavaScript默认有一个全局对象window，全局作用域的变量实际上被绑定到window的一个属性

以变量方式var foo = function () {}定义的函数实际上也是一个全局变量，因此，顶层函数的定义也被视为一个全局变量，并绑定到window对象

名字空间

全局变量会绑定到window上，不同的JavaScript文件如果使用了相同的全局变量，或者定义了相同名字的顶层函数，都会造成命名冲突，并且很难被发现。

减少冲突的一个方法是把自己的所有变量和函数全部绑定到一个全局变量中。

// 唯一的全局变量MYAPP:
var MYAPP = {};

// 其他变量:
MYAPP.name = 'myapp';
MYAPP.version = 1.0;

// 其他函数:
MYAPP.foo = function () {
    return 'foo';
};
把自己的代码全部放入唯一的名字空间MYAPP中，会大大减少全局变量冲突的可能。

许多著名的JavaScript库都是这么干的：jQuery，YUI，underscore等等。

### 局部作用域

由于JavaScript的变量作用域实际上是函数内部，我们在for循环等语句块中是无法定义具有局部作用域的变量的：

'use strict';

function foo() {
    for (var i=0; i<100; i++) {
        //
    }
    i += 100; // 仍然可以引用变量i
}

为了解决块级作用域，ES6引入了新的关键字let，用let替代var可以申明一个块级作用域的变量：

'use strict';

function foo() {
    var sum = 0;
    for (let i=0; i<100; i++) {
        sum += i;
    }
    // SyntaxError:
    i += 1;
}

ES6标准引入了新的关键字const来定义常量，const与let都具有块级作用域

### 解构赋值

ES6中，可以使用解构赋值，直接对多个变量同时赋值：

'use strict';

// 如果浏览器支持解构赋值就不会报错:
var [x, y, z] = ['hello', 'JavaScript', 'ES6'];

// 把passport属性赋值给变量id:
let {name, passport:id} = person;

// 如果person对象没有single属性，默认赋值为true:
var {name, single=true} = person;

快速获取当前页面的域名和路径：

var {hostname:domain, pathname:path} = location;

如果一个函数接收一个对象作为参数，那么，可以使用解构直接把对象的属性绑定到变量中。例如，下面的函数可以快速创建一个Date对象：

function buildDate({year, month, day, hour=0, minute=0, second=0}) {
    return new Date(year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second); //对象的属性绑定到变量
}

buildDate({ year: 2017, month: 1, day: 1 });

### this

要保证this指向正确，必须用obj.xxx()的形式调用！

'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // 25

在一个独立的函数调用中，根据是否是strict模式，this指向undefined或window

用apply修复getAge()调用：

function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25
getAge.apply(xiaoming, []); // 25, this指向xiaoming, 参数为空

另一个与apply()类似的方法是call()，唯一区别是：

apply()把参数打包成Array再传入；

call()把参数按顺序传入。

比如调用Math.max(3, 5, 4)，分别用apply()和call()实现如下：

Math.max.apply(null, [3, 5, 4]); // 5
Math.max.call(null, 3, 5, 4); // 5
对普通函数调用，我们通常把this绑定为null。


### higher order functions

一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。

'use strict';

function string2int(s) {
  return s.split('').map(function(x){ return +x; }).reduce(function(x, y) {
    return x * 10 + y;
  });
}

// 测试:
if (string2int('0') === 0 && string2int('12345') === 12345 && string2int('12300') === 12300) {
    if (string2int.toString().indexOf('parseInt') !== -1) {
        console.log('请勿使用parseInt()!');
    } else if (string2int.toString().indexOf('Number') !== -1) {
        console.log('请勿使用Number()!');
    } else {
        console.log('测试通过!');
    }
}
else {
    console.log('测试失败!');
}


['1', '2', '3'].map(parseInt);
// While one could expect [1, 2, 3]
// The actual result is [1, NaN, NaN]

parseInt(expression, radix)
Array.prototype.map passes 3 arguments:
// the element, the index, the array

fix:
['1', '2', '3'].map(x => parseInt(x));

'use strict';

function get_primes(arr) {
    return arr.filter(function(n){
        for (let i = 2, r = Math.sqrt(n); i <= r; i++) {
            if (n % i === 0) {
                return false;
            }
        }
        return n !== 1;
    });
}

// 测试:
var
    x,
    r,
    arr = [];
for (x = 1; x < 100; x++) {
    arr.push(x);
}
r = get_primes(arr);
if (r.toString() === [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97].toString()) {
    console.log('测试通过!');
} else {
    console.log('测试失败: ' + r.toString());
}


// 无法理解的结果:
[10, 20, 1, 2].sort(); // [1, 10, 2, 20]

这是因为Array的sort()方法默认把所有元素先转换为String再排序，结果'10'排在了'2'的前面，因为字符'1'比字符'2'的ASCII码小。

sort()方法会直接对Array进行修改，它返回的结果仍是当前Array

### closure

返回闭包时牢记的一点就是：返回函数不要引用任何循环变量，或者后续会发生变化的变量。

如果一定要引用循环变量怎么办？方法是再创建一个函数，用该函数的参数绑定循环变量当前的值，无论该循环变量后续如何更改，已绑定到函数参数的值不变

“创建一个匿名函数并立刻执行”的语法：

(function (x) {
    return x * x;
})(3); // 9

// seems to be the same?
(function (x) {
    return x * x;
}(3)); // 9

闭包就是携带状态的函数，并且它的状态可以完全对外隐藏起来

ES6标准新增了一种新的函数：Arrow Function（箭头函数）。

如果要返回一个对象，就要注意，如果是单表达式，这么写的话会报错：

// SyntaxError:
x => { foo: x }
因为和函数体的{ ... }有语法冲突，所以要改为：

// ok:
x => ({ foo: x })

现在，箭头函数完全修复了this的指向，this总是指向词法作用域，也就是外层调用者obj：

var obj = {
    birth: 1990,
    getAge: function () {
        var b = this.birth; // 1990
        var fn = () => new Date().getFullYear() - this.birth; // this指向obj对象
        return fn();
    }
};
obj.getAge(); // 25
如果使用箭头函数，以前的那种hack写法：

var that = this;
就不再需要了。

由于this在箭头函数中已经按照词法作用域绑定了，所以，用call()或者apply()调用箭头函数时，无法对this进行绑定，即传入的第一个参数被忽略：

var obj = {
    birth: 1990,
    getAge: function (year) {
        var b = this.birth; // 1990
        var fn = (y) => y - this.birth; // this.birth仍是1990
        return fn.call({birth:2000}, year);
    }
};
obj.getAge(2015); // 25

generator可以在执行过程中多次返回，所以它看上去就像一个可以记住执行状态的函数，利用这一点，写一个generator就可以实现需要用面向对象才能实现的功能

'use strict';
function* next_id() {
    let id = 1;
    while(true){
        yield id++;
    }
}

// 测试:
var
    x,
    pass = true,
    g = next_id();
for (x = 1; x < 100; x ++) {
    if (g.next().value !== x) {
        pass = false;
        console.log('测试失败!');
        break;
    }
}
if (pass) {
    console.log('测试通过!');
}


用typeof将无法区分出null、Array和通常意义上的object——{}。
判断Array要使用Array.isArray(arr)；
判断null请使用myVar === null；

字符串也区分string类型和它的包装类型。包装对象用new创建
var s = new String('str'); // 'str',生成了新的包装类型

typeof new String('str'); // 'object'
new String('str') === 'str'; // false

不要使用包装对象！尤其是针对string类型！！！

// without *new*
var s = String(123.45); // '123.45'
typeof s; // 'string'

任何对象都有toString()方法吗？null和undefined就没有！确实如此，这两个特殊值要除外，虽然null还伪装成了object类型。

123.toString(); // SyntaxError
遇到这种情况，要特殊处理一下：

123..toString(); // '123', 注意是两个点！
(123).toString(); // '123'

JavaScript的Date对象月份值从0开始，牢记0=1月，1=2月，2=3月，……，11=12月。

regex:
'a,b;; c  d'.split(/[\s\,\;]+/); // ['a', 'b', 'c', 'd']

正则表达式中定义了组()，就可以在RegExp对象上用exec()方法提取出子串
var re = /^(\d{3})-(\d{3,8})$/;
re.exec('010-12345'); // ['010-12345', '010', '12345']
re.exec('010 12345'); // null

exec()方法在匹配成功后，会返回一个Array，第一个元素是正则表达式匹配到的整个字符串，后面的字符串表示匹配成功的子串。

加个?就可以让\d+采用非贪婪匹配：

var re = /^(\d+?)(0*)$/;
re.exec('102300'); // ['102300', '1023', '00']


请尝试写一个验证Email地址的正则表达式。版本一应该可以验证出类似的Email：

'use strict';

var re = /^\w+(\.\w+)?@\w+\.\w+$/;
// 测试:
var
    i,
    success = true,
    should_pass = ['someone@gmail.com', 'bill.gates@microsoft.com', 'tom@voyager.org', 'bob2015@163.com'],
    should_fail = ['test#gmail.com', 'bill@microsoft', 'bill%gates@ms.com', '@voyager.org'];
for (i = 0; i < should_pass.length; i++) {
    if (!re.test(should_pass[i])) {
        console.log('测试失败: ' + should_pass[i]);
        success = false;
        break;
    }
}
for (i = 0; i < should_fail.length; i++) {
    if (re.test(should_fail[i])) {
        console.log('测试失败: ' + should_fail[i]);
        success = false;
        break;
    }
}
if (success) {
    console.log('测试通过!');
}

JSON.stringify

JSON.stringify(xiaoming); // 如果定义了一个toJSON()的方法，则直接返回JSON应该序列化的数据
JSON.stringify(xiaoming, null, '  ');
JSON.stringify(xiaoming, ['name', 'skills'], '  ');
JSON.stringify(xiaoming, myConvertFunction, '  ');

JSON.parse


https://medium.freecodecamp.org/javascript-modules-part-2-module-bundling-5020383cf306

# JS modules

## Module pattern

- Anonymous closure: IIFE
- Global import (used by, e.g., jquery): pass gloabl variables as parameters, which are used for exporting stuff
- Object interface: return an object from the IFFE
- Revealing module: similar to the above, but more explicit

Problems:
- dependency
- version

## CommonJS, AMD, and UMD

- CommonJS (module.exports and require, server-first approach, used by, e.g., nodejs) 强烈建议使用module.exports = xxx的方式来输出模块变量，这样，你只需要记忆一种方法
a combination of global import and revealing module
- AMD: Asynchronous Module Definition (define, browser-first approach)
- UMD: Universal Module Definition

## Native approach (ES6)

export and import
import * as counter from '../../counter';

# Bundling modules

## CommonJS
browserify main.js -o bundle.js

## AMD
AMD loader: RequireJS or Curl
RequireJS optimizer, r.js, for example

## Webpack

agnostic to the module system, allowing developers to use CommonJS, AMD, or ES6

## ES6 modules
static analysis: import is resolved at compile time, which allows us to remove exports that are not used
dead code elimination, called “tree shaking”

no native browser support yet, two options:

1. ES6 => transpiler (e.g. Babel or Traceur) => CommonJS, AMD, or UMD format
2. ES6 => rollup => ES6, CommonJS, AMD, UMD, or IIFE (IIFE and UMD works in browser, ES6, CommonJS, or AMD require converter)

ES6 module loader API
System.import(‘myModule’).then(function(myModule) {
  new myModule.hello();
});

<script type="module">
  // loads the 'myModule' export from 'mymodule.js'
  import { hello } from 'mymodule';
  new Hello(); // 'Hello, I am a module!'
</script>

SystemJS https://github.com/systemjs/systemjs, which built on top of the ES6 Module Loader polyfill https://github.com/ModuleLoader/es6-module-loader

- SystemJS dynamically loads any module format (ES6 modules, AMD, CommonJS and/or global scripts) in the browser and in Node
- It keeps track of all loaded modules in a “module registry” to avoid re-loading modules that were previously loaded.
- It also automatically transpiles ES6 modules (if you simply set an option) and
- Has the ability to load any module type from any other type

HTTP/2 and module bundlers
ES6 modules and non-native module formats

document.cookie; // 'v=123; remember=true; prefer=zh'
由于JavaScript(可以来自第三方)能读取到页面的Cookie，而用户的登录信息通常也存在Cookie中，这就造成了巨大的安全隐患
设定了httpOnly的Cookie将不能被JavaScript读取 这个行为由浏览器实现，主流浏览器均支持httpOnly选项

https://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/0014344997647015f03abc1bb5f46129a7526292a12ab26000

'use strict';
// sort list:
var list = document.getElementById('test-list');

Array.prototype.slice.call(list.children)
    .sort((a, b) => a.innerText !== b.innerText ? (a.innerText < b.innerText ? -1 : 1) : 0)
    .forEach(function (x) { list.appendChild(x); });

// 测试:
;(function () {
    var
        arr, i,
        t = document.getElementById('test-list');
    if (t && t.children && t.children.length === 5) {
        arr = [];
        for (i=0; i<t.children.length; i++) {
            arr.push(t.children[i].innerText);
        }
        if (arr.toString() === ['Haskell', 'JavaScript', 'Python', 'Ruby', 'Scheme'].toString()) {
            console.log('测试通过!');
        }
        else {
            console.log('测试失败: ' + arr.toString());
        }
    }
    else {
        console.log('测试失败!');
    }
})();

https://en.wikipedia.org/wiki/Immediately-invoked_function_expression

'use strict';

var list = document.getElementById('test-list');
var nonWebNodes = Array.prototype.slice.call(list.children).filter(x => ['Swift', 'ANSI C', 'DirectX'].includes(x.innerText));
for (let n of nonWebNodes) {
    list.removeChild(n);
}
// 测试:
;(function () {
    var
        arr, i,
        t = document.getElementById('test-list');
    if (t && t.children && t.children.length === 3) {
        arr = [];
        for (i = 0; i < t.children.length; i ++) {
            arr.push(t.children[i].innerText);
        }
        if (arr.toString() === ['JavaScript', 'HTML', 'CSS'].toString()) {
            console.log('测试通过!');
        }
        else {
            console.log('测试失败: ' + arr.toString());
        }
    }
    else {
        console.log('测试失败!');
    }
})();


var a = {};
$('#test-form :text, #test-form :password, #test-form input[name=gender]:checked, #test-form select').map((i, e) => a[e.name] = e.value );
json = JSON.stringify(a);

如果你遇到$(function () {...})的形式，牢记这是document对象的ready事件处理函数。

$(function () {
    console.log('init A...');
});
$(function () {
    console.log('init B...');
});

可以使用off('click')一次性移除已绑定的click事件的所有处理函数。

同理，无参数调用off()一次性移除已绑定的所有类型的事件处理函数。

Added to ES6 is Array.from() that will convert an array-like structure to an actual array. That allows one to enumerate a list directly like this:

"use strict";

Array.from(document.getElementsByClassName("events")).forEach(function(item) {
   console.log(item.id);
});

https://stackoverflow.com/questions/749084/jquery-map-vs-each

http://api.jquery.com/each/
http://api.jquery.com/map/
http://api.jquery.com/jQuery.each/
http://api.jquery.com/jQuery.map/


https://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/00143564690172894383ccd7ab64669b4971f4b03fa342d000#0

selectAll.off();
selectAll.change(function(){
    if (selectAll.is(':checked')) {
        langs.prop('checked', true);
        selectAllLabel.hide();
        deselectAllLabel.show();
    } else {
        langs.prop('checked', false);
        selectAllLabel.show();
        deselectAllLabel.hide();
    }
});

invertSelect.off();
invertSelect.click(function(){
    langs.each((i, e) => $(e).prop('checked', !$(e).is(':checked')));
    langs.change();
});

langs.off();
langs.change(function(){
    if (langs.filter(':checked').length === langs.length) {
        selectAll.prop('checked', true);
        selectAllLabel.hide();
        deselectAllLabel.show();
    } else {
        selectAll.prop('checked', false);
        selectAllLabel.show();
        deselectAllLabel.hide();
    }
});

show() hide() toggle(true/false)

https://github.com/JChehe/blog/blob/master/posts/关于JavaScript单线程的一些事.md

https://medium.com/@Jeffijoe/dependency-injection-in-node-js-2016-edition-f2a88efdd427

Instead of exporting an object, we export a function to make the object. The function states what dependencies it needs in order to do it’s thing.

https://medium.com/@Jeffijoe/dependency-injection-in-node-js-2016-edition-part-2-aedc5fd6eed0

There needs to be a single source of truth that knows about all the modules being used: the Composition Root.
