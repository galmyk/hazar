! Runtime configuration for a single POM model instance.
!
! Replaces pom2k.f's compile-time `include 'grid'` / `include 'params'`
! mechanism, grid dimensions and run parameters are read from NAMELIST
! groups at runtime, so no recompilation is needed to change them. A
! HazarConfig value is plain data owned by whoever loads it -- it holds
! no mutable simulation state and is never stored in a module variable,
! so multiple independent configs/models can coexist.
!
! Defaults below reproduce pom2k.f's own defaults (the assignments
! preceding `include 'params'` in the main program), so a config that
! only overrides grid dimensions and iproblem-equivalent choices
! behaves like the legacy default run.

module hazar_config

  use hazar_kinds, only: RK
  use hazar_status, only: HazarStatus

  implicit none

  private

  public :: HazarConfig

  type :: HazarConfig
     ! --- &grid_nml -------------------------------------------------------
     ! Horizontal dimensions and number of sigma levels.
     integer :: im = 0
     integer :: jm = 0
     integer :: kb = 0

     ! Sigma-coordinate log-layer control. kl1-2 layers of reduced thickness
     ! at the surface, kb-kl2-1 at the bottom; kl1=2, kl2=kb-1 disables the
     ! log portions entirely. Default kl2 is resolved against kb at load
     ! time.
     integer :: kl1 = 6
     integer :: kl2 = -1  ! -1 => resolved to kb-2 in %load/%validate

     ! --- &time_control_nml -----------------------------------------------
     ! External (2-D) time step (secs.) according to CFL.
     real (RK) :: dte = 6.0_RK
     ! <Internal (3-D) time step>/<External (2-D) time step>
     ! (dti/dte; dimensionless)
     integer :: isplit = 30
     ! Total run duration, days.
     real (RK) :: days = 0.25_RK
     ! Diagnostic/output interval, days.
     real (RK) :: prtd1 = 0.125_RK
     ! Constant in temporal filter used to prevent solution splitting
     ! (dimensionless):
     real (RK) :: smoth = 0.10_RK
     ! Weight used for surface slope term in external (2-D) dynamic equation
     ! (a value of alpha = 0.e0 is perfectly acceptable, but the value,
     ! alpha=.225e0 permits a longer time step):
     real (RK) :: alpha = 0.225_RK
     ! Step interval during which external (2-D) mode advective terms are
     ! not updated (dimensionless):
     integer :: ispadv = 5
     ! Calculation mode:
     !   - 2 = 2-D-only (bottom stress from advave)
     !   - 3 = full 3-D (bottom stress from profu/profv)
     !   - 4 = 3-D with T/S held fixed.
     integer :: mode = 3
     ! Logical for inertial ramp (.true. if inertial ramp to be applied to
     ! wind stress and baroclinic forcing, otherwise .false.)
     logical :: lramp = .false.

     ! --- &physics_nml ----------------------------------------------------
     real (RK) :: grav   = 9.806_RK   ! gravitational acceleration, m/s^2
     real (RK) :: kappa  = 0.4_RK     ! von Karman's constant
     real (RK) :: z0b    = 0.01_RK    ! bottom roughness length, m
     real (RK) :: cbcmin = 0.0025_RK  ! minimum bottom friction coeff
     real (RK) :: cbcmax = 1.0_RK     ! maximum bottom friction coeff
     real (RK) :: horcon = 0.2_RK     ! Smagorinsky horizontal diffusivity coeff.
     real (RK) :: tprni  = 0.2_RK     ! inverse horizontal turbulent Prandtl number
     real (RK) :: umol   = 2.0e-5_RK  ! background vertical viscosity/diffusivity
     real (RK) :: vmaxl  = 100.0_RK   ! max permitted velocity (sanity/CFL check)
     real (RK) :: slmax  = 2.0_RK     ! max permitted sigma-coordinate slope
     real (RK) :: rhoref = 1025.0_RK  ! reference density, kg/m^3
     real (RK) :: tbias  = 0.0_RK     ! temperature bias, deg C
     real (RK) :: sbias  = 0.0_RK     ! salinity bias
     real (RK) :: hmax   = 4500.0_RK  ! maximum depth allowed, m
     ! Initial value of the 3-D horizontal viscosity aam, before any
     ! Smagorinsky update.
     real (RK) :: aam_init = 500.0_RK
     ! Temperature/salinity advection scheme:
     !   - 1 = centered scheme, as originally provide in POM
     !   - 2 = Smolarkiewicz iterative upstream scheme, based on subroutines
     !         provided by Gianmaria Sannino and Vincenzo Artale.
     integer :: nadv = 1
     ! Surface temperature boundary condition, used in subroutine proft:
     ! nbct  prescribed temperature  prescribed flux  short wave penetration
     ! 1     no                      yes              no
     ! 2     no                      yes              yes
     ! 3     yes                     no               no
     ! 4     yes                     no               yes
     integer :: nbct = 1
     ! Surface salinity boundary condition, used in subroutine proft:
     ! nbcs   prescribed salinity    prescribed flux
     ! 1      no                     yes
     ! 3      yes                    no
     integer :: nbcs = 1
     ! Water type, used in subroutine proft:
     !  ntp    Jerlov water type
     !  1      i
     !  2      ia
     !  3      ib
     !  4      ii
     !  5      iii
     integer :: ntp = 2

     ! --- &metadata_nml --------------------------------------------------
     character (len=40) :: title      = 'Run 1'
     character (len=26) :: time_start = '2000-01-01 00:00:00 +00:00'
  end type HazarConfig

end module hazar_config
