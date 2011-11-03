
var litmus = require('litmus'),
    on = require('..');

module.exports.test  = new litmus.Test('main on.js tests', function () {
    var test = this;

    test.plan(26);

    test.is(typeof on, 'object', 'main export is an object');
    test.is(typeof on.create, 'function', 'factory function for creating emitters');

    var defaultInvocant  = {},
        explicitInvocant = {};

    var onEvent = on.create(defaultInvocant);

    test.is(typeof onEvent, 'function', 'handler adder is a function');
    test.is('' + onEvent, '[on.js emitter]', 'emitter stringifies properly');

    var defaultInvocantMostRecentArguments,
        defaultInvocantCalled = 0,
        explicitInvocantMostRecentArguments,
        explicitInvocantCalled = 0;

    var defaultInvocantCanceller = onEvent(function () {
        if (defaultInvocantCalled++ === 0) {
            test.is(this, defaultInvocant, 'invocant is parameter to on.make() by default');
        }
        defaultInvocantMostRecentArguments = Array.prototype.slice.call(arguments, 0);
    });

    var explicitInvocantCanceller = onEvent(function () {
        if (explicitInvocantCalled++ === 0) {
            test.is(this, explicitInvocant, 'can pass explicit invocant to adder');
        }
        explicitInvocantMostRecentArguments = Array.prototype.slice.call(arguments, 0);
    }, explicitInvocant);

    test.is(typeof defaultInvocantCanceller, 'function', 'first adder return value is function');
    test.is('' + defaultInvocantCanceller, '[on.js canceller]', 'first adder stringifies properly');

    test.is(typeof explicitInvocantCanceller, 'function', 'second adder return value is function');
    test.is('' + explicitInvocantCanceller, '[on.js canceller]', 'second adder stringifies properly');

    test.is(typeof onEvent._fire, 'function', 'fire is a function');

    test.is(typeof onEvent._fire(1, 2, 3), 'undefined', 'result from fire is undefined');

    test.is(defaultInvocantCalled, 1, 'first handler called');
    test.is(defaultInvocantMostRecentArguments, [1, 2, 3], 'first handler called with correct arguments');

    test.is(explicitInvocantCalled, 1, 'second handler called')
    test.is(defaultInvocantMostRecentArguments, [1, 2, 3], 'second handler called with correct arguments');

    onEvent._fire(3, 2, 1);

    test.is(defaultInvocantCalled, 2, 'first handler called again');
    test.is(defaultInvocantMostRecentArguments, [3, 2, 1], 'first handler called again with correct arguments');

    test.is(explicitInvocantCalled, 2, 'second handler called again')
    test.is(explicitInvocantMostRecentArguments, [3, 2, 1], 'second handler called again with correct arguments');

    test.is(typeof defaultInvocantCanceller(), 'undefined', 'return value from canceller null');
    
    onEvent._fire(2, 1, 3);

    test.is(defaultInvocantCalled, 2, 'first handler not called again');

    test.is(explicitInvocantCalled, 3, 'second handler called a third time')
    test.is(explicitInvocantMostRecentArguments, [2, 1, 3], 'second handler called a third time with correct arguments');
    
    test.is(typeof defaultInvocantCanceller(), 'undefined', 'return value from canceller null when called a second time');

    onEvent._removeAll();

    onEvent._fire();

    test.is(explicitInvocantCalled, 3, 'second handler not called after _removeAll');
    
});

