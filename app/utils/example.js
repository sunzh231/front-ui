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