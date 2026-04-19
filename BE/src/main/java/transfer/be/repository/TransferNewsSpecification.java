package transfer.be.repository;

import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Subquery;
import org.springframework.data.jpa.domain.Specification;
import transfer.be.dto.request.TransferNewsSearchCondition;
import transfer.be.model.TransferNews;
import transfer.be.model.Verification;

import java.util.ArrayList;
import java.util.List;

public class TransferNewsSpecification {

    public static Specification<TransferNews> from(TransferNewsSearchCondition c) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (c.status() != null)
                predicates.add(cb.equal(root.get("status"), c.status()));

            if (c.season() != null)
                predicates.add(cb.equal(root.get("season"), c.season()));

            if (c.window() != null)
                predicates.add(cb.equal(root.get("window"), c.window()));

            if (c.toClubId() != null)
                predicates.add(cb.equal(root.get("toClub").get("id"), c.toClubId()));

            if (c.fromClubId() != null)
                predicates.add(cb.equal(root.get("fromClub").get("id"), c.fromClubId()));

            if (c.leagueId() != null)
                predicates.add(cb.equal(root.get("toClub").get("league").get("id"), c.leagueId()));

            if (c.journalistId() != null)
                predicates.add(cb.equal(root.get("post").get("journalist").get("id"), c.journalistId()));

            if (c.minCredibility() != null)
                predicates.add(cb.greaterThanOrEqualTo(
                        root.get("post").get("journalist").get("credibilityScore"), c.minCredibility()));

            if (c.position() != null)
                predicates.add(cb.equal(root.get("player").get("position"), c.position()));

            if (c.nationality() != null)
                predicates.add(cb.equal(root.get("player").get("nationality"), c.nationality()));

            if (c.minFeeEur() != null)
                predicates.add(cb.greaterThanOrEqualTo(root.get("feeEur"), c.minFeeEur()));

            if (c.maxFeeEur() != null)
                predicates.add(cb.lessThanOrEqualTo(root.get("feeEur"), c.maxFeeEur()));

            if (c.minReliability() != null)
                predicates.add(cb.greaterThanOrEqualTo(root.get("reliability"), c.minReliability()));

            if (c.from() != null)
                predicates.add(cb.greaterThanOrEqualTo(root.get("publishedAt"), c.from().atStartOfDay()));

            if (c.to() != null)
                predicates.add(cb.lessThanOrEqualTo(root.get("publishedAt"), c.to().atTime(23, 59, 59)));

            if (Boolean.TRUE.equals(c.verified())) {
                Subquery<Integer> sub = query.subquery(Integer.class);
                Root<Verification> v = sub.from(Verification.class);
                sub.select(cb.literal(1))
                        .where(cb.and(
                                cb.equal(v.get("transferNews"), root),
                                cb.isTrue(v.get("isConfirmed"))
                        ));
                predicates.add(cb.exists(sub));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
