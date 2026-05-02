import { useState, useEffect, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchNews } from '../api/news';
import { ApiError } from '../api/client';
import { getTransferWindowState } from '../utils/transferWindow';
import type { NewsItem } from '../types';

const PAGE_SIZE = 30;
const { season: CURRENT_SEASON, isOpen: WINDOW_IS_OPEN } = getTransferWindowState();

export function useNewsInfinite(season: number = CURRENT_SEASON, skip = false) {
  const navigate = useNavigate();
  const [items, setItems] = useState<NewsItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const pageRef = useRef(0);
  const isPast = season < CURRENT_SEASON || (season === CURRENT_SEASON && !WINDOW_IS_OPEN);

  const fetchPage = useCallback(async (page: number, reset: boolean, signal?: AbortSignal) => {
    if (skip) return;
    if (reset) setLoading(true);
    else setLoadingMore(true);
    let aborted = false;
    try {
      const data = await fetchNews({
        season,
        size: PAGE_SIZE,
        page,
        sort: isPast ? 'feeEur,desc' : 'publishedAt,desc',
        ...(isPast && { minFeeEur: 1 }),
      }, signal);
      setItems(prev => {
        if (reset) return data;
        const seen = new Set(prev.map(n => n.id));
        return [...prev, ...data.filter(n => !seen.has(n.id))];
      });
      setHasMore(data.length === PAGE_SIZE);
      pageRef.current = page;
    } catch (err) {
      if (err instanceof Error && err.name === 'AbortError') { aborted = true; return; }
      if (err instanceof ApiError && err.status >= 500) navigate('/500');
    } finally {
      if (!aborted) {
        if (reset) setLoading(false);
        else setLoadingMore(false);
      }
    }
  }, [season, isPast, navigate]);

  useEffect(() => {
    const controller = new AbortController();
    pageRef.current = 0;
    setHasMore(true);
    fetchPage(0, true, controller.signal);
    return () => controller.abort();
  }, [fetchPage]);

  const loadMore = useCallback(() => {
    if (skip || loadingMore || !hasMore) return;
    fetchPage(pageRef.current + 1, false);
  }, [skip, loadingMore, hasMore, fetchPage]);

  if (skip) return { items: [] as NewsItem[], loading: false, loadingMore: false, hasMore: false, loadMore: () => {} };
  return { items, loading, loadingMore, hasMore, loadMore };
}
