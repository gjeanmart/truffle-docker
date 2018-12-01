// api.js

// BASE SETUP
// =============================================================================

// Constant
const DEFAULT_PORT = 8888;
const DEFAULT_HOST = "0.0.0.0";


var cors 	   = require('cors');				// cors
var express    = require('express');        	// call express
var app        = express();                 	// define our app using express
var fs 		   = require('fs');
var {JSONPath} = require('jsonpath-plus');

// Server host and port
var port = process.env.API_PORT || DEFAULT_PORT;    // set our port
var host = process.env.API_HOST || DEFAULT_HOST;    // set our host


// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();

router.get('/', function(req, res) {
    res.json({ message: 'welcome!' });   
});

router.get('/:contractName', function(req, res) {
	var truffleArtefact = JSON.parse(fs.readFileSync('/project/build/contracts/'+req.params.contractName+'.json', 'utf8'));
	var contractAddress = truffleArtefact.networks[Object.keys(truffleArtefact.networks)[0]].address;
    res.json({ "name": req.params.contractName, "address": contractAddress });   
});

router.get('/:contractName/all', function(req, res) {
	var truffleArtefact = JSON.parse(fs.readFileSync('/project/build/contracts/'+req.params.contractName+'.json', 'utf8'));

	if(req.query.path) {
		var result = JSONPath({path: req.query.path, json: truffleArtefact})
		res.json(result);
	}

    res.json(truffleArtefact);   
});



// REGISTER OUR ROUTES -------------------------------
app.use(cors())
app.use('/api', router);


// START THE SERVER
// =============================================================================
app.listen(port, host);