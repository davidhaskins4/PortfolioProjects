SELECT * FROM players;

-- Find batting average and sort from highest to lowest of active position players
Select p.name, team, AB, (H/AB) as BatAvg
FROM players as p
JOIN atbats as ab
USING (playerid)
WHERE team= "COL"
ORDER BY BatAvg DESC;

-- Colorado Rockies Batting Average for 2018
Select team, sum(AB)as TeamAB, (sum(H)/sum(AB)) as  TeamBatAvg
FROM players as p
JOIN atbats as ab
USING (playerid)
WHERE team= "COL"
group by team;

-- Colorado vs rest of the league (position players only)
Select team, sum(AB)as TeamAB, (sum(H)/sum(AB)) as  TeamBatAvg
FROM players as p
JOIN atbats as ab
USING (playerid)
group by team
ORDER By teambatavg Desc;

-- Create roster for 2018 Colorado Rockies
SELECT concat(nameFirst, " ", namelast) as name, pi.teamid as Team, lgid
FROM pitches as pi
JOIN atbats
ON pi.teamid=atbats.team
WHERE Team = "COL"
UNION
SELECT players. name, ab.team as Team, lg
FROM players 
JOIN atbats as ab
ON players.name=ab.name
WHERE Team = "COL"
ORDER BY name;

-- Do teams with higher HR totals have more wins?

SELECT HR, W, (w/g), (hr/g)
FROM Teams
ORDER BY W DESC;

DROP VIEW IF exists baseballproject.leagueba;
create view LeagueBA as
Select team, sum(ab.AB)as TeamAB, (sum(ab.H)/sum(ab.AB)) as  TeamBatAvg, W
FROM players as p
JOIN atbats as ab
ON p.name= ab.name
Join teams
on ab.team= teams.teamid
group by team
ORDER By teambatavg Desc;

-- Creation of Temporary Table
DROP table if exists pits;
CREATE temporary table pits 
SELECT teamid as teamid, w,l
FROM
(SELECT pi.teamid, pi.w, pi.l
FROM pitches as pi
Inner join teams
ON pi.teamid=teams.teamid) as c
;
SELECT teamid as Team, sum(pits.w) as Wins, sum(pits.l) as Losses, (sum(pits.w) + sum(pits.l)) as TotalGames, sum(pits.w)/(sum(pits.w)+sum(pits.l)) as WinningPercentage, divwin from Pits
INNER JOin teams
USING(teamid)
GROUP BY teamid
Having divwin = "Y";






-- Created View

CREATE VIEW pitchperc AS
WITH pits (name, team, wins, losses)
as 
(SELECT concat(nameFirst, " ", namelast) as name, pi.teamid, pi.w, pi.l
FROM pitches as pi
Inner join teams
ON pi.teamid=teams.teamid)
SELECT *, (wins/(wins+losses)) as WinningPercentage 
from pits;



