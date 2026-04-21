package transfer.be.service;

import transfer.be.model.Post;

import java.util.List;

public interface PostParsingService {
    void parseAndSave(List<Post> posts);
}
