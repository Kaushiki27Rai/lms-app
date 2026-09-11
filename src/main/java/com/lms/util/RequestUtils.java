package com.lms.util;

public final class RequestUtils {
    private RequestUtils() { }
    public static int positiveInt(String value) {
        try { int parsed = Integer.parseInt(value); return parsed > 0 ? parsed : -1; }
        catch (NumberFormatException | NullPointerException ignored) { return -1; }
    }
}
