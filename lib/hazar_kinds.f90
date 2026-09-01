!> Kind parameters used throughout Hazar.
!!
!! Hazar targets Fortran 2003, so the Fortran 2008 `iso_fortran_env`
!! intrinsic module is intentionally not used here. In particular,
!! `REAL32` and `REAL64` are defined with `selected_real_kind()` to
!! keep the code portable across Fortran 2003 compilers.
!!
!! The legacy POM code used default `real` everywhere, i.e. single
!! precision. Its numerical output is the reference used to validate
!! this port, so `RK` is single precision by default.
!!
!! To switch the model to double precision, change the definition of
!! `RK` below from `REAL32` to `REAL64`. No other model code needs to
!! refer to a specific precision; all model variables should use `rk`.
!!
!! Note that `selected_real_kind()` specifies minimum decimal
!! precision and exponent range. It does not guarantee a particular
!! IEEE representation or storage size. For example, `REAL64`
!! requests at least 15 decimal digits and an exponent range of at
!! least 10^307; on common platforms this corresponds to IEEE
!! binary64, but this is not required by Fortran 2003.

module hazar_kinds

  implicit none

  private

  public :: REAL32, REAL64, RK

  integer, parameter :: REAL32 = selected_real_kind (p=6, r=37)
  integer, parameter :: REAL64 = selected_real_kind (p=15, r=307)

  !> Real kind used by the model.
  !!
  !! The default is REAL32 to preserve the numerical behavior of the
  !! original POM implementation, which used default `real`.
  !!
  !! Change REAL32 to REAL64 here to build the model in double precision.
  integer, parameter :: RK = REAL32

end module hazar_kinds
