-- Remove phantom games: those that have a __meta row but no actual score rows.
-- (Earlier app versions auto-created these on load. Safe to run anytime.)
delete from public.scores s
where s.player = '__meta'
  and not exists (
    select 1 from public.scores x
    where x.game_id = s.game_id
      and x.player in ('gav','phil')
      and x.strokes is not null
  );
