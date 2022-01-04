/*********************************************
 * OPL 12.10.0.0 Model
 * Author: yue
 * Creation Date: Jan 4, 2022 at 6:37:06 PM
 *********************************************/
 
// Generating the Routes (EAgenColStatGenRoute.mod) .
using CP;
include "EAgenColStatComm.mod";

execute {
      writeln("Generation de configuration");
}

// variable
dvar int deliver[Customers] in 0..1; // deliver[i]=1, deliver for client i in the current route

// constraint
subject to {
	// at least one client is delivered ib a route
	 1 <= sum(i in Customers) deliver[i];
	
	// capacity constraint
	sum(i in Customers) deliver[i]*demand[i] <= Capacity;

};


int newId = card(Routes)+1;

execute {
     writeln( "route : ", deliver.solutionValue, ">");
}
