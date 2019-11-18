PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
   id INTEGER PRIMARY KEY,
   fname VARCHAR(255) NOT NULL,
   lname VARCHAR(255) NOT NULL
);

INSERT INTO
   users (fname, lname)
VALUES 
   ("Jim", "Broadbent"),
   ("Lily", "Cortadi"),
   ("Neil", "Christian");

CREATE TABLE questions (
   id INTEGER PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   body TEXT NOT NULL,
   author_id INTEGER NOT NULL,

   FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
   questions (title, body, author_id)
SELECT
   "Jim's Question", "What is Jim?", users.id
FROM
   users
WHERE
   fname = "Jim" AND lname = "Broadbent";

INSERT INTO
   questions (title, body, author_id)
SELECT
   "Neil's Question", "What is Neil?", users.id
FROM
   users
WHERE
   fname = "Neil" AND lname = "Christian";

INSERT INTO
   questions (title, body, author_id)
SELECT
   "Lily's Question", "What is Lily?", users.id
FROM
   users
WHERE
   fname = "Lily" AND lname = "Cortadi";

CREATE TABLE question_follows
(
   id INTEGER PRIMARY KEY,
   question_id INTEGER NOT NULL,
   follower_id INTEGER NOT NULL,

   FOREIGN KEY (question_id) REFERENCES questions(id),
   FOREIGN KEY (follower_id) REFERENCES users(id)
);

INSERT INTO
   question_follows
   (question_id, follower_id)
VALUES
   ( (SELECT id FROM questions WHERE title = "Jim's Question"),
     (SELECT id FROM users WHERE fname = "Jim" AND lname = "Broadbent") 
);

INSERT INTO
   question_follows
   (question_id, follower_id)
VALUES
   ( (SELECT id FROM questions WHERE title = "Lily's Question"),
     (SELECT id FROM users WHERE fname = "Lily" AND lname = "Cortadi") 
);

INSERT INTO
   question_follows
   (question_id, follower_id)
VALUES
   ( (SELECT id FROM questions WHERE title = "Lily's Question"),
      (SELECT id FROM users WHERE fname = "Neil" AND lname = "Christian") 
);

CREATE TABLE replies
(
   id INTEGER PRIMARY KEY,
   subject_question_id INTEGER NOT NULL,
   author_id INTEGER NOT NULL,
   body TEXT NOT NULL,
   parent_id INTEGER,

   FOREIGN KEY (subject_question_id) REFERENCES questions(id),
   FOREIGN KEY (author_id) REFERENCES users(id),
   FOREIGN KEY (parent_id) REFERENCES replies(id)
);

INSERT INTO 
   replies (subject_question_id, author_id, body, parent_id)
VALUES
   ( (SELECT id FROM questions WHERE title = "Jim's Question"),
     (SELECT id FROM users WHERE fname = "Neil" AND lname ="Christian"),
     "Jim is actually Lily.", 
     NULL
);

INSERT INTO 
   replies (subject_question_id, author_id, body, parent_id)
VALUES
   ( (SELECT id FROM questions WHERE title = "Jim's Question"),
      (SELECT id FROM users WHERE fname = "Lily" AND lname ="Cortadi"),
      "No, Lily is actually Jim.",
      (SELECT id FROM replies WHERE body = "Jim is actually Lily.")
);
     


CREATE TABLE question_likes
(
   id INTEGER PRIMARY KEY,
   user_id INTEGER NOT NULL,
   question_id INTEGER NOT NULL,

   FOREIGN KEY (user_id) REFERENCES users(id),
   FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
   question_likes
   (user_id, question_id)
VALUES
   ( (SELECT id FROM users WHERE fname = "Neil" AND lname = "Christian"),
     (SELECT id FROM questions WHERE title = "Lily's Question")
);

