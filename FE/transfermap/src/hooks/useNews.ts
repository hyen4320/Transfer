import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchNews } from '../api/news';
import { ApiError } from '../api/client';
import { NEWS } from '../data/mock';
import type { NewsItem } from '../types';

// WorldMap 전용 — SidePanel 무한스크롤은 useNewsInfinite 사용
export function useNews(season: number = 51) {
  const navigate = useNavigate();
  const [items,   setItems]   = useState<NewsItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    const isPast = season !== 51;
    fetchNews({
      season,
      size: 30,
      sort: isPast ? 'feeEur,desc' : 'publishedAt,desc',
      ...(isPast && { minFeeEur: 1 }),
    })
      .then(data => setItems(data.length > 0 ? data : NEWS))
      .catch(err => {
        if (err instanceof ApiError && err.status >= 500) {
          navigate('/500');
        } else {
          setItems(NEWS);
        }
      })
      .finally(() => setLoading(false));
  }, [navigate, season]);

  return { items, loading };
}
