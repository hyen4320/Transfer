import { useState, useEffect, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchNews } from '../api/news';
import { ApiError } from '../api/client';
import type { NewsItem } from '../types';

const PAGE_SIZE = 30;

export function useNewsInfinite(season: number = 51) {
  const navigate = useNavigate();
  const [items, setItems] = useState<NewsItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const pageRef = useRef(0);
  const isPast = season !== 51;

  const fetchPage = useCallback(async (page: number, reset: boolean) => {
    if (reset) setLoading(true);
    else setLoadingMore(true);
    try {
      const data = await fetchNews({
        season,
        size: PAGE_SIZE,
        page,
        sort: isPast ? 'feeEur,desc' : 'publishedAt,desc',
        ...(isPast && { minFeeEur: 1 }),
      });
      setItems(prev => reset ? data : [...prev, ...data]);
      setHasMore(data.length === PAGE_SIZE);
      pageRef.current = page;
    } catch (err) {
      if (err instanceof ApiError && err.status >= 500) navigate('/500');
    } finally {
      if (reset) setLoading(false);
      else setLoadingMore(false);
    }
  }, [season, isPast, navigate]);

  useEffect(() => {
    pageRef.current = 0;
    setHasMore(true);
    fetchPage(0, true);
  }, [fetchPage]);

  const loadMore = useCallback(() => {
    if (loadingMore || !hasMore) return;
    fetchPage(pageRef.current + 1, false);
  }, [loadingMore, hasMore, fetchPage]);

  return { items, loading, loadingMore, hasMore, loadMore };
}
