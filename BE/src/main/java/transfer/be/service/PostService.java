package transfer.be.service;

import transfer.be.model.Journalist;
import transfer.be.model.Post;

import java.util.List;

public interface PostService {

    List<Post> findByJournalist(Journalist journalist);

    /**
     * 기자의 X 게시물을 수집해 저장.
     * since_id 기준으로 신규 게시물만 가져옴.
     *
     * @return 새로 저장된 Post 목록
     */
    List<Post> collectAndSave(Journalist journalist);
}