module variables
implicit none

real (kind=4), dimension(:), allocatable :: simplerelativo
real (kind=8), dimension(:), allocatable :: doblerelativo
end module variables

program ej3
use variables
implicit none

integer (kind=4) :: i,n,simplecount,doublecount
real (kind=4) :: fact
real (kind=8) :: ex,dfact
print*,'Numero de aprox maximas: '
read*,n
allocate(simplerelativo(n))
allocate(doblerelativo(n))
print*,'Exponente del error: '
read*,n

ex =dexp(1.0_8)

fact = 1.0_4
simplerelativo(1) = 1.0_4
do i=2,500
	fact = (i-1) * fact
	
	simplerelativo(i) = (1.0_4 / fact) + simplerelativo(i-1) 
	if ((abs(simplerelativo(i)-ex)/ex) < 10.0**n) exit
end do
simplecount = i

dfact = 1.0_8
doblerelativo(1) = 1.0_8
do i=2,500
	dfact = dble(i-1) * dfact
	doblerelativo(i) = (1.0_8 / dfact) + doblerelativo(i-1)
	if ((abs(doblerelativo(i)-ex)/ex) < 10.0**n) exit
end do
doublecount = i


!imprimimos los resultados

print*,'Aproximaciones en simple precision al numero e'
do i=1,simplecount
	print*,'Aproximacion ',i,' : ',simplerelativo(i),' --- ',ex
end do

print*,'Aproximaciones en doble precision al numero e'
do i=1,doublecount
	print*,'Aproximacion ',i,' : ',doblerelativo(i),' --- ',ex
end do

end program ej3




