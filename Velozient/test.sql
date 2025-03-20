SELECT 
    t.ID,
    CASE 
        WHEN t.PID IS NULL OR NOT EXISTS (SELECT 1 FROM tree WHERE ID = t.PID) THEN 'Root'
        WHEN NOT EXISTS (SELECT 1 FROM tree WHERE PID = t.ID) THEN 'Leaf'
        ELSE 'Inner'
    END AS Type
FROM tree t
ORDER BY t.ID;SELECT 
    t.ID,
    CASE 
        WHEN t.PID IS NULL OR NOT EXISTS (SELECT 1 FROM tree WHERE ID = t.PID) THEN 'Root'
        WHEN NOT EXISTS (SELECT 1 FROM tree WHERE PID = t.ID) THEN 'Leaf'
        ELSE 'Inner'
    END AS Type
FROM tree t
ORDER BY t.ID;