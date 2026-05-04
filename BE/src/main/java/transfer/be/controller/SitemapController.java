package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.repository.PlayerRepository;

import java.util.List;

@RestController
@RequestMapping("/api/sitemap-players")
@RequiredArgsConstructor
public class SitemapController {

    private static final String BASE_URL = "https://transfer-map.com/players/";

    private final PlayerRepository playerRepository;

    @GetMapping(produces = MediaType.APPLICATION_XML_VALUE)
    public String playerSitemap() {
        List<Long> ids = playerRepository.findAllIds();
        StringBuilder sb = new StringBuilder(ids.size() * 120);
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");
        for (Long id : ids) {
            sb.append("  <url><loc>").append(BASE_URL).append(id)
              .append("</loc><changefreq>monthly</changefreq><priority>0.7</priority></url>\n");
        }
        sb.append("</urlset>");
        return sb.toString();
    }
}
