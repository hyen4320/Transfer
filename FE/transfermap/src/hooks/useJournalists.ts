import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchJournalists } from '../api/journalists';
import { ApiError } from '../api/client';
import { JOURNALISTS } from '../data/mock';
import type { Journalist } from '../types';

export function useJournalists() {
  const navigate = useNavigate();
  const [items,   setItems]   = useState<Journalist[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetchJournalists()
      .then(data => setItems(data.length > 0 ? data : JOURNALISTS))
      .catch(err => {
        if (err instanceof ApiError && err.status >= 500) {
          navigate('/500');
        } else {
          setItems(JOURNALISTS);
        }
      })
      .finally(() => setLoading(false));
  }, [navigate]);

  return { items, loading };
}
