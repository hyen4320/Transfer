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
      .then(data => setClubs(data.length > 0 ? data : CLUBS))
      .catch(() => setClubs(CLUBS))
      .finally(() => setLoading(false));
  }, [season]);

  return { clubs, loading };
}
