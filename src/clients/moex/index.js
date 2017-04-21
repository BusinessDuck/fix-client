import Initiator from "../../core/initiator";
import {getFormattedTime} from "../../core/utils/messageBuilder";

export default class MOEXClient extends Initiator {

	/**
	 * @name timeInForce
	 * @enum
	 * @value 0 Order will be active all day (or session)
	 * @value {1} Order will be active until cancellation
	 * @value {2} At the Opening (OPG)
	 * @value {3} Immediate or Cancel (IOC)
	 * @value {4} Fill or Kill (FOK)
	 * @value {5} Good Till Crossing (GTX)
	 * @value {6} Good Till Date
	 * @value {7} At the Close
	 */

	/**
	 * @name orderType
	 * @enum
	 * @value {1} Buy
	 * @value {2} Sell
	 * @value {3} Buy minus
	 * @value {4} Sell plus
	 * @value {5} Sell short
	 * @value {6} Sell short exempt
	 * @value {7} Undisclosed (valid for IOI <6> and List Order messages only)
	 * @value {8} Cross (orders where counterparty is an exchange, valid for all messages except IOIs)
	 * @value {9} Cross short
	 * @value {A} Cross short exempt
	 * @value {B} "As Defined" (for use with multileg instruments)
	 * @value {C} "Opposite" (for use with multileg instruments)
	 * @value {D} Subscribe (e.g. CIV)
	 * @value {E} Redeem (e.g. CIV)
	 * @value {F} Lend (FINANCING - identifies direction of collateral)
	 * @value {G} Borrow (FINANCING - identifies direction of collateral)
	 */

	/**
	 *
	 * @param {string} id
	 * @param {string} symbol
	 * @param {orderType} orderType
	 * @param {timeInForce} TimeInForce
	 * @param {number} price
	 * @param {string} expireDate
	 */
	createOrderSingle(id, symbol, orderType, TimeInForce, price, expireDate) {
		const orderParams = {
			TransactTime: getFormattedTime(),
			ClOrdID: id,
			Account: '00c',
			TimeInForce: TimeInForce,
			HandlInst: 2,
			Symbol: symbol,
			Side: orderType,
			ExpireDate: expireDate,
			OrderQty: 10,
			OrdType: 2,
			Price: price
		};
	}

}


var client = new MOEXClient();
client.createOrderSingle(1, 2, 3, 2, 3, 4);

