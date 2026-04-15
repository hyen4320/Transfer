package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.response.JournalistResponse;
import transfer.be.dto.response.TransferNewsResponse;
import transfer.be.model.Journalist;
import transfer.be.service.JournalistService;
import transfer.be.service.TransferNewsService;

import java.util.List;

@RestController
@RequestMapping("/api/journalists")
@RequiredArgsConstructor
public class JournalistController {

    private final JournalistService journalistService;
    private final TransferNewsService transferNewsService;

    /** 기자 전체 목록 (공신력 순, Redis TTL 30분 캐시) */
    @GetMapping
    public List<JournalistResponse> getAll() {
        return journalistService.findAllByRank().stream()
                .map(JournalistResponse::from)
                .toList();
    }

    /** 기자 상세 */
    @GetMapping("/{id}")
    public JournalistResponse getById(@PathVariable Long id) {
        return JournalistResponse.from(journalistService.findById(id));
    }

    /** 기자가 최초 보도한 이적 뉴스 목록 */
    @GetMapping("/{id}/news")
    public List<TransferNewsResponse> getNews(@PathVariable Long id) {
        Journalist journalist = journalistService.findById(id);
        return transferNewsService.findByJournalist(journalist).stream()
                .map(TransferNewsResponse::from)
                .toList();
    }
}
