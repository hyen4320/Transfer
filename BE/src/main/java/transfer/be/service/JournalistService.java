package transfer.be.service;

import transfer.be.model.Journalist;

import java.util.List;

public interface JournalistService {

    List<Journalist> findAllByRank();

    Journalist findById(Long id);

    /** X 계정명으로 조회, 없으면 X API에서 정보를 가져와 등록 */
    Journalist findOrRegisterByXHandle(String xHandle);

    /** X API에서 사용자 정보를 조회해 DB에 저장 */
    Journalist registerFromX(String xHandle);

    /** xUserId가 없는 기자들을 X API로 채움 */
    void syncMissingXUserIds();

    /** 공신력 점수 갱신 후 전체 순위 재계산 */
    void updateCredibilityScore(Long journalistId, float newScore);
}