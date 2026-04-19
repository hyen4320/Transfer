import type { Topology, GeometryCollection } from 'topojson-specification';

export type WorldTopology = Topology<{ countries: GeometryCollection }>;

let _cache: Promise<WorldTopology> | null = null;

export function loadWorldAtlas(): Promise<WorldTopology> {
  if (!_cache) {
    _cache = fetch('https://cdn.jsdelivr.net/npm/world-atlas@2/countries-50m.json')
      .then(r => r.json())
      .catch(err => { _cache = null; throw err; });
  }
  return _cache;
}
