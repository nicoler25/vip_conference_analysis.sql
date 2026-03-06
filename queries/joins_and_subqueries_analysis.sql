-- ============================================================
-- SQL Joins & Subqueries Case Study
-- Purpose: Demonstrate joins, self-joins, and subqueries using
-- a relational VIP conference dataset
-- ============================================================


-- INNER JOIN
-- List VIP members and the events they are attending
SELECT
    v.member_id,
    v.first_name,
    v.last_name,
    e.event_name
FROM vips v
INNER JOIN events e
    ON v.event = e.event_id
ORDER BY v.member_id;


-- LEFT JOIN
-- Show all VIPs, including those without hotel reservations
SELECT
    v.member_id,
    v.first_name,
    v.last_name,
    r.hotel
FROM vips v
LEFT JOIN reservations r
    ON v.member_id = r.member_id
ORDER BY v.member_id;


-- SELF JOIN
-- Identify VIPs providing feedback to other VIPs
SELECT
    reviewers.member_id AS reviewer_id,
    reviewers.first_name || ' ' || reviewers.last_name AS reviewer,
    peers.first_name || ' ' || peers.last_name AS being_reviewed
FROM vips reviewers
JOIN vips peers
    ON reviewers.provides_feedback_to = peers.member_id
ORDER BY reviewer_id;


-- MULTIPLE JOINS
-- Show VIPs, their assigned event names, and hotel names
SELECT
    v.first_name,
    v.last_name,
    e.event_name,
    h.hotel_name
FROM vips v
JOIN events e
    ON v.event = e.event_id
LEFT JOIN reservations r
    ON v.member_id = r.member_id
LEFT JOIN hotels h
    ON r.hotel = h.hotel_id;


-- SUBQUERY + JOIN
-- Show VIPs attending events with more than 1 attendee
SELECT
    v.first_name,
    v.last_name,
    e.event_name
FROM vips v
JOIN events e
    ON v.event = e.event_id
WHERE v.event IN (
    SELECT event
    FROM vips
    GROUP BY event
    HAVING COUNT(*) > 1
);


-- BUSINESS QUESTION
-- Which VIPs RSVP'd for dinner but not the welcome event?
SELECT
    v.first_name,
    v.last_name
FROM vips v
JOIN reservations r
    ON v.member_id = r.member_id
WHERE r.dinner_rsvp = 1
  AND r.welcome_rsvp = 0;
