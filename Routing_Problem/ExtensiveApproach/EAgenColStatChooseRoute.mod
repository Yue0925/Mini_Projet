/*********************************************
 * OPL 12.10.0.0 Model
 * Author: yue
 * Creation Date: Jan 4, 2022 at 7:37:00 PM
 *********************************************/

// Choosing the routes in genColStat's Problem (EAgenColStatchooseRoute.mod) .
include "EAgenColStatComm.mod";

execute {
   writeln("Choose route");
}

// variable
dvar int truck[Routes] in 0..1; // truck[r]=1, if a truck run the route r

// objective
minimize
   sum(r in Routes) truck[r]; // min the number of trucks used


// constraint
subject to {
  // each client i is delivered exactly once
   forall(i in Customers)
     deliveryCt: sum(r in Routes) r.deliver[i] * truck[r] == 1;
 };

// post-processing
 execute {
   writeln("Chosen : ");
   for (var r in Routes)
   	if (truck[r]>0)
     writeln(r, " is taken !");
}

