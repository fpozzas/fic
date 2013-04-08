#include <pvm3.h>
#include <stdio.h>
#include <string.h>

double montecarlo(int N){
	double aproxpi;
	return aproxpi;
};

int main(int argc, char argv[])
{
	int ptid, info, N;
	double aproxpi;
	
	ptid = pvm_parent();
	
	N = strtol(argv[1],(char**)NULL,10);
	
	aproxpi = montecarlo(N);
	
	info = pvm_pkdouble(&aproxpi,1,1);
	
	info = pvm_send(ptid,pvm_mytid());
	
	pvm_exit();
	
	return 0;
}
