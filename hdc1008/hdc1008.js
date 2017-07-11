var i2c = require('i2c');
var _ = require('lodash');
var utils = require('./utils');

var HDC1008 = function (opts) {
    this.options = _.extend({}, {
        address: 0x43,
        device: '/dev/i2c-1',
        command: 0x00,
        length: 2
    }, opts);
    this.wire = new i2c(this.options.address, {device: this.options.device});
};

HDC1008.prototype.readTemperature = function (cb) {
    var self = this;
    if (!utils.exists(cb)) {
        console.error("missing callback");
        return;
    }


    this.wire.write([0x02,0x30], function (err) {

	console.info("writ wird aufgerufen",null);
	
        if (utils.exists(err)) {
            console.error("error write byte to HDC1008 - command: ","0x02,0x30");

        }
    });

    this.wire.writeByte(this.options.command, function (err) {
		
		console.info("writebyte wird aufgerufen",null);
		
        if (utils.exists(err)) {
            console.error("error write byte to HDC1008 - command: ", self.options.command);
        }
    });
    this.wire.readBytes(this.options.command, this.options.length, function (err, res) {
        var byte1 = res.readUInt8(0);
        var byte2 = res.readUInt8(1);

        var temp = (byte1 * 256) + byte2;
        var celsTemp =((temp / 65536.0) * 165.0) - 40;

        console.info("var celstemp: 2",celsTemp);
  	    celsTemp = Math.abs(celsTemp);


        cb.call(self, celsTemp);
    });
};

module.exports = HDC1008;

