const {postgres, TBA} = require('./config.json');

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

async function requestData(endpoint) {
    let config = {
        headers: { 'X-TBA-Auth-Key': TBA['authKey'] },
        baseURL: 'https://www.thebluealliance.com/api/v3'
    }

    return await axios.get(endpoint, config);
}

app.get('/status', (req, res) => {
    res.send('App is running')
})

app.get('/loadEvent/:eventKey', (req, res) => {
    getEventData(req.params.eventKey).then((response) => {
        let eventKey = response['data']['key'];
        let eventName = response['data']['name'];
        let eventStartDate = response['data']['start_date'];
        let eventInfoQueryString = 'INSERT INTO competition (tbakey, name, startdate) VALUES (\'' + eventKey.toString() + '\', \'' + eventName + '\', \'' + eventStartDate + '\')';

        pool.query(eventInfoQueryString);

        getEventTeams(req.params.eventKey).then((response) => {
            let teams = response['data'];
            let teamQueryString = 'INSERT INTO robot (tbakey, number, name) VALUES ';
            teams.forEach((team) => {
                let temp = teamQueryString + '(\'' + team['key'] + '\', \'' + team['team_number'] + '\', \'' + team['nickname'] + '\')';
                pool.query(temp);
            });
        });

        res.send(eventName + ' - ' + eventKey + ' (' + eventStartDate + ')' + ' loaded');
    });
})

app.listen(port, () => {
    console.log(`App listening on port ${port}`)
})