!> Minimal Fortran-2003-compatible error signaling for library code.
!!
!! Library code must not call STOP on every error; the caller must be
!! able to detect failure and decide what to do (the CLI driver is free
!! to turn a failed status into a non-zero process exit).

module hazar_status

  implicit none

  private

  public :: HazarStatus, HAZAR_OK

  integer, parameter :: HAZAR_OK = 0

  type :: HazarStatus
     integer                        :: code = HAZAR_OK
     character (len=:), allocatable :: message
   contains
     procedure :: failed => hazar_status_failed
     procedure :: set    => hazar_status_set
     procedure :: clear  => hazar_status_clear
  end type HazarStatus

contains

  pure function hazar_status_failed (self) result (ret)
    class (HazarStatus), intent (in) :: self

    logical :: ret

    ret = (self%code /= HAZAR_OK)
  end function hazar_status_failed

  subroutine hazar_status_set (self, code, message)
    class (HazarStatus), intent (in out) :: self
    integer            , intent (in)     :: code
    character (len=*)  , intent (in)     :: message

    self%code    = code
    self%message = message
  end subroutine hazar_status_set

  subroutine hazar_status_clear (self)
    class (HazarStatus), intent (in out) :: self

    self%code = HAZAR_OK

    if (allocated (self%message)) deallocate (self%message)
  end subroutine hazar_status_clear

end module hazar_status
