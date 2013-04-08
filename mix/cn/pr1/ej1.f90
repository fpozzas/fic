program sumar
implicit none


real (kind=4) :: s1,s2
real (kind=8) :: d1,d2
integer (kind=4) :: i

s1 = 0
s2 = 0
d1 = 0
d2 = 0

do i = 1,1000000
	s1 = s1 + 0.125_4
	s2 = s2 + 0.1_4
	d1 = d1 + 0.125_8
	d2 = d2 + 0.1_8
end do

print*,'Suma 0.125 en simple precision -> ',s1
print*,'Suma 0.125 en doble precision  -> ',d1
print*,'Suma 0.1 en simple precision   -> ',s2
print*,'Suma 0.1 en doble precision    -> ',d2


end program sumar
	
