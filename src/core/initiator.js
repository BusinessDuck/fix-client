import Message from './message';
import net from 'net';
import tls from 'tls';
import {msgTypes as MessageTypes} from './utils/msgTypes';
import {EventEmitter} from "events";

export default class Initiator extends EventEmitter {
	constructor(options) {
		super();
		this.options = options;
		this.sequenceNumber = 1;
	}

	connect() {
		return new Promise((resolve, reject) => {
			let socket;
			if (!this.options.SSL) {
				socket = net.connect(this.options.port, this.options.host);
			} else {
				socket = tls.connect(this.options.port, this.options.host);
			}

			this.socket = socket;
			socket.on('connect', () => {
				setInterval(() => this.sendHeartbeat, this.options.HeartBtInt * 1000);
				resolve(true);
			});
			socket.on('data', (data) => {
				let message = new Message(data.toString());
				message = message.toJSON();
				console.log(message);
				let messageType = MessageTypes[message.MsgType];
				this.takeActionOnMessage(messageType, message);
			});
			socket.on("InstrumentsDefinitions", (data) => {
				console.log("instruments: ", data );
			});
			socket.on('error', (err) => {
				console.log(err.toString());
				reject(err);
			});
		});
	}

	send(message) {
		this.socket.write(message);
	}

	takeActionOnMessage(messageType, message) {
		this.emit(messageType, message);
		switch (messageType) {
			case 'TestRequest':
				let testResponse = new Message({TestReqID: message.TestReqID}, 'TestRequest', this);
				this.send(testResponse.toFIX());
				break;

			case 'SequenceReset':
				resetSequence(message);
				break;

			default:

		}
	}

	sendHeartbeat() {
		let heartbeat = new Message({}, 'Heartbeat', this);
		this.send(heartbeat.toFIX());
	}

	resetSequence(message) {
		if (!message.GapFillFlag || message.GapFillFlag === 'N') {
			if (message.NewSeqNo >= this.sequenceNumber) {
				this.sequenceNumber = message.NewSeqNo;
			}
		} else {

		}
	}
}
