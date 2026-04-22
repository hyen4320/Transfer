package transfer.be.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import transfer.be.dto.response.NoticeResponse;
import transfer.be.repository.NoticeRepository;

import java.util.List;

@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
public class NoticeController {

    private final NoticeRepository noticeRepository;

    @GetMapping
    public List<NoticeResponse> getAll() {
        return noticeRepository.findAllByOrderByPublishedAtDesc()
                .stream()
                .map(NoticeResponse::from)
                .toList();
    }
}
