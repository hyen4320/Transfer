import type { League, Club, NewsItem, Journalist, Player, TransferHistory, ClubTransfers } from '../types';

export const LEAGUES: League[] = [
  { id:'pl', name:'Premier League', lon:-1.5,  lat:52.5, color:'#38003c', accent:'#00ff85', abbr:'PL',
    country:'England', flag:'🏴󠁧󠁢󠁥󠁮󠁧󠁿', numericId:826, center:[-2,53.5],   scale:2800, clubs:20, transfers:38, news:142 },
  { id:'ll', name:'La Liga',        lon:-3.7,  lat:40.4, color:'#ee8707', accent:'#c8102e', abbr:'LL',
    country:'Spain',   flag:'🇪🇸',       numericId:724, center:[-3.5,40],  scale:2200, clubs:20, transfers:29, news:98  },
  { id:'bl', name:'Bundesliga',     lon:10.4,  lat:51.2, color:'#d20515', accent:'#ffcd00', abbr:'BL',
    country:'Germany', flag:'🇩🇪',       numericId:276, center:[10.5,51.5], scale:2600, clubs:18, transfers:31, news:87  },
  { id:'sa', name:'Serie A',        lon:12.5,  lat:43.0, color:'#1a1b5e', accent:'#008fd7', abbr:'SA',
    country:'Italy',   flag:'🇮🇹',       numericId:380, center:[12.5,42.5], scale:2400, clubs:20, transfers:27, news:76  },
  { id:'l1', name:'Ligue 1',        lon: 2.3,  lat:46.6, color:'#091c3e', accent:'#dba514', abbr:'L1',
    country:'France',  flag:'🇫🇷',       numericId:250, center:[2.5,46.5],  scale:2200, clubs:18, transfers:22, news:61  },
];

export const CLUBS: Club[] = [
  { id:1,  name:'Arsenal',       lon:-0.11, lat:51.55, league:'pl', color:'#ef0107', emoji:'🔴' },
  { id:2,  name:'Man City',      lon:-2.20, lat:53.48, league:'pl', color:'#6cabdd', emoji:'🔵' },
  { id:3,  name:'Real Madrid',   lon:-3.69, lat:40.45, league:'ll', color:'#febe10', emoji:'⚪' },
  { id:4,  name:'Barcelona',     lon: 2.12, lat:41.38, league:'ll', color:'#004d98', emoji:'🔵' },
  { id:5,  name:'Bayern Munich', lon:11.62, lat:48.22, league:'bl', color:'#dc052d', emoji:'🔴' },
  { id:6,  name:'Dortmund',      lon: 7.45, lat:51.49, league:'bl', color:'#fde100', emoji:'🟡' },
  { id:7,  name:'Juventus',      lon: 7.64, lat:45.11, league:'sa', color:'#000000', emoji:'⚫' },
  { id:8,  name:'AC Milan',      lon: 9.12, lat:45.48, league:'sa', color:'#fb090b', emoji:'🔴' },
  { id:9,  name:'PSG',           lon: 2.25, lat:48.84, league:'l1', color:'#004170', emoji:'🔵' },
  { id:10, name:'Marseille',     lon: 5.39, lat:43.27, league:'l1', color:'#2faee0', emoji:'🔵' },
];

export const JOURNALISTS: Journalist[] = [
  { id:1, name:'Fabrizio Romano',     handle:'@FabrizioRomano', followers:'24.0M', score:98.5, speed:92, accuracy:99, impact:97,
    bio:'The most followed football transfer journalist in the world. Known for the iconic "Here We Go" phrase.',
    country:'🇮🇹 Italy', outlet:'The Guardian / Sky Sport' },
  { id:2, name:'David Ornstein',      handle:'@David_Ornstein', followers:'2.1M',  score:94.1, speed:88, accuracy:96, impact:85,
    bio:'Senior football correspondent at The Athletic, specialising in the Premier League.',
    country:'🇬🇧 England', outlet:'The Athletic' },
  { id:3, name:'Gianluca Di Marzio',  handle:'@DiMarzio',       followers:'1.8M',  score:91.0, speed:85, accuracy:93, impact:80,
    bio:'Sky Sport Italia journalist with decades of experience in Serie A transfers.',
    country:'🇮🇹 Italy', outlet:'Sky Sport Italia' },
  { id:4, name:'Ben Jacobs',          handle:'@JacobsBen',      followers:'890K',  score:87.3, speed:82, accuracy:89, impact:77,
    bio:'CBS Sports journalist covering Premier League and international transfers.',
    country:'🇬🇧 England', outlet:'CBS Sports' },
  { id:5, name:'Florian Plettenberg', handle:'@Plettigoal',     followers:'750K',  score:84.6, speed:80, accuracy:86, impact:74,
    bio:'Sky Sport Germany reporter specialising in Bundesliga transfers.',
    country:'🇩🇪 Germany', outlet:'Sky Sport Germany' },
];

export const PLAYERS: Player[] = [
  { id:1, name:'Kylian Mbappé',        nationality:'France',  flag:'🇫🇷', position:'FW', currentClub:'Real Madrid', currentLeague:'La Liga',     contractUntil:'2029', age:26, marketValue:'€200M', emoji:'⚡' },
  { id:2, name:'Jamal Musiala',         nationality:'Germany', flag:'🇩🇪', position:'MF', currentClub:'Bayern Munich',currentLeague:'Bundesliga',  contractUntil:'2026', age:21, marketValue:'€150M', emoji:'🌟' },
  { id:3, name:'Pedri',                 nationality:'Spain',   flag:'🇪🇸', position:'MF', currentClub:'Barcelona',   currentLeague:'La Liga',     contractUntil:'2026', age:22, marketValue:'€100M', emoji:'🎯' },
  { id:4, name:'Erling Haaland',        nationality:'Norway',  flag:'🇳🇴', position:'FW', currentClub:'Man City',    currentLeague:'Premier League', contractUntil:'2034', age:24, marketValue:'€180M', emoji:'💪' },
  { id:5, name:'Gianluigi Donnarumma',  nationality:'Italy',   flag:'🇮🇹', position:'GK', currentClub:'Juventus',    currentLeague:'Serie A',     contractUntil:'2026', age:26, marketValue:'€50M',  emoji:'🧤' },
];

export const PLAYER_HISTORY: Record<number, TransferHistory[]> = {
  1: [
    { year:'2017', from:'Monaco',    to:'PSG',        fee:'€180M', status:'confirmed' },
    { year:'2022', from:'PSG',       to:'PSG',        fee:'Contract Extension', status:'confirmed' },
    { year:'2024', from:'PSG',       to:'Real Madrid',fee:'Free',  status:'confirmed' },
  ],
  2: [
    { year:'2021', from:'Stuttgart', to:'Bayern Munich', fee:'€11M', status:'confirmed' },
    { year:'2023', from:'Bayern Munich', to:'Bayern Munich', fee:'Contract Extension', status:'confirmed' },
  ],
  4: [
    { year:'2019', from:'Molde',     to:'RB Salzburg', fee:'€8M',   status:'confirmed' },
    { year:'2020', from:'RB Salzburg',to:'Dortmund',   fee:'€20M',  status:'confirmed' },
    { year:'2022', from:'Dortmund',  to:'Man City',    fee:'€60M',  status:'confirmed' },
  ],
};

export const NEWS: NewsItem[] = [
  { id:1, player:'Kylian Mbappé',        playerId:1, from:'PSG',       to:'Real Madrid', fee:'€180M',  status:'confirmed', journalist:'Fabrizio Romano',    journalistId:1, handle:'@FabrizioRomano', credibility:98.5, time:'2h ago' },
  { id:2, player:'Jamal Musiala',         playerId:2, from:'Bayern',    to:'Man City',    fee:'€120M',  status:'rumour',    journalist:'David Ornstein',     journalistId:2, handle:'@David_Ornstein', credibility:94.1, time:'4h ago' },
  { id:3, player:'Pedri',                 playerId:3, from:'Barcelona', to:'Arsenal',     fee:'€90M',   status:'rumour',    journalist:'Fabrizio Romano',    journalistId:1, handle:'@FabrizioRomano', credibility:98.5, time:'6h ago' },
  { id:4, player:'Gianluigi Donnarumma',  playerId:5, from:'PSG',       to:'Juventus',    fee:'Free',   status:'confirmed', journalist:'Gianluca Di Marzio', journalistId:3, handle:'@DiMarzio',       credibility:91.0, time:'8h ago' },
  { id:5, player:'Erling Haaland',        playerId:4, from:'Man City',  to:'Real Madrid', fee:'€200M',  status:'denied',    journalist:'Fabrizio Romano',    journalistId:1, handle:'@FabrizioRomano', credibility:98.5, time:'12h ago' },
  { id:6, player:'Florian Wirtz',                    from:'Dortmund',  to:'Liverpool',   fee:'€110M',  status:'rumour',    journalist:'David Ornstein',     journalistId:2, handle:'@David_Ornstein', credibility:94.1, time:'1d ago' },
];

export const CLUB_TRANSFERS: Record<number, ClubTransfers> = {
  3: {
    in:  [{ player:'Kylian Mbappé',    from:'PSG',       fee:'€180M', status:'confirmed' }],
    out: [{ player:'Karim Benzema',    to:'Al-Ittihad',  fee:'Free',  status:'confirmed' }],
  },
  9: {
    in:  [{ player:'Ousmane Dembélé',  from:'Barcelona', fee:'€50M',  status:'confirmed' }],
    out: [{ player:'Kylian Mbappé',    to:'Real Madrid', fee:'€180M', status:'confirmed' },
          { player:'Donnarumma',       to:'Juventus',    fee:'Free',  status:'confirmed' }],
  },
};
