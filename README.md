# English
## Welcome to the home page of FIX protocol open-source client.
#### Our ideas:
1. The open source service for working with exchanges
2. High leveled API system wrapped our service as high-level client f.e. (NYSE-client with methods specified for this exchange)
3. Wa want invite the Javascript developers to trading in exchange platforms with good open-source software
4. One data source for all you trading bots

#Help us

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MN45NZ5YF3NZ4)

### Diagram of our system

![](./schema.png?raw=true)


#### Base example of exchange market data service
```javascript
import "NYSEMDClient" from "./core/clients/NYSE";

const exchangeMDClient = new NYSEMDClient({
    //FAST protocol will be implemented here
});

//Authorize will be here

exchangeMDClient.createService(); // start market data service on localhost:9111
```

#### Base example of exchange client service (still not implemented)
```javascript
import "NYSEClient" from "./core/clients/NYSE";

const exchangeClient = new NYSEClient({
    	host: 'localhost',
    	port: 9878,
    	TargetCompID: 'FIXIMULATOR',
    	SenderCompID: 'BANZAI',
    	BeginString: 'FIX.4.4',
    	HeartBtInt: 30,
    	SSL: false
    };
});
exchangeClient.logon();
exchangeClient.on("Logon", function(message){
    exchangeClient.startOrderService(); //create localhost:8888 interface for sending commadns
});

```
#### Base example of trading bot 
```javascript
import net from 'net';

var orderClient = new net.Socket();
orderClient.connect(8888, '127.0.0.1', function() { //connect with order sending service
	console.log('Connected to order service');
});


orderClient.on('data', function(data) {
	console.log('Received: ' + data);
	client.destroy(); // kill client after server's response
});

orderClient.on('close', function() {
	console.log('Connection closed');
});

var marketClient = new net.Socket();
marketClient.connect(9111, '127.0.0.1', function() { //connect with market data service
	console.log('Connected to market data service');
});

marketClient.write({requestType: "any", symbol: "EBAY"}); //request informations about EBAY symbol

marketClient.on("EBAY", function(data) {
    //data Math operations will be here (for current strategy)
    const openSiglal = data.price < data.avgPrice; //example of signal
    if(openSignal) { //logic of the signal
        orderClient.write({msgType: "OpenOrderSingle", data: {
           price: data.price,
           type: "BUY",
           symbol: data.symbol
        }});
    } 
});

```
