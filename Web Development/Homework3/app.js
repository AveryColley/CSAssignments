/*  Avery Colley
 *  Section AC
 *
 *  The yipper API, allows users to make a request to a given endpoint and get back information
 *  about "yips"
 */

"use strict";

const express = require("express");
const sqlite3 = require("sqlite3");
const sqlite = require("sqlite");
const multer = require("multer");
const app = express();

app.use(multer().none());
app.use(express.urlencoded({extended: true}));
app.use(express.json());
app.use(express.static("public"));

/*  returns a json that contains an array of all of the different "yips" and all of their
 *  properties
 */
app.get("/yipper/yips", async (req, res) => {
  res.type("json");
  let search = req.query["search"];
  if (search === undefined) {
    try {
      let db = await getDBConnection();
      let rows = await db.all("SELECT * FROM yips ORDER BY date DESC");
      await db.close();
      res.send({"yips": rows});
    } catch (err) {
      res.status(500).send("An error occured on the server. Try again later.");
    }
  } else {
    try {
      let db = await getDBConnection();
      let qry = "SELECT id FROM yips WHERE yip LIKE ?";
      search = "%" + search + "%";
      let ids = await db.all(qry, [search]);
      await db.close();
      res.send({"yips": ids});
    } catch (err) {
      res.status(400).send("Something went wrong");
    }
  }
});

/*  Returns all of the "yips" made by a given user in an array
 */
app.get("/yipper/user/:user", async (req, res) => {
  res.type("json");
  let user = req.params["user"];
  try {
    let db = await getDBConnection();
    let qry = "SELECT name, yip, hashtag, date FROM yips WHERE name=? ORDER BY date DESC";
    let fullYips = await db.all(qry, [user]);
    await db.close();
    res.send(fullYips);
  } catch (err) {
    res.status(400).send("User not found");
  }
});

/*  Increments the amount of likes the "yip" with the given id has and returns the
 *  new amount of likes as plaintext
 */
app.post("/yipper/likes", async (req, res) => {
  res.type("text");
  let id = req.body.id;
  if (id === undefined) {
    res.status(400).send("Missing one or more of the required params.");
  } else {
    try {
      let db = await getDBConnection();
      let getLikesQry = "SELECT likes FROM yips WHERE id=?";
      let currentLikes = await db.get(getLikesQry, [id]);
      let newLikes = currentLikes.likes += 1;
      let updateLikesQry = "UPDATE yips SET likes=" + newLikes + " WHERE id=" + id;
      await db.exec(updateLikesQry);
      await db.close();
      res.send("" + newLikes);
    } catch (err) {
      res.status(400).send("Yikes. ID does not exist.");
    }
  }
});

/*  Adds a new "yip" to the database, the give "yip" must follow the correct format:
 *  Any amount of "word characters" (a-z.?!_) or whitespaces followed by a single # with no
 *  whitespaces afterwards, but any amount of letters or numbers
 */
app.post("/yipper/new", async (req, res) => {
  res.type("json");
  let fullText = req.body.full;
  let name = req.body.name;
  if (name === undefined || fullText === undefined) {
    res.status(400).send("Missing one or more of the required params.");
  } else if (fullText.match("[a-zA-Z_!?.]+ #[a-zA-Z\d]+$") === null) {
    res.status(400).send("Yikes. Yip format is invalid.");
  } else {
    let yip = fullText.split("#");
    let yipText = yip[0].trim();
    let yipHashtag = yip[1];
    try {
      let db = await getDBConnection();
      try {
        let nameCheckQry = "SELECT * FROM yips WHERE name=?";
        await db.exec(nameCheckQry, [name]);
      } catch (err) {
        res.status(400).send("Yikes. User does not exist.");
      }
      let qry = "INSERT INTO yips (name, yip, hashtag, likes) VALUES (?, ?, ?, 0)";
      let lastId = (await db.run(qry, [name, yipText, yipHashtag])).lastID;
      let newYip = await db.get("SELECT * FROM yips WHERE id=" + lastId);
      db.close();
      res.send(newYip);
    } catch (err) {
      res.status(500).send("An error occurred on the server. Try again later.");
    }
  }
});

/**
 * Returns a connection to the database given by "filename"
 * @returns Database connection
 */
async function getDBConnection() {
  const db = await sqlite.open({
    filename: 'yipper.db',
    driver: sqlite3.Database
  });
  return db;
}

const PORT = process.env.PORT || 8000;
app.listen(PORT);