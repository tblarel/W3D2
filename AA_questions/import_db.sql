PRAGMA foreign_keys = ON;

DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE question_follows;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  
  body TEXT,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Tristan', 'the man'),
  ('Grant', 'also the man'),
  ('silly', 'question asker'),
  ('first', 'last'),
  ('bob', 'saget');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('how to dance', 'lots of words', (SELECT id FROM users WHERE fname = 'silly')),
  ('what is the meaning of it all', 'too much explanation', (SELECT id FROM users WHERE fname = 'bob')),
  ('where to eat?', 'sooooo many places', (SELECT id FROM users WHERE fname = 'Grant'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Tristan'), (SELECT id FROM questions WHERE title LIKE '%meaning%')),
  ((SELECT id FROM users WHERE fname = 'Tristan'), (SELECT id FROM questions WHERE title LIKE '%eat%')),
  ((SELECT id FROM users WHERE fname = 'first'), (SELECT id FROM questions WHERE title LIKE '%eat%'));

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title LIKE '%dance%'), NULL, (SELECT id FROM users WHERE fname = 'first'), 'I wish I knew how to dance. do you know how?'),
  ((SELECT id FROM questions WHERE title LIKE '%dance%'), 1, (SELECT id FROM users WHERE fname = 'bob'), 'ya I can teach you how to swing dance ;)' ),
  ((SELECT id FROM questions WHERE title LIKE '%eat%'), NULL, (SELECT id FROM users WHERE fname = 'Tristan'), 'ya I know a good chinese place!' );

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'first'), (SELECT id FROM questions WHERE title LIKE '%dance%')),
  ((SELECT id FROM users WHERE fname = 'Grant'), (SELECT id FROM questions WHERE title LIKE '%eat%'));
