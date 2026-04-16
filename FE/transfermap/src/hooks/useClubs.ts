import { useState, useEffect } from 'react';
import { fetchAllClubs } from '../api/clubs';
import { CLUBS } from '../data/mock';
import type { Club } from '../types';

export function useClubs() {
  const [clubs,   setClubs]   = useState<Club[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAllClubs()
      .then(data => setClubs(data.length > 0 ? data : CLUBS))
      .catch(() => setClubs(CLUBS))
      .finally(() => setLoading(false));
  }, []);

  return { clubs, loading };
}
