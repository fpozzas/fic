program ej2
implicit none

real (kind=4), dimension(20) :: ms
real (kind=8), dimension(20) :: md
interface
	subroutine imprimir(ms,md)
	real (kind=4), dimension(20) :: ms
	real (kind=8), dimension(20) :: md
	end subroutine imprimir
	
	subroutine calcular(ms,md)
	real (kind=4), dimension(20) :: ms
	real (kind=8), dimension(20) :: md
	end subroutine calcular
end interface

call calcular(ms,md)
call imprimir(ms,md)


end program ej2

	subroutine calcular(ms,md)	
	implicit none
	real (kind=4), dimension(20) :: ms
	real (kind=8), dimension(20) :: md
	integer (kind=4) :: i
	real (kind=4) :: hs
	real (kind=8) :: hd
	hs = 1.0_4
	hd = 1.0_8
	do i = 1,20
		hs = hs / 10.0_4
		hd = hd / 10.0_8
		ms(i)=(sin(1.0_4 + hs) - sin(1.0_4))/hs
		md(i)=(dsin(1.0_8 + hd) - dsin(1.0_8))/hd
	end do
	end subroutine calcular
	
	subroutine imprimir(ms,md)
	implicit none
	real (kind=4), dimension(20) :: ms
	real (kind=8), dimension(20) :: md
	integer (kind=4) :: i
	real (kind=8) :: c
	c = dcos(1.0_8)
	print*,'****************************************'
	print*,'Aproximaciones a cos(1) -> ',c
	print*,'****************************************'
	print*,'de 10**-1 a 10**-20'
	do i = 1,20
		print*,ms(i),'--',md(i),'--',c
	end do
	end subroutine imprimir
