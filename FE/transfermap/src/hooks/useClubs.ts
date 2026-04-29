import { useState, useEffect } from 'react';
import { fetchClubsBySeason } from '../api/clubs';
import { CLUBS } from '../data/mock';
import type { Club } from '../types';

export function useClubs(season: number = 51) {
  const [clubs,   setClubs]   = useState<Club[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetchClubsBySeason(season)
      .then(data => {
        if (data.length > 0) return data;
        // 현재 시즌 데이터 없으면 이전 시즌 시도
        return fetchClubsBySeason(season - 2);
      })
      .then(data => setClubs(data.length > 0 ? data : CLUBS))
      .catch(() => setClubs(CLUBS))
      .finally(() => setLoading(false));
  }, [season]);

  return { clubs, loading };
}
