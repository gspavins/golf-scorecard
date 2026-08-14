-- Add contact details (phone/email/proshop) from the app course list.
-- coalesce = fills only empty fields. Safe to re-run.
alter table public.courses add column if not exists phone text;
alter table public.courses add column if not exists email text;
alter table public.courses add column if not exists proshop text;

update public.courses set phone=coalesce(nullif(phone,''),'011 300 5700'), email=coalesce(nullif(email,''),'rommel@golf.co.nz'), proshop=coalesce(nullif(proshop,''),'0113005713') where id='c1';
update public.courses set phone=coalesce(nullif(phone,''),'011 706 1361'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c2';
update public.courses set phone=coalesce(nullif(phone,''),'011-472-8060'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c3';
update public.courses set phone=coalesce(nullif(phone,''),'011 202 1603'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c4';
update public.courses set phone=coalesce(nullif(phone,''),'011 875 0401'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c6';
update public.courses set phone=coalesce(nullif(phone,''),'011 801 6600'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c8';
update public.courses set phone=coalesce(nullif(phone,''),'087 285 3557'), email=coalesce(nullif(email,''),'golfdirector@ebotselinks.com'), proshop=coalesce(nullif(proshop,''),null) where id='c9';
update public.courses set phone=coalesce(nullif(phone,''),'0161009230 / 0169323370'), email=coalesce(nullif(email,''),'ecc@emfulenigolfestate.com'), proshop=coalesce(nullif(proshop,''),null) where id='c10';
update public.courses set phone=coalesce(nullif(phone,''),'011 453 1013'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c12';
update public.courses set phone=coalesce(nullif(phone,''),'0114323150'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c13';
update public.courses set phone=coalesce(nullif(phone,''),'0117287337'), email=coalesce(nullif(email,''),'reception@houghton.co.za'), proshop=coalesce(nullif(proshop,''),null) where id='c14';
update public.courses set phone=coalesce(nullif(phone,''),'010 880 3999'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c16';
update public.courses set phone=coalesce(nullif(phone,''),'011 442 7411'), email=coalesce(nullif(email,''),'golf@killarneycc.co.za'), proshop=coalesce(nullif(proshop,''),null) where id='c17';
update public.courses set phone=coalesce(nullif(phone,''),'(011)660 4365'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c18';
update public.courses set phone=coalesce(nullif(phone,''),'010 5940034'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c19';
update public.courses set phone=coalesce(nullif(phone,''),'0164213196'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),'0164221263') where id='c21';
update public.courses set phone=coalesce(nullif(phone,''),'016 362 0809'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c22';
update public.courses set phone=coalesce(nullif(phone,''),'011 6082033/4'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c23';
update public.courses set phone=coalesce(nullif(phone,''),'0608818570'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c24';
update public.courses set phone=coalesce(nullif(phone,''),'011 646-5400'), email=coalesce(nullif(email,''),'info@parkviewgolf.co.za'), proshop=coalesce(nullif(proshop,''),null) where id='c25';
update public.courses set phone=coalesce(nullif(phone,''),'011 215 8600'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c27';
update public.courses set phone=coalesce(nullif(phone,''),'011 907 8906'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c28';
update public.courses set phone=coalesce(nullif(phone,''),'(016) 100 5027'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c29';
update public.courses set phone=coalesce(nullif(phone,''),'011 958 1905'), email=coalesce(nullif(email,''),'ceo@ruimsigCC.co.za'), proshop=coalesce(nullif(proshop,''),null) where id='c30';
update public.courses set phone=coalesce(nullif(phone,''),'011 640 3021'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c31';
update public.courses set phone=coalesce(nullif(phone,''),'011 943 4448 / 9 011 943 6064'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c32';
update public.courses set phone=coalesce(nullif(phone,''),'0105944010'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c33';
update public.courses set phone=coalesce(nullif(phone,''),'011 783 1166/67'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c34';
update public.courses set phone=coalesce(nullif(phone,''),'011 447 3311'), email=coalesce(nullif(email,''),'membership@wanderersgolfclub.com'), proshop=coalesce(nullif(proshop,''),null) where id='c35';
update public.courses set phone=coalesce(nullif(phone,''),'010 5000 300'), email=coalesce(nullif(email,''),'events@eyeofafrica.co.za'), proshop=coalesce(nullif(proshop,''),null) where id='c37';
update public.courses set phone=coalesce(nullif(phone,''),'011 9707000'), email=coalesce(nullif(email,''),'info@aviongolf.co.za'), proshop=coalesce(nullif(proshop,''),null) where id='c39';
update public.courses set phone=coalesce(nullif(phone,''),'011 8495211'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c41';
update public.courses set phone=coalesce(nullif(phone,''),'011 421 1341'), email=coalesce(nullif(email,''),null), proshop=coalesce(nullif(proshop,''),null) where id='c42';
