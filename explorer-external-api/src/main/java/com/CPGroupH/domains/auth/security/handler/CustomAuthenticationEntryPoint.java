package com.CPGroupH.domains.auth.security.handler;

import com.CPGroupH.error.code.AuthErrorCode;
import com.CPGroupH.error.code.ErrorCode;
import com.CPGroupH.response.ResponseFactory;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {
    private final ObjectMapper objectMapper;

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
                         AuthenticationException authException) throws IOException, ServletException {
        Object errorObj = request.getAttribute("error");
        ErrorCode errorCode =
                errorObj instanceof ErrorCode ? (ErrorCode) errorObj : AuthErrorCode.AUTHENTICATION_FAILED;
        ResponseEntity<Object> errorResponse = ResponseFactory.failure(errorCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(errorResponse.getStatusCode()
                .value());
        response.getWriter()
                .write(new ObjectMapper().writeValueAsString(errorResponse.getBody()));
        response.getWriter()
                .flush();
    }
}

