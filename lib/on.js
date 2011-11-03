

module.exports = function (on) {
    var i = 0,
        registered = [];

    var add = function (handler, invocant) {
        var ident = i++;

        registered[ident] = [handler, invocant || on];

        var canceller = function () { delete registered[ident] };

        canceller.toString = function () { return '[on.js canceller]' };

        return canceller;
    };

    add._fire = function () {
        for (var i = 0, l = registered.length; i < l; i++) {
            if (registered[i]) {
                registered[i][0].apply(registered[i][1], arguments);
            }
        }
    };

    add._removeAll = function () {
        registered = [];
    };

    add.toString = function () { return '[on.js emitter]' };

    return add;
};

