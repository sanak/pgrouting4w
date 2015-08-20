create or replace function pgr_trsp(sql text, vids integer[], directed boolean, has_reverse_cost boolean, turn_restrict_sql text DEFAULT NULL::text)
    RETURNS SETOF pgr_costresult3 AS
$body$
/*
 *  pgr_trsp(sql text, vids integer[], directed boolean, has_reverse_cost boolean, turn_restrict_sql text DEFAULT NULL::text)
 *
 *  Compute TRSP with via points. We compute the path between vids[i] and vids[i+1] and chain the results together.
 *
 *  NOTE: this is a prototype function, we can gain a lot of efficiencies by implementing this in C/C++
 *
*/
declare
    i integer;
    rr record;
    seq integer := 0;
    res pgr_costresult3;

begin
    -- loop through each pair of vids and compute the path
    for i in 1 .. array_length(vids, 1)-1 loop
        for rr in select * from pgr_trsp(sql, vids[i], vids[i+1], directed, has_reverse_cost, turn_restrict_sql) loop
            res.seq := seq;
            res.id1 := i - 1;
            res.id2 := rr.id1;
            res.id3 := rr.id2;
            res.cost := rr.cost;
            seq := seq + 1;
            return next res;
        end loop;
    end loop;

    return;
end;
$body$
    language plpgsql stable
    cost 100
    rows 1000;




----------------------------------------------------------------------------------------------------------

create or replace function pgr_trsp(sql text, eids integer[], pcts float8[], directed boolean, has_reverse_cost boolean, turn_restrict_sql text DEFAULT NULL::text)
    RETURNS SETOF pgr_costresult3 AS
$body$
/*
 *  pgr_trsp(sql text, eids integer[], pcts float8[], directed boolean, has_reverse_cost boolean, turn_restrict_sql text DEFAULT NULL::text)
 *
 *  Compute TRSP with edge_ids and pposition along edge. We compute the path between eids[i], pcts[i] and eids[i+1], pcts[i+1]
 *  and chain the results together.
 *
 *  NOTE: this is a prototype function, we can gain a lot of efficiencies by implementing this in C/C++
 *
*/
declare
    i integer;
    rr record;
    seq integer := 0;
    res pgr_costresult3;

begin
    if array_length(eids, 1) != array_length(pcts, 1) then
        raise exception 'The length of arrays eids and pcts must be the same!';
    end if;

    -- loop through each pair of vids and compute the path
    for i in 1 .. array_length(eids, 1)-1 loop
        for rr in select * from pgr_trsp(sql, eids[i], pcts[i], eids[i+1], pcts[i+1], directed, has_reverse_cost, turn_restrict_sql) loop
            res.seq := seq;
            res.id1 := i - 1;
            res.id2 := rr.id1;
            res.id3 := rr.id2;
            res.cost := rr.cost;
            seq := seq + 1;
            return next res;
        end loop;
    end loop;
    
    return;
end;
$body$
    language plpgsql stable
    cost 100
    rows 1000;


