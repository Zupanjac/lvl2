-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Drop the tournament database if exists
DROP DATABASE IF EXISTS tournament;

-- Create the database
CREATE DATABASE tournament;

-- Connect to the tournament database
\c  tournament

-- Create the player table
CREATE TABLE player
(
   id      serial PRIMARY KEY,
   name    text UNIQUE NOT NULL
);

-- Create the match table
CREATE TABLE match
(
   id          serial PRIMARY KEY,
   loser       integer REFERENCES player (id),
   winner      integer REFERENCES player (id)
);

-- Create the standing view
CREATE OR REPLACE VIEW standing AS
   SELECT player.id, player.name,
   (SELECT count(*) FROM match where winner = player.id) AS wins,
   (SELECT count(*) FROM match
   WHERE match.winner = player.id OR match.loser = player.id) AS matches
   FROM player
   GROUP BY player.id, player.name
   ORDER BY wins DESC;

