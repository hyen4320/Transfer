package transfer.be.service;

import transfer.be.dto.response.FixtureItem;

import java.util.List;

public interface FixtureStorageService {

    /** 종료된 경기면 DB에 저장 (이미 저장된 경기 스킵) */
    void storeIfFinished(FixtureItem item);

    /** 특정 리그의 특정 날짜 경기를 일괄 저장 */
    void storeDateFixtures(String leagueId, String date);

    /** 지원하는 전체 리그의 특정 날짜 경기를 일괄 저장 */
    void storeAllLeaguesDate(String date);
}
