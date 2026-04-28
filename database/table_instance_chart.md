Sol üst:
ROLES → USERS → STUDENT_PROFILES

Orta üst:
FACULTIES → DEPARTMENTS → LABORATORIES

Orta:
STATION_TYPES → WORKSTATIONS

Sağ orta:
EQUIPMENT_TYPES → EQUIPMENT_INSTANCES

Alt:
USERS → RESERVATIONS → RESERVATION_STATUS_HISTORY
LABORATORIES → RESERVATIONS
WORKSTATIONS → RESERVATIONS

ROLES
  ↓
USERS ────────────────→ RESERVATIONS ───────────────→ RESERVATION_STATUS_HISTORY
  ↓                         ↑
STUDENT_PROFILES            ↑
  ↑                         ↑
FACULTIES → DEPARTMENTS → LABORATORIES → WORKSTATIONS
                                      ↑        ↑
                                      │        │
                              EQUIPMENT_INSTANCES
                                      ↑
                              EQUIPMENT_TYPES

STATION_TYPES → WORKSTATIONS

Kullanıcı sisteme girer.
Kullanıcı öğrenci profiline sahiptir.
Fakülte → bölüm → laboratuvar → istasyon hiyerarşisi vardır.
Kullanıcı istasyon için rezervasyon yapar.
İstasyonun içinde cihazlar bulunur.
Rezervasyonun durum geçmişi tutulur.

ROLES
-------------------------
# role_id
* role_name
o description

USERS
-------------------------
# user_id
* role_id
* first_name
* last_name
* email
* password_hash
* password_salt
o phone
* is_active
* created_at
* updated_at

STUDENT_PROFILES
-------------------------
# user_id
* student_no
* faculty_id
* department_id
* class_year
o program_type
USERS üst varlıktır.
STUDENT_PROFILES öğrenci kullanıcıların alt bilgilerini tutan alt varlıktır.

FACULTIES
-------------------------
# faculty_id
* faculty_name
* is_active

DEPARTMENTS
-------------------------
# department_id
* faculty_id
* department_name
* is_active

LABORATORIES
-------------------------
# lab_id
* department_id
* lab_name
* lab_code
* lab_type
o location
o phone
o description
* is_active
* created_at

STATION_TYPES
-------------------------
# station_type_id
* type_name
o description

WORKSTATIONS
-------------------------
# station_id
* lab_id
* station_type_id
* station_code
* station_name
* capacity
* status
o notes
Kullanıcı cihazı değil, masa/istasyon rezerve eder.
Cihazlar istasyonun parçası olarak gösterilir.

EQUIPMENT_TYPES
-------------------------
# equipment_type_id
* equipment_name
* category
o description

EQUIPMENT_INSTANCES
-------------------------
# equipment_id
* equipment_type_id
* lab_id
o station_id
* asset_code
o brand
o model
* status
o notes

RESERVATIONS
-------------------------
# reservation_id
* user_id
* lab_id
* station_id
* start_time
* end_time
o purpose
* status
* created_at
* updated_at

RESERVATION_STATUS_HISTORY
-------------------------
# history_id
* reservation_id
o old_status
* new_status
o changed_by
* changed_at
o note

| No | İlişki                                        | Kardinalite |
| -: | --------------------------------------------- | ----------- |
|  1 | `ROLES` → `USERS`                             | 1 - N       |
|  2 | `USERS` → `STUDENT_PROFILES`                  | 1 - 0/1     |
|  3 | `FACULTIES` → `DEPARTMENTS`                   | 1 - N       |
|  4 | `FACULTIES` → `STUDENT_PROFILES`              | 1 - N       |
|  5 | `DEPARTMENTS` → `STUDENT_PROFILES`            | 1 - N       |
|  6 | `DEPARTMENTS` → `LABORATORIES`                | 1 - N       |
|  7 | `LABORATORIES` → `WORKSTATIONS`               | 1 - N       |
|  8 | `STATION_TYPES` → `WORKSTATIONS`              | 1 - N       |
|  9 | `EQUIPMENT_TYPES` → `EQUIPMENT_INSTANCES`     | 1 - N       |
| 10 | `LABORATORIES` → `EQUIPMENT_INSTANCES`        | 1 - N       |
| 11 | `WORKSTATIONS` → `EQUIPMENT_INSTANCES`        | 1 - N       |
| 12 | `USERS` → `RESERVATIONS`                      | 1 - N       |
| 13 | `LABORATORIES` → `RESERVATIONS`               | 1 - N       |
| 14 | `WORKSTATIONS` → `RESERVATIONS`               | 1 - N       |
| 15 | `RESERVATIONS` → `RESERVATION_STATUS_HISTORY` | 1 - N       |
| 16 | `USERS` → `RESERVATION_STATUS_HISTORY`        | 1 - N       |


USERS üst tiptir.
STUDENT_PROFILES öğrenci kullanıcılar için alt tiptir.