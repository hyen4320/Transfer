package transfer.be.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import transfer.be.model.Club;
import transfer.be.model.ClubAlias;

import java.util.Optional;

public interface ClubAliasRepository extends JpaRepository<ClubAlias, Long> {

    @Query("select a from ClubAlias a join fetch a.club where lower(a.alias) = lower(:alias)")
    Optional<ClubAlias> findByAliasIgnoreCase(String alias);
}
