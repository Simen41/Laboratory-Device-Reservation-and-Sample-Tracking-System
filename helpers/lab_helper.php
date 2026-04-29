<?php

function getAllLabs($pdo) {
    $stmt = $pdo->query("
        SELECT
            l.lab_id,
            l.lab_name,
            l.lab_code,
            l.lab_type,
            l.location,
            d.department_name,
            f.faculty_name
        FROM laboratories l
        JOIN departments d ON l.department_id = d.department_id
        JOIN faculties f ON d.faculty_id = f.faculty_id
        WHERE l.is_active = 1
        ORDER BY l.lab_name ASC
    ");

    return $stmt->fetchAll();
}

function getLabById($pdo, $labId) {
    $stmt = $pdo->prepare("
        SELECT
            l.*,
            d.department_name,
            f.faculty_name
        FROM laboratories l
        JOIN departments d ON l.department_id = d.department_id
        JOIN faculties f ON d.faculty_id = f.faculty_id
        WHERE l.lab_id = :lab_id
        LIMIT 1
    ");

    $stmt->execute([
        ':lab_id' => $labId
    ]);

    return $stmt->fetch();
}

function getStationsByLab($pdo, $labId) {
    $stmt = $pdo->prepare("
        SELECT
            w.*,
            st.type_name
        FROM workstations w
        JOIN station_types st ON w.station_type_id = st.station_type_id
        WHERE w.lab_id = :lab_id
        ORDER BY w.station_code ASC
    ");

    $stmt->execute([
        ':lab_id' => $labId
    ]);

    return $stmt->fetchAll();
}