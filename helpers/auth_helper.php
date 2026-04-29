<?php

function hashPasswordWithSalt($password, $salt) {
    return hash('sha256', $salt . $password);
}

function verifyPassword($password, $salt, $storedHash) {
    return hashPasswordWithSalt($password, $salt) === $storedHash;
}

function isLoggedIn() {
    return isset($_SESSION['user_id']);
}

function isAdmin() {
    return isset($_SESSION['role_name']) && $_SESSION['role_name'] === 'admin';
}

function getCurrentUserId() {
    return $_SESSION['user_id'] ?? null;
}