package transfer.be.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminInterceptor implements HandlerInterceptor {

    @Value("${admin.secret}")
    private String adminSecret;

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
        String method = req.getMethod();
        String path   = req.getRequestURI();

        // editorial-reports: GET는 공개, POST/PUT은 admin만
        if (path.startsWith("/api/editorial-reports") && "GET".equalsIgnoreCase(method)) {
            return true;
        }

        String token = req.getHeader("X-Admin-Token");
        if (adminSecret.equals(token)) {
            return true;
        }

        res.setStatus(HttpServletResponse.SC_FORBIDDEN);
        res.setContentType("application/json");
        res.getWriter().write("{\"error\":\"Forbidden\"}");
        return false;
    }
}
