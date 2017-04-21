import Initiator from "./initiator";
import * as MessageBuilder from "./utils/messageBuilder";

const options = {
	host: '91.208.232.244',
	port: 6001,
	TargetCompID: 'FG',
	SenderCompID: 'tgFZctx2FZ0000c',
	// host: 'localhost',
	// port: 9878,
	// TargetCompID: 'FIXIMULATOR',
	// SenderCompID: 'BANZAI',
	BeginString: 'FIX.4.4',
	HeartBtInt: 30,
	SSL: false
};

let logonOptions = {
	EncryptMethod: 0,
	HeartBtInt: 30,
	ResetSeqNumFlag: 'Y'
};

let initiator = new Initiator(options);

let logonMessage = MessageBuilder.createFIXstring(logonOptions, "Logon", initiator);
console.log(logonMessage)
let testOrder = {
	ClOrdID: 'ODER0001',
	ExDestination: 'N',
	HandlInst: 2,
	Account: '00c',
	Symbol: 'SBRF-6.17',
	Side: 1,
	TransactTime: "20170421-00:27:25",
	ExpireDate: "20170421-00:57:25",
	OrderQty: 10,
	OrdType: 2,
	TimeInForce: 0,
	Price: '15565'
};
//8=FIX.4.2|9=130|35=D|34=659|49=BROKER04|56=REUTERS|52=20070123-19:09:43|38=1000|59=1|100=N|40=1|11=ORD10001|60=20070123-19:01:17|55=HPQ|54=1|21=2|10=004|
//8=FIX.4.49=13635=D34=249=BANZAI56=FIXIMULATOR52=20170420-21:02:05.73238=1059=0100=N40=111=ODER000160=20170420-20:15:25.50755=HPQ54=121=210=133
let testOrderMessage = MessageBuilder.createFIXstring(testOrder, "NewOrderSingle", initiator);
console.log(testOrderMessage);

//let logoutMessage = MessageBuilder.createFIXstring({}, "Logout", initiator);
// let marketData = MessageBuilder.createFIXstring(
// 	{
// 		MDReqID: 1,
// 		SubscriptionRequestType: 0,
// 		MarketDepth: 1,
// 		NoMDEntryTypes: 1,
// 		MDEntryType: 1,
// 		NoRelatedSym: 1,
// 		Symbol: 'GAZP',
// 	}, "MarketDataRequest", initiator);
// console.log(logonMessage);
// console.log(marketData);
initiator.connect()
	.then(function (result) {
		initiator.send(logonMessage);
		initiator.on('Logon', function (message) {
			initiator.send(testOrderMessage);
		});

		// initiator.on('MarketDataRequest', function (message) {
		// 	console.log('ee', message);
		// });
	})
	.catch(function (err) {
		console.log(err.toString());
	});

initiator.on("NewOrderSingle", function () {
	console.log("it works!")
});
