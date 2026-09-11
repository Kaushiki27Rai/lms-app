package com.lms.util;

import junit.framework.TestCase;

public class PasswordUtilsTest extends TestCase {
    public void testBcryptHashVerifiesAndIsNotPlaintext() {
        String hash = PasswordUtils.hashPassword("safe-password-123");
        assertNotSame("safe-password-123", hash);
        assertTrue(hash.startsWith("$2"));
        assertTrue(PasswordUtils.verifyPassword("safe-password-123", hash));
        assertFalse(PasswordUtils.verifyPassword("wrong-password", hash));
    }

    public void testLegacyPasswordIsRecognizedForMigration() {
        assertTrue(PasswordUtils.verifyPassword("legacy", "legacy"));
        assertTrue(PasswordUtils.needsUpgrade("legacy"));
    }
}
