package com.lms.dto;

public class ApiResponse<T> {
    public final boolean success; public final String message; public final T data;
    public ApiResponse(boolean success, String message, T data) { this.success=success; this.message=message; this.data=data; }
    public static <T> ApiResponse<T> ok(String message, T data) { return new ApiResponse<>(true,message,data); }
    public static ApiResponse<Object> error(String message) { return new ApiResponse<>(false,message,null); }
}
