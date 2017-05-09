var HDC1008 = require('../hdc1008');
var temp = new HDC1008();

temp.readTemperature(function(value){
    console.log("temperature value is: ", value, "°C");
});




