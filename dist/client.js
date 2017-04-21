"use strict";

var _nodeQuickfix = require("node-quickfix");

var _fixjs = require("fixjs");

var _events = require("events");

var _events2 = _interopRequireDefault(_events);

var _path = require("path");

var _path2 = _interopRequireDefault(_path);

var _moment = require("moment");

var _moment2 = _interopRequireDefault(_moment);

var _common = require("./common");

var _common2 = _interopRequireDefault(_common);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var options = {
	credentials: {
		username: "tgFZctx2FZ0000c",
		password: "tgFZctx2FZ0000c"
	},
	propertiesFile: _path2.default.join(__dirname, "/../configs/initiator.properties")
};
// extend prototype
function inherits(target, source) {
	for (var k in source.prototype) {
		target.prototype[k] = source.prototype[k];
	}
}

inherits(_nodeQuickfix.initiator, _events2.default.EventEmitter);

var fixClient = new _nodeQuickfix.initiator({
	onCreate: function onCreate(sessionID) {
		fixClient.emit('onCreate', _common2.default.stats(fixClient, sessionID));
	},
	onLogon: function onLogon(sessionID) {
		fixClient.emit('onLogon', _common2.default.stats(fixClient, sessionID));
	},
	onLogout: function onLogout(sessionID) {
		fixClient.emit('onLogout', _common2.default.stats(fixClient, sessionID));
	},
	onLogonAttempt: function onLogonAttempt(message, sessionID) {
		fixClient.emit('onLogonAttempt', _common2.default.stats(fixClient, sessionID, message));
	},
	toAdmin: function toAdmin(message, sessionID) {
		fixClient.emit('toAdmin', _common2.default.stats(fixClient, sessionID, message));
	},
	fromAdmin: function fromAdmin(message, sessionID) {
		fixClient.emit('fromAdmin', _common2.default.stats(fixClient, sessionID, message));
	},
	fromApp: function fromApp(message, sessionID) {
		console.log(sessionID, message);
		fixClient.emit('fromApp', _common2.default.stats(fixClient, sessionID, message));
	}
}, options);

fixClient.start(function () {
	console.log("FIX Initiator Started");
	var order = {
		header: {
			8: 'FIX.4.4',
			35: 'D',
			49: "NODEQUICKFIX",
			56: "ELECTRONIFIE"
		},
		tags: {
			11: "0E0Z86K00000",
			48: "06051GDX4",
			22: 1,
			38: 200,
			40: 2,
			54: 1,
			55: 'BAC',
			218: 100,
			60: (0, _moment2.default)(new Date()).format("yyyymmdd-HH:MM:ss.l"),
			423: 6
		}
	};

	fixClient.send(order, function (message) {
		console.log("Order sent!", message);
		_common2.default.printStats(fixClient);
		process.stdin.resume();
	});
});
//# sourceMappingURL=client.js.map
