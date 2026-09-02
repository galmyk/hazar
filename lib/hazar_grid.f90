module hazar_grid

  use hazar_kinds, only: RK
  use hazar_status, only: HazarStatus

  implicit none

  private

  public :: HazarGrid

  type :: HazarGrid
     integer :: im, jm, kb

     ! Sigma-coordinate vertical structure
     real (RK), allocatable :: z(:)    ! sigma of cell face
     real (RK), allocatable :: zz(:)   ! sigma of cell centre
     real (RK), allocatable :: dz(:)   ! delta of sigma face
     real (RK), allocatable :: dzz(:)  ! delta of sigma center

     ! Horizontal grid spacing, metres.
     real (RK), allocatable :: dx(:, :)
     real (RK), allocatable :: dy(:, :)

     ! Geographic coordinates at each staggered-grid location, metres.
     real (RK), allocatable :: east_e(:, :)
     real (RK), allocatable :: north_e(:, :)
     real (RK), allocatable :: east_u(:, :)
     real (RK), allocatable :: north_u(:, :)
     real (RK), allocatable :: east_v(:, :)
     real (RK), allocatable :: north_v(:, :)
     real (RK), allocatable :: east_c(:, :)
     real (RK), allocatable :: north_c(:, :)

     ! Rotation of the x-axis w.r.t. east, degrees.
     real (RK), allocatable :: rot(:, :)

     ! Coriolis parameter.
     real (RK), allocatable :: cor(:, :)

     ! Undisturbed water depth, metres.
     real (RK), allocatable :: h(:, :)

     ! Masks: 1 = water, 0 = land (legacy: fsm, dum, dvm).
     real (RK), allocatable :: fsm(:, :)  ! free surface mask
     real (RK), allocatable :: dum(:, :)  ! U mask
     real (RK), allocatable :: dvm(:, :)  ! V mask

     ! Cell areas, m^2.
     real (RK), allocatable :: art(:, :)  ! cell area
     real (RK), allocatable :: aru(:, :)  ! U cell area
     real (RK), allocatable :: arv(:, :)  ! V cell area

     ! Quadratic bottom drag coefficient.
     real (RK), allocatable :: cbc(:, :)
   contains
     procedure :: allocate        => hazar_grid_allocate
     procedure :: destroy         => hazar_grid_destroy
     procedure :: depth           => hazar_grid_compute_sigma_coordinates
     procedure :: areas_and_masks => hazar_grid_compute_areas_and_masks
  end type HazarGrid

contains

  subroutine hazar_grid_allocate (self, im, jm, kb, status)
    class (HazarGrid) , intent (in out) :: self
    integer           , intent (in)     :: im, jm, kb
    type (HazarStatus), intent (out)    :: status

    call status%clear ()

    if (im <= 0 .or. jm <= 0 .or. kb <= 0) then
       call status%set (1, 'HazarGrid%allocate: im, jm, kb must all be positive')
       return
    end if

    call self%destroy ()

    self%im = im
    self%jm = jm
    self%kb = kb

    allocate (self%z(kb))
    allocate (self%zz(kb))
    allocate (self%dz(kb))
    allocate (self%dzz(kb))

    allocate (self%dx(im, jm))
    allocate (self%dy(im, jm))

    allocate (self%east_e(im, jm))
    allocate (self%north_e(im, jm))
    allocate (self%east_u(im, jm))
    allocate (self%north_u(im, jm))
    allocate (self%east_v(im, jm))
    allocate (self%north_v(im, jm))
    allocate (self%east_c(im, jm))
    allocate (self%north_c(im, jm))

    allocate (self%rot(im, jm))

    allocate (self%cor(im, jm))

    allocate (self%h(im, jm))

    allocate (self%fsm(im, jm))
    allocate (self%dum(im, jm))
    allocate (self%dvm (im, jm))

    allocate (self%art(im, jm))
    allocate (self%aru(im,jm))
    allocate (self%arv(im, jm))

    allocate (self%cbc(im,jm))

    self%dx = 0.0_RK
    self%dy = 0.0_RK

    self%east_e  = 0.0_RK
    self%north_e = 0.0_RK
    self%east_u  = 0.0_RK
    self%north_u = 0.0_RK
    self%east_v  = 0.0_RK
    self%north_v = 0.0_RK
    self%east_c  = 0.0_RK
    self%north_c = 0.0_RK

    self%rot = 0.0_RK

    self%cor = 0.0_RK

    self%h = 0.0_RK

    self%fsm = 0.0_RK
    self%dum = 0.0_RK
    self%dvm = 0.0_RK

    self%art = 0.0_RK
    self%aru = 0.0_RK
    self%arv = 0.0_RK

    self%cbc = 0.0_RK
  end subroutine hazar_grid_allocate

  subroutine hazar_grid_destroy (self)
    class (HazarGrid), intent (in out) :: self

    self%im = 0
    self%jm = 0
    self%kb = 0

    if (allocated (self%z))   deallocate (self%z)
    if (allocated (self%zz))  deallocate (self%zz)
    if (allocated (self%dz))  deallocate (self%dz)
    if (allocated (self%dzz)) deallocate (self%dzz)

    if (allocated (self%dx)) deallocate (self%dx)
    if (allocated (self%dy)) deallocate (self%dy)

    if (allocated (self%east_e))  deallocate (self%east_e)
    if (allocated (self%north_e)) deallocate (self%north_e)
    if (allocated (self%east_u))  deallocate (self%east_u)
    if (allocated (self%north_u)) deallocate (self%north_u)
    if (allocated (self%east_v))  deallocate (self%east_v)
    if (allocated (self%north_v)) deallocate (self%north_v)
    if (allocated (self%east_c))  deallocate (self%east_c)
    if (allocated (self%north_c)) deallocate (self%north_c)

    if (allocated (self%rot)) deallocate (self%rot)

    if (allocated (self%cor)) deallocate (self%cor)

    if (allocated (self%h)) deallocate (self%h)

    if (allocated (self%fsm)) deallocate (self%fsm)
    if (allocated (self%dum)) deallocate (self%dum)
    if (allocated (self%dvm)) deallocate (self%dvm)

    if (allocated (self%art)) deallocate (self%art)
    if (allocated (self%aru)) deallocate (self%aru)
    if (allocated (self%arv)) deallocate (self%arv)

    if (allocated (self%cbc)) deallocate (self%cbc)
  end subroutine hazar_grid_destroy

  ! Faithful port of pom2k.f's `subroutine depth`: establishes the
  ! vertical sigma grid with log distributions at the top and bottom and
  ! a linear distribution in between. kl1-2 layers of reduced thickness
  ! at the surface, kb-kl2-1 at the bottom; kl1=2, kl2=kb-1 disables the
  ! log portions. Numerically identical to the legacy routine.
  subroutine hazar_grid_compute_sigma_coordinates (self, kl1, kl2, status)
    class (HazarGrid) , intent (in out) :: self
    integer           , intent (in)     :: kl1, kl2
    type (HazarStatus), intent (out)    :: status

    integer   :: k
    real (RK) :: delz

    integer, parameter :: kdz(12) = [1, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]

    associate (kb => self%kb, z => self%z, zz => self%zz, dz => self%dz, dzz => self%dzz)
      call status%clear()

      if (kb <= 0) then
         call status%set(1, 'HazarGrid%depth: grid not allocated')
         return
      end if

      if (kl1 < 2 .or. kl1 >= kl2 .or. kl2 > kb - 1) then
         call status%set(1, 'HazarGrid%depth: require 2 <= kl1 < kl2 <= nz-1')
         return
      end if

      z(1) = 0.0_RK

      do k = 2, kl1
         z(k) = z(k - 1) + real (kdz(k - 1), RK)
      end do

      delz = z(kl1) - z(kl1 - 1)

      do k = kl1 + 1, kl2
         z(k) = z(k - 1) + delz
      end do

      do k = kl2 + 1, kb
         dz(k) = real (kdz(kb - k + 1), RK) * delz / real (kdz(kb - kl2), RK)
         z(k) = z(k - 1) + dz(k)
      end do

      do k = 1, kb
         z(k) = -z(k) / z(kb)
      end do

      do k = 1, kb - 1
         zz(k) = 0.5_RK * (z(k) + z(k + 1))
      end do

      zz(kb) = 2.0_rk * zz(kb - 1) - zz(kb - 2)

      do k = 1, kb - 1
         dz(k)  = z(k)  - z(k + 1)
         dzz(k) = zz(k) - zz(k + 1)
      end do

      dz(kb)  = 0.0_RK
      dzz(kb) = 0.0_RK

      print '(/2x, "k", 7x, "z", 9x, "zz", 9x, "dz", 9x, "dzz", /)'

      do k = 1, kb
         print '(" ", i5, 4f10.3)', k, z(k), zz(k), dz(k), dzz(k)
      end do

      print '(//)'
    end associate
  end subroutine hazar_grid_compute_sigma_coordinates

  ! Faithful port of pom2k.f's `subroutine areas_masks`. Requires
  ! dx, dy and depth (h) to already be populated; land is depth <= 1 metre,
  ! exactly as in the legacy routine.
  subroutine hazar_grid_compute_areas_and_masks (self, status)
    class (HazarGrid) , intent (in out) :: self
    type (HazarStatus), intent (out)    :: status

    integer :: i, j

    call status%clear ()

    associate (im => self%im, jm => self%jm, dx => self%dx, dy => self%dy, h => self%h, &
         &     art => self%art, aru => self%aru, arv => self%arv, &
         &     fsm => self%fsm, dum => self%dum, dvm => self%dvm)

      if (im <= 0 .or. jm <= 0) then
         call status%set (1, 'HazarGrid%areas_masks: grid not allocated')
         return
      end if

      do j = 1, jm
         do i = 1, im
            art(i, j) = dx(i, j) * dy(i, j)
         end do
      end do

      do j = 2, jm
         do i = 2, im
            aru(i, j) = 0.25_RK * (dx(i, j) + dx(i - 1, j)) * (dy(i, j) + dy(i - 1, j))
            arv(i, j) = 0.25_RK * (dx(i, j) + dx(i, j - 1)) * (dy(i, j) + dy(i, j - 1))
         end do
      end do

      do j = 1, jm
         aru(1, j) = aru(2, j)
         arv(1, j) = arv(2, j)
      end do

      do i = 1, im
         aru(i, 1) = aru(i, 2)
         arv(i, 1) = arv(i, 2)
      end do

      fsm = 0.0_RK
      dum = 0.0_RK
      dvm = 0.0_RK
      do j = 1, jm
         do i = 1, im
            if (h(i, j) > 1.0_RK) fsm(i, j) = 1.0_RK
         end do
      end do

      do j = 2, jm
         do i = 2, im
            dum(i, j) = fsm(i, j) * fsm(i - 1, j)
            dvm(i, j) = fsm(i, j) * fsm(i, j - 1)
         end do
      end do

    end associate
  end subroutine hazar_grid_compute_areas_and_masks

end module hazar_grid
