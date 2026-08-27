# Hazar — Notices and Attribution

## Project

**Hazar** is a modern Fortran ocean modeling framework derived from the
**Princeton Ocean Model (POM2K)**.

Hazar is being developed as a long-term modernization and evolution of
POM2K. The initial development focuses on preserving the scientific and
numerical foundations of the original model while replacing its legacy
software architecture with modern Fortran constructs, explicit state
management, modular interfaces, and support for multiple independent
model instances.

## Original Princeton Ocean Model

The Princeton Ocean Model (POM) was developed by **Alan F. Blumberg**
and **George L. Mellor**, with subsequent contributions from
**Leo Oey, Steve Brenner, John Hunter**, and others.

POM and its subsequent versions, including POM2K, have been developed
and maintained through contributions from researchers and institutions
over many years.

Hazar acknowledges and preserves the scientific and software heritage
of these contributions.

The original POM2K source distribution used by Hazar contains the
following licensing statement:

> This program is free software; you can redistribute it and/or modify
> it under the terms of the GNU General Public License, either Version
> 2 of the license, or (at your option) any later version.

Accordingly, the original POM2K code is identified as
**GPL-2.0-or-later**.

Hazar's adapted and rewritten code is distributed under
**GPL-3.0-or-later**, as permitted by the original license.

See [`COPYING.md`](COPYING.md) for the complete license text.

## Scientific Heritage

Hazar builds upon the scientific foundations established by the
Princeton Ocean Model and related oceanographic research.

Important foundational references include:

* Blumberg, A. F. & Mellor, G. L. (1983).
  *Diagnostic and prognostic numerical circulation studies of the South Atlantic Bight*.
  Journal of Geophysical Research, 88, 4579–4592.
* Blumberg, A. F. & Mellor, G. L. (1987).
  *A description of a three-dimensional coastal ocean circulation model*.
  In N. S. Heaps (ed.), Three-Dimensional Coastal Ocean Models, Coastal and Estuarine Sciences, Vol. 4,
  American Geophysical Union, 1–16.
* Mellor, G. L. & Yamada, T. (1982).
  *Development of a turbulence closure model for geophysical fluid problems*.
  Reviews of Geophysics and Space Physics, 20(4), 851–875.

These references describe the physical, numerical, and
turbulence-modeling foundations upon which POM was developed.

## Hazar Development

Hazar is a substantial modernization and ongoing evolution of the POM2K
codebase.

During the initial modernization stages, substantial effort is being
made to preserve correspondence with the original implementation,
including established variable names, numerical algorithms, model
equations, and computational procedures. As the project evolves,
portions of the implementation may be substantially redesigned or newly
developed.

Code that is directly derived from or adapted from POM2K remains
subject to the applicable terms of the original GPL license.

New code and subsequent original developments within Hazar are
distributed under the project's GPL-3.0-or-later license.

## Name

The name **Hazar** (Hazar deňzi; Hazar / Хазар) is the Turkmen name for
the **Caspian Sea**.

The name reflects the project's Turkmen heritage, its connection to the
sea, and its origins in ocean modeling.

## Attribution

When redistributing Hazar or substantial portions of its source code,
please retain this notice together with the applicable copyright and
license notices contained in the source distribution.

Scientific publications or other academic work based on Hazar should
appropriately cite both Hazar and the scientific publications
underlying the relevant model components.

## Disclaimer

Hazar is a scientific software project under active development. It is
provided under the terms of the GNU General Public License without
warranty, as specified by that license.

Neither the original POM authors nor the Hazar developers assume
responsibility for scientific, engineering, operational, or other
consequences arising from the use of the software.

---

For licensing terms, see [`COPYING.md`](COPYING.md).
