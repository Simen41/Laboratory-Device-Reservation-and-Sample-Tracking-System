<?php

function checkAvailability($pdo, $stationId, $startTime, $endTime, $excludeReservationId = null) {
    $sql = "
        SELECT COUNT(*) AS conflict_count
        FROM reservations
        WHERE station_id = :station_id
        AND status = 'active'
        AND start_time < :end_time
        AND end_time > :start_time
    ";

    $params = [
        ':station_id' => $stationId,
        ':start_time' => $startTime,
        ':end_time' => $endTime
    ];

    if ($excludeReservationId !== null) {
        $sql .= " AND reservation_id != :reservation_id";
        $params[':reservation_id'] = $excludeReservationId;
    }

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    $row = $stmt->fetch();

    return (int)$row['conflict_count'] === 0;
}