INSERT INTO
	ARTISTS (NAME, COUNTRY, AGE)
VALUES
	('Coldplay', 'United Kingdom', 27),
	('Eminem', 'United States', 51),
	('The Weeknd', 'Canada', 33);

INSERT INTO
	ALBUMS (TITTLE, ARTIST_ID, RELEASE_DATE, GENRE)
VALUES
	('Parachutes', 10, '2000-07-10', 'Alternative Rock'),
	('The Eminem Show', 11, '2002-05-26', 'Hip-Hop'),
	('After Hours', 12, '2020-03-20', 'R&B');

INSERT INTO
	TRACKS (TITTLE, ALBUM_ID, DURATION)
VALUES
	('Yellow', 13, '00:04:29'),
	('Without Me', 14, '00:04:50'),
	('Blinding Lights', 15, '00:03:20');


SELECT
	*
FROM
	ARTISTS;

SELECT
	*
FROM
	ALBUMS;

SELECT
	*
FROM
	TRACKS;


--update
UPDATE ALBUMS
SET
	TITTLE = 'Parachutes (Remastered)'
WHERE
	TITTLE = 'Parachutes';

--delete

DELETE FROM TRACKS
WHERE
	TITTLE = 'Without Me';


