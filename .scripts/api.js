// api.js

const cors 	   = require('cors');				// cors
const express    = require('express');        	// call express
const app        = express();                 	// define our app using express
const fs 		   = require('fs');
const {JSONPath} = require('jsonpath-plus');


// ENVIRONMENT VARIABLES
// =============================================================================
const port = process.env.API_PORT || 8888;
const host = process.env.API_HOST || "0.0.0.0";
const folder = process.env.GIT_FOLDER || "/"



// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();

router.get('/', function(req, res) {
    res.json({ message: 'welcome!' });
});

router.get('/:contractName', function(req, res) {
	var truffleArtefact = JSON.parse(fs.readFileSync('/project' + folder + '/build/contracts/'+req.params.contractName+'.json', 'utf8'));
	var contractAddress = truffleArtefact.networks[Object.keys(truffleArtefact.networks)[0]].address;
    res.json({ "name": req.params.contractName, "address": contractAddress });
});

router.get('/:contractName/all', function(req, res) {
	var truffleArtefact = JSON.parse(fs.readFileSync('/project' + folder + '/build/contracts/'+req.params.contractName+'.json', 'utf8'));

	if(req.query.path) {
		res.json(JSONPath({'path': req.query.path, 'json': truffleArtefact}));
	} else {
		res.json(truffleArtefact)
	}
});



// REGISTER OUR ROUTES -------------------------------
app.use(cors())
app.use('/api', router);


// START THE SERVER
// =============================================================================
app.listen(port, host);
