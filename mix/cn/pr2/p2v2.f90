module variables
implicit none
integer (kind=4) :: n,i,j,k
real (kind=8), dimension(:,:), allocatable :: a,aini
real (kind=8), dimension(:), allocatable :: b,x,x2
end module variables

program practica2
use variables
implicit none
interface
	subroutine leermatrices
	end subroutine leermatrices
	subroutine factLU
	end subroutine factLU
	subroutine cholesky
	end subroutine cholesky
end interface

call leermatrices
!call factLU
call cholesky
print*,"Esto es x:"
do i=1,n
	print*,x(i)
end do
print*,"Lo que da A * x:"
do i=1,n
	x2(i) = dot_product(aini(i,:),x)
end do
do i=1,n
	print*,x2(i)
end do
end program practica2

subroutine leermatrices
	use variables
	implicit none
	open(1,file='matriz.dat',form='formatted')
	rewind(1)
	read(1,*) n
	allocate(a(n,n))
	allocate(b(n))
	allocate(x(n))
	allocate(x2(n))
	do i = 1,n
		read(1,*) a(i,:), b(i)
	end do
	allocate(aini(n,n))
	aini=a
	close(1)
	do i=1,n
		print*,a(i,:)
	end do
end subroutine leermatrices

subroutine factLU
	use variables
	implicit none
	real (kind=8), dimension(size(b)) :: y
	!!! Factorización LU
	n = size(b)
	do i=1,n
		a(i,i) = a(i,i) - dot_product(a(i,1:(i-1)),a(1:(i-1),i))
		if (a(i,i)==0) then 
			print*,"Error Factorización LU: no existe solución única"
			exit
		end if
		do j=i+1,n
			a(i,j) = a(i,j) - dot_product(a(i,1:(i-1)),a(1:(i-1),j))
			a(j,i) = (a(j,i) - dot_product(a(j,1:(i-1)),a(1:(i-1),i)))/a(i,i)
		end do 
	end do
	!!! Calculamos Ly = b
	y(1) = b(1);
	do i=2,n
		y(i) = b(i) - dot_product(a(i,1:(i-1)),y(1:(i-1)))
	end do
	!!! Calculamos Ux = y
	x(n) = y(n) / a(n,n)
	do i=(n-1),1,-1
		x(i) = (y(i) - dot_product(a(i,(i+1):n),x(i+1:n)))/a(i,i)
	end do

end subroutine factLU

subroutine cholesky
	use variables
	implicit none
	real (kind=8), dimension(size(b),size(b)) :: a2
	real (kind=8), dimension(size(b)) :: b2,y
	!!! Calculamos b2 = At * b
	do i=1,n
		b2(i) = dot_product(a(:,i),b)
	end do
	!!! Calculamos a2 = At * A
	do i=1,n
		do j=1,n
			a2(i,j) = dot_product(a(:,i),a(:,j))
		end do
	end do
	!!! Entonces a2 * x = b2 siendo a2 simetrica
	!!! Calculamos L (directamente en a2)
	a2(1,1) = sqrt(a2(1,1))
	do j=2,n
		a2(j,1) = a2(j,1)/a2(1,1)
	end do
	do i=2,n-1
		a2(i,i) = sqrt(a2(i,i)- dot_product(a2(i,1:(i-1)),a2(i,1:(i-1))))
		do j=(i+1),n
			a2(j,i) = (a2(j,i) - dot_product(a2(j,1:(i-1)),a2(i,1:(i-1))))/a2(i,i)
		end do
	end do
	a2(n,n) = sqrt(a2(n,n)- dot_product(a2(n,1:(n-1)),a2(n,1:(n-1))))
	
	do i=1,n
		print*,a2(i,:)
	end do
	
	!!! Calculamos L * y = b2
	y(1) = b2(1)/a2(1,1);
	do i=2,n
		y(i) = (b2(i) - dot_product(a2(i,1:(i-1)),y(1:(i-1))))/a2(i,i)
	end do
	!!! Calculamos Lt * x = y
	x(n) = y(n) / a2(n,n)
	do i=(n-1),1,-1
		x(i) = (y(i) - dot_product(a2((i+1):n,i),x(i+1:n)))/a2(i,i)
	end do

end subroutine cholesky








