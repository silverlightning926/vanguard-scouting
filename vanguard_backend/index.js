const { postgres, TBA } = require("./config.json");

const express = require("express");
const bodyParser = require("body-parser");
const app = express();
app.use(bodyParser.json());
const port = 3000;

const { Pool } = require("pg");

const pool = new Pool(postgres);

const axios = require("axios");

function getEventData(eventKey) {
  return requestData("event/" + eventKey + "/simple");
}

function getEventTeams(eventKey) {
  return requestData("event/" + eventKey + "/teams/simple");
}

function getEventMatches(eventKey) {
  return requestData("event/" + eventKey + "/matches/simple");
}

async function requestData(endpoint) {
  let config = {
    headers: { "X-TBA-Auth-Key": TBA["authKey"] },
    baseURL: "https://www.thebluealliance.com/api/v3",
  };

  return await axios.get(endpoint, config);
}

app.get("/status", (req, res) => {
  res.status(200).json({ status: "OK" });
});

app.get("/loadEvent/:eventKey", (req, res) => {
  getEventTeams(req.params.eventKey).then((response) => {
    let teams = response["data"];
    let teamQueryString = "INSERT INTO robot (tbakey, number, name) VALUES ";
    teams.forEach((team) => {
      let temp =
        teamQueryString +
        "('" +
        team["key"] +
        "', '" +
        team["team_number"] +
        "', '" +
        team["nickname"] +
        "')";
      pool.query(temp);
    });

    getEventData(req.params.eventKey).then((response) => {
      let eventKey = response["data"]["key"];
      let eventName = response["data"]["name"];
      let eventStartDate = response["data"]["start_date"];
      let eventInfoQueryString =
        "INSERT INTO competition (tbakey, name, startdate) VALUES ('" +
        eventKey.toString() +
        "', '" +
        eventName +
        "', '" +
        eventStartDate +
        "')";

      pool.query(eventInfoQueryString);

      getEventMatches(req.params.eventKey).then((response) => {
        let matches = response["data"];

        let matchQueryString =
          "INSERT INTO match (tbakey, competitiontbakey, matchtypeid, number) VALUES";

        matches.forEach((match) => {
          let matchType = "Q";

          switch (match["comp_level"]) {
            case "qm":
              matchType = "Q";
              break;
            case "f":
              matchType = "F";
              break;
            default:
              matchType = "P";
          }

          let matchKey = match["key"];
          let tbaCompKey = match["event_key"];
          let matchNumber = match["match_number"];

          let temp =
            matchQueryString +
            "('" +
            matchKey +
            "', '" +
            tbaCompKey +
            "', '" +
            matchType +
            "', '" +
            matchNumber +
            "')";
          pool.query(temp, (error, response) => {
            if (error) {
              console.log(error);
              res.sendStatus(500);
            } else {
              let redAlliance = match["alliances"]["red"]["team_keys"];
              let blueAlliance = match["alliances"]["blue"]["team_keys"];

              let robotinMatchQueryString =
                "INSERT INTO robotinMatch (matchtbakey, robottbakey, alliancestationid) VALUES";

              pool.query(
                robotinMatchQueryString +
                  "('" +
                  matchKey +
                  "', '" +
                  redAlliance[0] +
                  "', 'R1')"
              );
              pool.query(
                robotinMatchQueryString +
                  "('" +
                  matchKey +
                  "', '" +
                  redAlliance[1] +
                  "', 'R2')"
              );
              pool.query(
                robotinMatchQueryString +
                  "('" +
                  matchKey +
                  "', '" +
                  redAlliance[2] +
                  "', 'R3')"
              );

              pool.query(
                robotinMatchQueryString +
                  "('" +
                  matchKey +
                  "', '" +
                  blueAlliance[0] +
                  "', 'B1')"
              );
              pool.query(
                robotinMatchQueryString +
                  "('" +
                  matchKey +
                  "', '" +
                  blueAlliance[1] +
                  "', 'B2')"
              );
              pool.query(
                robotinMatchQueryString +
                  "('" +
                  matchKey +
                  "', '" +
                  blueAlliance[2] +
                  "', 'B3')"
              );
              res.sendStatus(200);
            }
          });
        });
      });
    });
  });

  res.json({ status: "OK" }).end();
});

app.get("/getCompetitions", (req, res) => {
  let queryString =
    "SELECT * FROM competition ORDER BY competition.startdate DESC";
  pool.query(queryString, (error, response) => {
    if (error) {
      console.log(error);
      res.sendStatus(500);
    } else {
      res.status(200).json(response.rows);
    }
  });
});

app.get("/getMatches/:competitiontbakey", (req, res) => {
  let queryString = `SELECT match.tbakey, match.matchtypeid, match.number FROM match WHERE match.competitiontbakey = '${req.params.competitiontbakey}' ORDER BY match.matchtypeid DESC, number::integer ASC`;
  pool.query(queryString, (error, response) => {
    if (error) {
      console.log(error);
      res.sendStatus(500);
    } else {
      res.status(200).json(response.rows);
    }
  });
});

app.get("/getTeam/:matchtbakey/:alliancestationid", (req, res) => {
  let queryString = `SELECT robotinmatch.id AS robotinmatchid, robot.tbakey, robot.number, robot.name FROM robotinmatch JOIN robot ON (robotinmatch.robottbakey = robot.tbakey) WHERE robotinmatch.matchtbakey = \'${req.params.matchtbakey}\' AND robotinmatch.alliancestationid = \'${req.params.alliancestationid}\'`;
  pool.query(queryString, (error, response) => {
    if (error) {
      console.log(error);
    } else {
      res.status(200).json(response.rows[0]);
    }
  });
});

app.post("/startMatch/:robotinmatchid/:preloadedpieceid", (req, res) => {
  let queryString = `INSERT INTO scout (robotinmatchid, preloadedpieceid) VALUES (${req.params.robotinmatchid}, \'${req.params.preloadedpieceid}\') RETURNING id as scoutid`;
  pool.query(queryString, (error, response) => {
    if (error) {
      console.log(error);
    } else {
      let scoutId = response.rows[0]["scoutid"];
      let queryString = `INSERT INTO startfinishevent (scoutid, startfinishtypeid, timeoccurred) VALUES (${scoutId}, 'S',  now()::timestamp(0))`;
      pool.query(queryString, (error, response) => {
        if (error) {
          console.log(error);
        } else {
          res.status(200).json(response.rows[0]);
        }
      });
    }
  });
});

app.post("/endMatch/:scoutid/", (req, res) => {
  let queryString = `INSERT INTO startfinishevent (scoutid, startfinishtypeid, timeoccurred) VALUES (${req.params.scoutid}, 'F',  now()::timestamp(0))`;
  pool.query(queryString, (error, response) => {
    if (error) {
      console.log(error);
      res.sendStatus(500);
    } else {
      res.sendStatus(200);
    }
  });
});

app.post("/addNotes/:scoutid", (req, res) => {
  let queryString = `UPDATE scout SET notes = \'${req.body["notes"]}\' WHERE id = ${req.params.scoutid}`;
  console.log(queryString);
  pool.query(queryString, (error, response) => {
    if (error) {
      console.log(error);
      res.sendStatus(500);
    } else {
      res.sendStatus(200);
    }
  });
});

app.post(
  "/pickUpGamePiece/:scoutid/:matchperiod/:gamepiece/:pickuplocationid",
  (req, res) => {
    let queryString =
      "INSERT INTO pickupgamepieceevent (scoutid, matchperiodid, gamepieceid, pickuplocationid, timeoccurred) VALUES (" +
      req.params.scoutid +
      ", '" +
      req.params.matchperiod +
      "', '" +
      req.params.gamepiece +
      "', '" +
      req.params.pickuplocationid +
      "', now()::timestamp(0))";

    console.log(queryString);

    pool.query(queryString, (error, response) => {
      if (error) {
        console.log(error);
        res.sendStatus(500);
      } else {
        res.sendStatus(200);
      }
    });
  }
);

app.post(
  "/scoreGamePiece/:scoutid/:matchperiod/:gamepiece/:scoringlocationid",
  (req, res) => {
    let queryString =
      "INSERT INTO scoregamepieceevent (scoutid, matchperiodid, gamepieceid, scoringlocationid, timeoccurred) VALUES (" +
      req.params.scoutid +
      ", '" +
      req.params.matchperiod +
      "', '" +
      req.params.gamepiece +
      "', '" +
      req.params.scoringlocationid +
      "', now()::timestamp(0))";

    console.log(queryString);

    pool.query(queryString, (error, response) => {
      if (error) {
        console.log(error);
        res.sendStatus(500);
      } else {
        res.sendStatus(200);
      }
    });
  }
);

app.post(
  "/scoreNonGamePiece/:scoutid/:matchperiod/:scoringtype",
  (req, res) => {
    let queryString =
      "INSERT INTO nongamepiecescoringevent (scoutid, matchperiodid, nongamepiecescoringtypeid, timeoccurred) VALUES (" +
      req.params.scoutid +
      ", '" +
      req.params.matchperiod +
      "', '" +
      req.params.scoringtype +
      "', now()::timestamp(0))";

    console.log(queryString);

    pool.query(queryString, (error, response) => {
      if (error) {
        console.log(error);
        res.sendStatus(500);
      } else {
        res.sendStatus(200);
      }
    });
  }
);

app.post("/addFault/:scoutid/:matchperiod/:faulttypeid", (req, res) => {
  let queryString = `INSERT INTO faultevent (scoutid, matchperiodid, faulttypeid, timeoccurred) VALUES (${req.params.scoutid}, \'${req.params.matchperiod}\', \'${req.params.faulttypeid}\', now()::timestamp(0))`;

  pool.query(queryString, (error, response) => {
    if (error) {
      console.log(error);
      res.sendStatus(500);
    } else {
      res.sendStatus(200);
    }
  });
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
