% converts unix time to matlab's datenum format

function datenums=unix_time_to_datenum(unixtimes);
datenums = unixtimes/86400 + 719529;

