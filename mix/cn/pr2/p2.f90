module variables
implicit none
integer (kind=4) :: n,i,j,k,iter
real (kind=8), dimension(:,:), allocatable :: a,aini
real (kind=8), dimension(:), allocatable :: b,x,x2
real (kind=8) :: w

end module variables

program practica2
use variables
implicit none
integer (kind=4) :: opcion
interface
	subroutine leermatrices
	end subroutine leermatrices
	subroutine escribirresultado
	end subroutine escribirresultado
	subroutine factLU
	end subroutine factLU
	subroutine cholesky
	end subroutine cholesky
	subroutine relajacion
	end subroutine relajacion
end interface

call leermatrices

print*,'LU -> 1, Cholesky -> 2, Relajación -> 3: '
print*,'Opción:'
read*,opcion
if (opcion==1) then
	call factLU
else if (opcion==2) then
	call cholesky
else if (opcion==3) then
	print*,'Introduce parametro de relajación:'
	read*,w
	print*,'Introduce iteraciones:'
	read*,iter
	call relajacion
end if

print*,"Valores del vector x:"
do i=1,n
	print 10,x(i)
	10 format (f18.12)
end do
print*,"Resultado de A * x frente a b:"
do i=1,n
	x2(i) = dot_product(aini(i,:),x)
end do
do i=1,n
	print 20,x2(i),b(i) 
	20 format (f18.12 , f18.12)
end do

call escribirresultado

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
end subroutine leermatrices

subroutine escribirresultado
	use variables
	implicit none
	open(1,file='resultado.dat',form='formatted')
	rewind(1)
	write (1,100) x
	100 format (f18.12)
	close(1)
end subroutine

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

subroutine relajacion
	use variables
	implicit none
	real (kind=8), dimension(size(b),size(b)) :: a2,aw
	real (kind=8), dimension(size(b)) :: r,z
	!!! Establecemos el parametro de relajación
	w = 0.5_8
	!!! Empezamos con un x0 = 0
	do i=1,n
		x(i) = 0
	end do
	!!! Calculamos aw
	aw = w * a
	do i=2,n
		aw(i,i) = a(i,i)
	end do
	!!! Se define un numero de interaciones
	do k=1,iter
		!!! Calculamos r = a * xK
		do i=1,n
			r(i) = dot_product(a(i,:),x)
		end do
		!!! Calculamos el vector residuo rK = b - r
		r = b - r
		!!! Ahora habria que resolver el sistema (D - w*E)z = rK
		!!! Si hacemos (D -wE) nos quedará una triangular inferior
		!!! Por lo tanto, se multiplica w por los elementos bajo la diagonal principal de a (aw)
		!!! Resolvemos el sistema como una triangular inferior
		z(1) = r(1)/aw(1,1);
		do i=2,n
			z(i) = (r(i) - dot_product(aw(i,1:(i-1)),z(1:(i-1))))/aw(i,i)
		end do
		!!! Calculamos x(K+1) = xK + w*z
		x = x + w*z
	end do
	
end subroutine relajacion








