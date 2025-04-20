package com.paysync.backend.security;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class FirebaseTokenFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseTokenFilter.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
                                    throws ServletException, IOException {
          // ✅ Skip OPTIONS requests (preflight)
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
            filterChain.doFilter(request, response); // ✅ let other filters run
            return;
        }
        // Get the Authorization header from the request
        String authHeader = request.getHeader("Authorization");

        // Check if the header is present and starts with "Bearer "
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            // Extract the token (remove "Bearer " part)
            String idToken = authHeader.substring(7);

            try {
                // Verify the token using Firebase Admin SDK
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
                String uid = decodedToken.getUid();
                logger.info("✅ Verified Firebase token for UID: {}", uid);

                // Optionally, you can attach the uid or entire token to the request for downstream usage:
                request.setAttribute("uid", uid);

            } catch (FirebaseAuthException e) {
                logger.error("❌ Invalid Firebase token", e);
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid Firebase token");
                return; // Stop further processing if token is invalid
            }
        } else {
            logger.warn("⚠️ Missing or malformed Authorization header");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Missing or invalid Authorization header");
            return; // Stop further processing if no token is provided
        }

        // Continue processing the request
        filterChain.doFilter(request, response);
    }
}
