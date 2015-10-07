var mongoose = require('mongoose');  
var Schema = mongoose.Schema;

var KeywordSchema = new Schema({  
    name: String,
    masks: Array
});

module.exports = mongoose.model('Keyword', KeywordSchema);  
