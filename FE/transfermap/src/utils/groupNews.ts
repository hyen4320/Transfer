import type { NewsItem, GroupedNewsItem } from '../types';

export function groupNewsByTransfer(items: NewsItem[]): GroupedNewsItem[] {
  const map = new Map<string, NewsItem[]>();

  for (const item of items) {
    const key = `${item.player}|${item.to}|${item.status}`;
    if (!map.has(key)) map.set(key, []);
    map.get(key)!.push(item);
  }

  return Array.from(map.values()).map(group => {
    const sorted = [...group].sort((a, b) =>
      new Date(a.publishedAt).getTime() - new Date(b.publishedAt).getTime()
    );
    return {
      lead: sorted[0],
      reporters: sorted.map(n => ({
        name:        n.journalist,
        handle:      n.handle,
        credibility: n.credibility,
        sourceUrl:   n.sourceUrl,
        time:        n.time,
      })),
    };
  });
}
