select distinct bn.cd_ref, t.famille, t.ordre, t.classe, t.phylum, t.regne 
from taxonomie.bib_noms bn
left join taxonomie.taxref t on t.cd_ref = bn.cd_ref
where bn.cd_ref <> 159572
;
