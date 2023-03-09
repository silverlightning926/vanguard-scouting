const { postgres, TBA } = require('./config.json');

const express = require('express')
const app = express()
const port = 3000

const { Pool } = require('pg')

const pool = new Pool(
    postgres
);

const axios = require('axios')

function getEventData(eventKey) {
    return requestData('event/' + eventKey + '/simple');
}

function getEventTeams(eventKey) {
    return requestData('event/' + eventKey + '/teams/simple');
}

function getEventMatches(eventKey) {
    return requestData('event/' + eventKey + '/matches/simple');
}

async function requestData(endpoint) {
    let config = {
        headers: { 'X-TBA-Auth-Key': TBA['authKey'] },
        baseURL: 'https://www.thebluealliance.com/api/v3'
    }

    return await axios.get(endpoint, config);
}

app.get('/status', (req, res) => {
    res.status(200).json({ status: 'OK' });
})

app.get('/loadEvent/:eventKey', (req, res) => {

    getEventTeams(req.params.eventKey).then((response) => {
        let teams = response['data'];
        let teamQueryString = 'INSERT INTO robot (tbakey, number, name) VALUES ';
        teams.forEach((team) => {
            let temp = teamQueryString + '(\'' + team['key'] + '\', \'' + team['team_number'] + '\', \'' + team['nickname'] + '\')';
            pool.query(temp);
        });

        getEventData(req.params.eventKey).then((response) => {
            let eventKey = response['data']['key'];
            let eventName = response['data']['name'];
            let eventStartDate = response['data']['start_date'];
            let eventInfoQueryString = 'INSERT INTO competition (tbakey, name, startdate) VALUES (\'' + eventKey.toString() + '\', \'' + eventName + '\', \'' + eventStartDate + '\')';

            pool.query(eventInfoQueryString);

            getEventMatches(req.params.eventKey).then((response) => {
                let matches = response['data'];

                let matchQueryString = 'INSERT INTO match (tbakey, competitiontbakey, matchtypeid, number) VALUES';

                matches.forEach((match) => {

                    let matchType = 'Q';

                    switch (match['comp_level']) {
                        case 'qm':
                            matchType = 'Q';
                            break;
                        case 'f':
                            matchType = 'F';
                            break;
                        default:
                            matchType = 'P';
                    }

                    let matchKey = match['key'];
                    let tbaCompKey = match['event_key'];
                    let matchNumber = match['match_number'];

                    let temp = matchQueryString + '(\'' + matchKey + '\', \'' + tbaCompKey + '\', \'' + matchType + '\', \'' + matchNumber + '\')';
                    pool.query(temp).then(() => {
                        let redAlliance = match['alliances']['red']['team_keys'];
                        let blueAlliance = match['alliances']['blue']['team_keys'];

                        let robotinMatchQueryString = 'INSERT INTO robotinMatch (matchtbakey, robottbakey, alliancestationid) VALUES';

                        pool.query(robotinMatchQueryString + '(\'' + matchKey + '\', \'' + redAlliance[0] + '\', \'R1\')');
                        pool.query(robotinMatchQueryString + '(\'' + matchKey + '\', \'' + redAlliance[1] + '\', \'R2\')');
                        pool.query(robotinMatchQueryString + '(\'' + matchKey + '\', \'' + redAlliance[2] + '\', \'R3\')');

                        pool.query(robotinMatchQueryString + '(\'' + matchKey + '\', \'' + blueAlliance[0] + '\', \'B1\')');
                        pool.query(robotinMatchQueryString + '(\'' + matchKey + '\', \'' + blueAlliance[1] + '\', \'B2\')');
                        pool.query(robotinMatchQueryString + '(\'' + matchKey + '\', \'' + blueAlliance[2] + '\', \'B3\')');
                    });
                });
            });
        });
    });

    res.send('Event loaded');
})

app.get("/getTeam/:matchtbakey/:alliancestationid", (req, res) => {
    let queryString = `SELECT robot.tbakey, robot.number, robot.name FROM robotinmatch JOIN robot ON (robotinmatch.robottbakey = robot.tbakey) WHERE robotinmatch.matchtbakey = \'${req.params.matchtbakey}\' AND robotinmatch.alliancestationid = \'${req.params.alliancestationid}\'`;
    pool.query(queryString, (error, response) => {
      if (error) {
        console.log(error);
      } else {
        res.status(200).json(response.rows[0]);
      }
    });
  });

app.listen(port, () => {
    console.log(`App listening on port ${port}`)
})