Function.prototype.method = function (name, func) {
    if (!this.prototype[name]) {
        this.prototype[name] = func;
    }

    return this;
}

Number.method('integer', function() {
    return Math[this < 0 ? 'ceil' : 'floor'](this);
});

console.log((-10 / 3).integer());

String.method('trim', function() {
    reutn this.replace(/^\s+ | \s+$/g, ' ');
});

/**
 * memoization
 * for calculator (jie cheng)
 */
var memoizer = function (memo, formula) {
    var recur = function(n) {
        var result = memo[n];
        if (typeof result !== 'number') {
            result = formula(recur, n);
            memo[n] = result;
        }
        return result;
    };
    return recur;
};

/**
 * test for memoization
 */
var fibonacci = memoizer([0, 1], function(recur, n) {
    return recur(n - 1) + recur(n - 2);
});
