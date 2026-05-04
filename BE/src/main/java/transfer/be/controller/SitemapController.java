package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.repository.EditorialReportRepository;
import transfer.be.repository.PlayerRepository;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class SitemapController {

    private static final String BASE = "https://transfer-map.com/";

    private final PlayerRepository playerRepository;
    private final EditorialReportRepository editorialReportRepository;

    @GetMapping(value = "/api/sitemap-players", produces = MediaType.APPLICATION_XML_VALUE)
    public String playerSitemap() {
        return buildUrlset(playerRepository.findAllIds(), BASE + "players/", "monthly", "0.7");
    }

    @GetMapping(value = "/api/sitemap-reports", produces = MediaType.APPLICATION_XML_VALUE)
    public String reportSitemap() {
        return buildUrlset(editorialReportRepository.findAllPublishedIds(), BASE + "report/", "weekly", "0.8");
    }

    private String buildUrlset(List<Long> ids, String baseUrl, String changefreq, String priority) {
        StringBuilder sb = new StringBuilder(ids.size() * 120);
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");
        for (Long id : ids) {
            sb.append("  <url><loc>").append(baseUrl).append(id)
              .append("</loc><changefreq>").append(changefreq)
              .append("</changefreq><priority>").append(priority).append("</priority></url>\n");
        }
        sb.append("</urlset>");
        return sb.toString();
    }
}
