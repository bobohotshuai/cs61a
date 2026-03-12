CREATE TABLE finals AS
  SELECT "RSF" AS hall, "61A" as course UNION
  SELECT "Wheeler"    , "61A"           UNION
  SELECT "Pimentel"   , "61A"           UNION
  SELECT "Li Ka Shing", "61A"           UNION
  SELECT "Stanley"    , "61A"           UNION
  SELECT "RSF"        , "61B"           UNION
  SELECT "Wheeler"    , "61B"           UNION
  SELECT "Morgan"     , "61B"           UNION
  SELECT "Wheeler"    , "61C"           UNION
  SELECT "Pimentel"   , "61C"           UNION
  SELECT "Soda 310"   , "61C"           UNION
  SELECT "Soda 306"   , "10"            UNION
  SELECT "RSF"        , "70";

CREATE TABLE sizes AS
  SELECT "RSF" AS room, 900 as seats    UNION
  SELECT "Wheeler"    , 700             UNION
  SELECT "Pimentel"   , 500             UNION
  SELECT "Li Ka Shing", 300             UNION
  SELECT "Stanley"    , 300             UNION
  SELECT "Morgan"     , 100             UNION
  SELECT "Soda 306"   , 80              UNION
  SELECT "Soda 310"   , 40              UNION
  SELECT "Soda 320"   , 30;

CREATE TABLE big AS
  SELECT course
    FROM finals, sizes
    WHERE hall = room
    GROUP BY course
    HAVING SUM(seats) >= 1000;

CREATE TABLE remaining AS
  SELECT course, SUM(seats) - MAX(seats)
    FROM finals, sizes
    WHERE hall = room
    GROUP BY course;

CREATE TABLE sharing AS
  SELECT f1.course, COUNT(*)
    FROM finals AS f1
    WHERE f1.hall IN (
      SELECT hall
        FROM finals
        GROUP BY hall
        HAVING COUNT(DISTINCT course) > 1
    )
    GROUP BY f1.course
    HAVING COUNT(*) > 0;

CREATE TABLE pairs AS
  SELECT s1.room || " and " || s2.room || " together have " ||
         (s1.seats + s2.seats) || " seats"
    FROM sizes AS s1, sizes AS s2
    WHERE s1.room < s2.room AND s1.seats + s2.seats >= 1000
    ORDER BY s1.seats + s2.seats DESC, s1.room, s2.room;

