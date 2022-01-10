/*********************************************
 * OPL 12.10.0.0 Model
 * Author: yue
 * Creation Date: Jan 9, 2022 at 7:04:08 PM
 *********************************************/

int NumCustomers = ...;

range Clients = 1..NumCustomers;

int Capacity = ...;

int demand[Clients] = ...;

float Duals[Clients] = ...;


// generate a new route with most negative coût réduit

// variable
dvar int Deliver[Clients] in 0..1;

// objective : min coût réduit ?
minimize
  1 - sum(i in Clients) Duals[i] * Deliver[i];
 
// constraint
subject to {
  ctCapacity: // a vaild route
    sum(i in Clients) demand[i] * Deliver[i] <= Capacity;
}
