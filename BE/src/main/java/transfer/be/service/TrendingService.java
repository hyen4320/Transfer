package transfer.be.service;

import java.util.List;

public interface TrendingService {
    List<String> getTrendingPlayers(int days, int limit);
    void recordSearch(String playerName);
}
