program radsim
implicit none

! Constants
integer, parameter :: particles  = 100
integer :: hits                  = 0
integer, parameter :: coilTurns = 100
real :: i                        = .1                        ! A

real, parameter :: innerRadius   = 10                        ! meters
real, parameter :: torusRadius   = 20                        ! meters
real, parameter :: totalRadius   = innerRadius + torusRadius ! meters

real, parameter :: pi            = 4 * atan(1.0_8)
real, parameter :: mu            = 4 * pi * (10 ** -7);      ! [Tm/A]

real, parameter :: dTheta        = .001 / pi                 ! radians
real, parameter :: delt          = 10 ** -6                  ! seconds

real :: scale                    = 100000


! What does this do? 
do k = 1, 100
    real :: ps  = radiationEnvironmentGenerator(particles)
    real :: env = ps(k,:)

    real :: m   = env(1)
    real :: q   = env(2)

    real :: p0x = env(3)
    real :: p0y = env(4)
    real :: p0z = env(5)

    real :: v0x = env(6)
    real :: v0y = env(7)
    real :: v0z = env(8)

    real :: a0x = env(9)
    real :: a0y = env(10)
    real :: a0z = env(11)
end do


! Wire geometry
real, dimension(:) :: wiregeometry;

real :: phimax = asin(((torusradius - innerradius)/2) / (innerradius + (torusradius - innerradius)/2));
real :: dphi = coilTurns * dtheta;
real :: phi = pi/2 - phimax;

! ISSUE HERE
do theta = 0:dtheta:(2 * pi)
    real :: x = (torusradius + innerradius * cos(phi)) * cos(theta);
    real :: y = (torusradius + innerradius * cos(phi)) * sin(theta);
    real :: z = innerradius * sin(phi);

    ! ISSUE HERE
    wiregeometry = [wiregeometry; x, y, z];
    real :: phi = phi + dphi;
end do

print *, "Wire geometry complete \n"


! Radiation environment generator
SUBROUTINE radiationEnvironmentGenerator(particles) 
    do o = 1, particles
        real :: charge = 
        real :: mass   = 

        ! NEED THE RANDOM FUNCTION IN FORTRAN
        SUBROUTINE generateVectors(velocityOnly)
        	if (velocityOnly /= 1) then
                real, dimension(1:3) :: p_vect, v_vect
        		do i = 1,3
                    p_vect(i) = (2 * 100 * rand) - 100                     ! loop to generate px1, py1, pz1
                    v_vect(i) = (2 * (3 * 10 ** 8) * rand) - (3 * 10 ** 8) ! loop to generate vx1, vy1, vz1
                end do
                RETURN p, v
            else
                real, dimension(1:3) :: v_vect
                do i = 1,3
                    v_vect(i) = (2 * (3 * 10 ** 8) * rand) - (3 * 10 ** 8)
                end do
                RETURN v
            end if
        end

        p, v = generateVectors(0)

        ! NEED THE NORMALIZE FUNCTION IN FORTRAN
        do while (abs(tan(acos(DOT_PRODUCT(v, p * -1) / (norm(v) * norm(p)))))) > abs((30 / norm(p)))
            v = generateVectors(1)

            do while sqrt((v(1) ** 2) + (v(2) ** 2) + (v(3) ** 2)) >= 300000000
                    v = generateVectors(1)
            end do
        end do
    RETURN v
end do

end program radsim