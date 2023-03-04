    select r.allreserveamount,
           r.yearreserveamount,
           p.payamount,
           r.maxpaydate
      from (select NVL(SUM(c.rate * dl.amount / c.base), 0) payamount
              from rnbdoclink dl, currencyrateall c
             where dl.rnbissueid = 115
               and dl.currencyid = c.currencyid
               and dl.documentdate = c.arcdate) p,
           (select NVL(sum(c.rate * t.amount / c.base), 0) allreserveamount,
                   NVL(sum(CASE
                             WHEN TRUNC(t.paydate, 'Y') = TRUNC(date'2022-12-26', 'Y') THEN
                              c.rate * t.amount / c.base
                             ELSE
                              0
                           END),
                       0) yearreserveamount,
                   MAX(t.paydate) maxpaydate
              from rnbissue i, rnbpaymentschedule t, currencyrateall c
             where i.id = 115
               and i.id = t.rnbissueid
               and ((TRUNC(t.paydate, 'MM') < date'2022-12-26') AND
                   (NVL(0, 0) = 1) OR (NVL(0, 0) = 0))
               and t.valuedate = c.arcdate
               and i.currencyid = c.currencyid) r