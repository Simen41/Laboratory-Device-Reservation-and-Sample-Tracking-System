DROP DATABASE IF EXISTS lab_reservation_early;

CREATE DATABASE lab_reservation_early
CHARACTER SET utf8mb4
COLLATE utf8mb4_turkish_ci;

USE lab_reservation_early;

SET NAMES utf8mb4;

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    password_salt VARCHAR(64) NOT NULL,
    phone VARCHAR(30),
    is_active TINYINT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles(role_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE faculties (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_name VARCHAR(150) NOT NULL UNIQUE,
    is_active TINYINT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_id INT NOT NULL,
    department_name VARCHAR(150) NOT NULL,
    is_active TINYINT NOT NULL DEFAULT 1,

    CONSTRAINT uq_departments_faculty_name
        UNIQUE (faculty_id, department_name),

    CONSTRAINT fk_departments_faculty
        FOREIGN KEY (faculty_id)
        REFERENCES faculties(faculty_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE student_profiles (
    user_id INT PRIMARY KEY,
    student_no VARCHAR(20) NOT NULL UNIQUE,
    faculty_id INT NOT NULL,
    department_id INT NOT NULL,
    class_year TINYINT NOT NULL,
    program_type VARCHAR(30),

    CONSTRAINT fk_student_profiles_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_student_profiles_faculty
        FOREIGN KEY (faculty_id)
        REFERENCES faculties(faculty_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_student_profiles_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE laboratories (
    lab_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    lab_name VARCHAR(180) NOT NULL,
    lab_code VARCHAR(30) NOT NULL UNIQUE,
    lab_type ENUM('computer', 'network', 'electronics', 'machine', 'general') NOT NULL,
    location VARCHAR(180),
    phone VARCHAR(30),
    description TEXT,
    is_active TINYINT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_laboratories_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE station_types (
    station_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE workstations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    lab_id INT NOT NULL,
    station_type_id INT NOT NULL,
    station_code VARCHAR(40) NOT NULL,
    station_name VARCHAR(150) NOT NULL,
    capacity INT NOT NULL DEFAULT 1,
    status ENUM('active', 'maintenance', 'passive') NOT NULL DEFAULT 'active',
    notes TEXT,

    CONSTRAINT uq_workstations_lab_station_code
        UNIQUE (lab_id, station_code),

    CONSTRAINT uq_workstations_station_lab
        UNIQUE (station_id, lab_id),

    CONSTRAINT fk_workstations_lab
        FOREIGN KEY (lab_id)
        REFERENCES laboratories(lab_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_workstations_station_type
        FOREIGN KEY (station_type_id)
        REFERENCES station_types(station_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE equipment_types (
    equipment_type_id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_name VARCHAR(120) NOT NULL,
    category VARCHAR(80) NOT NULL,
    description TEXT,

    CONSTRAINT uq_equipment_types_name_category
        UNIQUE (equipment_name, category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE equipment_instances (
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_type_id INT NOT NULL,
    lab_id INT NOT NULL,
    station_id INT NULL,
    asset_code VARCHAR(80) NOT NULL UNIQUE,
    brand VARCHAR(80),
    model VARCHAR(100),
    status ENUM('available', 'maintenance', 'passive') NOT NULL DEFAULT 'available',
    notes TEXT,

    CONSTRAINT fk_equipment_instances_type
        FOREIGN KEY (equipment_type_id)
        REFERENCES equipment_types(equipment_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_equipment_instances_lab
        FOREIGN KEY (lab_id)
        REFERENCES laboratories(lab_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_equipment_instances_station_lab
        FOREIGN KEY (station_id, lab_id)
        REFERENCES workstations(station_id, lab_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    lab_id INT NOT NULL,
    station_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    purpose VARCHAR(255),
    status ENUM('active', 'cancelled', 'completed') NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_reservations_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservations_lab
        FOREIGN KEY (lab_id)
        REFERENCES laboratories(lab_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservations_station_lab
        FOREIGN KEY (station_id, lab_id)
        REFERENCES workstations(station_id, lab_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_reservations_time
        CHECK (end_time > start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

CREATE INDEX idx_reservations_station_time_status
ON reservations (station_id, status, start_time, end_time);

CREATE INDEX idx_reservations_user_status
ON reservations (user_id, status);

CREATE INDEX idx_reservations_lab_status
ON reservations (lab_id, status);

CREATE TABLE reservation_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by INT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note VARCHAR(255),

    CONSTRAINT fk_reservation_status_history_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservations(reservation_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_reservation_status_history_changed_by
        FOREIGN KEY (changed_by)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;