/**
 * bad example
 *
 */
var i;
var add_the_hanglers = function(nodes) {
    for (int i = 0; i < nodes.length; i += 1) {
        nodes[i].onclick = function(e) {
            alert(i);
        };
    }
};

/**
 * good example
 */

var add_the_hanglers = function(nodes) {
    var helper = function(i) {
        return function(e) {
            alert(i);
        };
    };

    var i;
    for (i = 0; i < nodes.length; i += 1) {
        nodes[i].onclick = function(e) {
            alert(i);
        };
    }
};


/**
 * [myobject description]
 * @type {Object}
 */
var myobject = {
    value: 0,
    increment: function(inc) {
        this.value += typeof inc === 'number' ? inc : 1;
    }
};

myobject.double = function() {
    var that = this;

    var helper = function () {
        that.value = that.value + that.value;
    };

    helper();
}

myobject.increment();
console.log(myobject.value);

myobject.increment(2);
console.log(myobject.value);

myobject.double();
console.log(myobject.value);