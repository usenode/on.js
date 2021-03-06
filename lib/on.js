
module.exports = function (on) {

    var i = 0, registered = [], add = function (handler, invocant) {
        var ident = i++;
        registered[ident] = [handler, invocant || on];
        return function () { delete registered[ident] };
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

    return add;

};

