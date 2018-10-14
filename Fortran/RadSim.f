program radsim
implicit none

! Constants
integer :: particles  = 100
integer :: hits       = 0
integer :: iterations = 100
real :: i             = .1                        ! A

real :: innerRadius   = 10                        ! meters
real :: torusRadius   = 20                        ! meters
real :: totalRadius   = innerRadius + torusRadius ! meters

real :: pi            = 4 * atan(1.0_8)
real :: mu            = 4 * pi * (10 ** -7);      ! [Tm/A]

real :: dTheta        = .001 / pi                 ! radians
real :: delt          = 10 ** -6                  ! seconds

real :: scale         = 100000


! Wire geometry

! Radiation environment generator

		do o = 1, particles
			charge = 
			mass   =

			p1x    = (2 * 100 * ) - 100
			p1y    = (2 * 100 * ) - 100
			p1z    = (2 * 100 * ) - 100
			p      =

			v1x    = (2 * (3 * 10 ** 8) * ) - (3 * 10 ** 8);
			v1y    = (2 * (3 * 10 ** 8) * ) - (3 * 10 ** 8);
			v1z    = (2 * (3 * 10 ** 8) * ) - (3 * 10 ** 8);
			
!			while (abs(tan(acos(dot([vx1, vy1, vz1], [-px1, -py1, -pz1]) / (norm([vx1, vy1, vz1]) * norm([px1, py1, pz1])))))) > abs((30 / norm([px1, py1, pz1])))
!                vx1 = (2 * 3e8 * rand) - 3e8;
!                vy1 = (2 * 3e8 * rand) - 3e8;
!                vz1 = (2 * 3e8 * rand) - 3e8;
!                while sqrt((vx1^2) + (vy1^2) + (vz1^2)) >= 300000000
!                    vx1 = (2 * 3e8 * rand) - 3e8;
!                    vy1 = (2 * 3e8 * rand) - 3e8;
!                    vz1 = (2 * 3e8 * rand) - 3e8;

		end do

end program radsim