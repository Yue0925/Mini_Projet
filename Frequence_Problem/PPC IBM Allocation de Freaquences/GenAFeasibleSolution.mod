/*********************************************
 * OPL 12.10.0.0 Model
 * Author: natal
 * Creation Date: 07-01-2022 at 22:09:59
 *********************************************/
using CP;
 
 int T = ...;
 int ch= ...;
 
 range emet = 1..T;
 range chan = 1..ch;

 int offset [i in emet][j in emet]=...;
 
 
 // variables
 dvar int x[t in emet] in chan; // the frequency allocated to each transmetter
 dvar int maxF in chan; // the maximum frequency appeared in the solution
 
  
 subject to{
	// transmetter odd/even allocated with frequency odd/even
    forall (t in emet)
      x[t]%2 == t%2;

	// constraint proximity
 	forall (i, j in emet : offset[i][j]!=0)  	
 		abs(x[i]-x[j]) >= offset[i][j];

	// memorize the maximum frequency used 
	maxF == max(t in emet) x[t]; 
 }