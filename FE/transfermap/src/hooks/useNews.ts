import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchNews } from '../api/news';
import { ApiError } from '../api/client';
import { NEWS } from '../data/mock';
import type { NewsItem } from '../types';

export function useNews() {
  const navigate = useNavigate();
  const [items,   setItems]   = useState<NewsItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetchNews()
      .then(data => setItems(data.length > 0 ? data : NEWS))
      .catch(err => {
        if (err instanceof ApiError && err.status >= 500) {
          navigate('/500');
        } else {
          setItems(NEWS); // 4xx 또는 네트워크 오류 → mock fallback
        }
      })
      .finally(() => setLoading(false));
  }, [navigate]);

  return { items, loading };
}
