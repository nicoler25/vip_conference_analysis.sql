-- VIP Conference Analytics | SQL Case Study
-- SQL analysis aligned to README business questions
-- Database: PostgreSQL

/* 
Business Question 1:
Which VIPs are assigned to each conference event?

SQL concepts:
INNER JOIN
*/

SELECT
    v.member_id,
    v.first_name,
    v.last_name,
    e.event_name,
    e.event_type
FROM vips v
JOIN events e
    ON v.event = e.event_id
ORDER BY e.event_name, v.last_name, v.first_name;


/* 
Business Question 2:
Which VIPs have hotel reservations, and which do not?

SQL concepts:
LEFT JOIN
*/

SELECT
    v.member_id,
    v.first_name,
    v.last_name,
    h.hotel_name,
    CASE
        WHEN r.member_id IS NULL THEN 'No Reservation'
        ELSE 'Has Reservation'
    END AS reservation_status
FROM vips v
LEFT JOIN reservations r
    ON v.member_id = r.member_id
LEFT JOIN hotels h
    ON r.hotel = h.hotel_id
ORDER BY reservation_status DESC, v.last_name, v.first_name;


/* 
Business Question 3:
Which events have the highest attendance?

SQL concepts:
JOIN, GROUP BY, aggregation
*/

SELECT
    e.event_id,
    e.event_name,
    e.event_type,
    COUNT(v.member_id) AS attendee_count
FROM events e
LEFT JOIN vips v
    ON e.event_id = v.event
GROUP BY e.event_id, e.event_name, e.event_type
ORDER BY attendee_count DESC, e.event_name;


/* 
Business Question 4:
Which events have more than one attendee?

SQL concepts:
JOIN, GROUP BY, HAVING
*/

SELECT
    e.event_name,
    COUNT(v.member_id) AS attendee_count
FROM events e
JOIN vips v
    ON e.event_id = v.event
GROUP BY e.event_id, e.event_name
HAVING COUNT(v.member_id) > 1
ORDER BY attendee_count DESC, e.event_name;


/* 
Business Question 5:
Which VIPs are connected through peer feedback relationships?

SQL concepts:
SELF JOIN
*/

SELECT
    reviewers.member_id AS reviewer_id,
    reviewers.first_name || ' ' || reviewers.last_name AS reviewer,
    peers.member_id AS peer_id,
    peers.first_name || ' ' || peers.last_name AS feedback_recipient
FROM vips reviewers
JOIN vips peers
    ON reviewers.provides_feedback_to = peers.member_id
ORDER BY reviewer_id;


/* 
Business Question 6:
Which attendees RSVP'd yes to dinner but no to the welcome event?

SQL concepts:
Subquery
*/

SELECT
    v.member_id,
    v.first_name,
    v.last_name
FROM vips v
WHERE v.member_id IN (
    SELECT r.member_id
    FROM reservations r
    WHERE r.welcome_rsvp = 0
      AND r.dinner_rsvp = 1
)
ORDER BY v.last_name, v.first_name;


/* 
Business Question 7:
Which hotel has the highest reservation volume?

SQL concepts:
JOIN, GROUP BY, aggregation
*/

SELECT
    h.hotel_name,
    COUNT(r.member_id) AS reservation_count
FROM hotels h
LEFT JOIN reservations r
    ON h.hotel_id = r.hotel
GROUP BY h.hotel_id, h.hotel_name
ORDER BY reservation_count DESC, h.hotel_name;


/* 
Business Question 8:
What are the overall RSVP trends?

SQL concepts:
CASE, GROUP BY, aggregation
*/

SELECT
    CASE
        WHEN welcome_rsvp = 1 AND dinner_rsvp = 1 THEN 'Welcome: Yes | Dinner: Yes'
        WHEN welcome_rsvp = 0 AND dinner_rsvp = 1 THEN 'Welcome: No | Dinner: Yes'
        WHEN welcome_rsvp = 1 AND dinner_rsvp = 0 THEN 'Welcome: Yes | Dinner: No'
        ELSE 'Welcome: No | Dinner: No'
    END AS rsvp_combination,
    COUNT(*) AS attendee_count
FROM reservations
GROUP BY
    CASE
        WHEN welcome_rsvp = 1 AND dinner_rsvp = 1 THEN 'Welcome: Yes | Dinner: Yes'
        WHEN welcome_rsvp = 0 AND dinner_rsvp = 1 THEN 'Welcome: No | Dinner: Yes'
        WHEN welcome_rsvp = 1 AND dinner_rsvp = 0 THEN 'Welcome: Yes | Dinner: No'
        ELSE 'Welcome: No | Dinner: No'
    END
ORDER BY attendee_count DESC, rsvp_combination;


/* 
Business Question 9:
Which VIPs do not have an assigned event?

SQL concepts:
Filtering for missing values
*/

SELECT
    member_id,
    first_name,
    last_name,
    association,
    assoc_type
FROM vips
WHERE event IS NULL
ORDER BY last_name, first_name;


/* 
Business Question 10:
Which VIPs do not have a matching reservation record?

SQL concepts:
LEFT JOIN, data validation
*/

SELECT
    v.member_id,
    v.first_name,
    v.last_name
FROM vips v
LEFT JOIN reservations r
    ON v.member_id = r.member_id
WHERE r.member_id IS NULL
ORDER BY v.last_name, v.first_name;


/* 
Business Question 11:
Which reservation records do not match a VIP in the attendee table?

SQL concepts:
LEFT JOIN, data validation
*/

SELECT
    r.member_id,
    r.hotel,
    r.welcome_rsvp,
    r.dinner_rsvp
FROM reservations r
LEFT JOIN vips v
    ON r.member_id = v.member_id
WHERE v.member_id IS NULL
ORDER BY r.member_id;
