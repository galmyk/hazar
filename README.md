# Hazar

**Hazar** is a modern Fortran ocean modeling framework derived from the
**Princeton Ocean Model (POM2K)**.

The name **Hazar** (Hazar deňzi; Hazar / Хазар) is the Turkmen name for
the **Caspian Sea**. It reflects the project's Turkmen heritage, its
connection to the sea, and its origins in ocean modeling.

Hazar seeks to preserve the scientific foundations and numerical
behavior of POM2K while progressively replacing its legacy architecture
with a modern, modular, maintainable, and extensible Fortran
implementation.

> **Status: Early development**
>
> Hazar is currently focused on the structural modernization of POM2K.
> The primary objective of the initial development phase is to
> reproduce the behavior of the original model while establishing a
> foundation for future scientific and architectural development.

## Modernization Philosophy

The modernization is intentionally
**incremental and behavior-preserving**.

The initial implementation retains many of POM2K's original concepts,
variable names, numerical algorithms, and computational structures
where practical. Architectural changes are introduced independently
from scientific and numerical changes so that their effects can be
isolated and validated.

One of the central architectural objectives is to replace globally
shared state, historically represented through Fortran `COMMON` blocks,
with explicit model state encapsulated in derived types. This enables
independent model instances and provides a foundation for coupling
multiple models within a single executable.

The guiding principle is:

> **Preserve first. Improve second.**
>
> Large scientific codes are particularly difficult to modernize
> because architectural changes can unintentionally alter numerical
> behavior. Hazar therefore avoids simultaneous architectural and
> scientific redesign. Each stage is intended to make it possible to
> distinguish changes in software structure from changes in numerical
> implementation or scientific behavior.

---

## Goals

POM2K is a mature and scientifically significant ocean circulation
model, but its architecture reflects the Fortran practices of its era.
Extensive global state and `COMMON` blocks create strong coupling
between components and make several modern use cases unnecessarily
difficult, including:

* running multiple independent model instances within a single
  executable;
* coupling multiple ocean models or numerical components;
* integrating POM with other scientific models;
* reasoning explicitly about model state and ownership;
* testing components in isolation;
* extending the model without increasing global coupling.

Hazar addresses these architectural limitations while initially
preserving as much of the established POM2K implementation and behavior
as practical.

The long-term objectives are to provide:

* modern Fortran implementation;
* encapsulated and explicitly owned model state;
* support for multiple independent model instances;
* interfaces suitable for coupled models;
* modular and well-defined component boundaries;
* improved testability and maintainability;
* preservation of POM2K numerical behavior during the initial
  modernization;
* a foundation for future physical and numerical extensions;
* modern I/O and configuration facilities;
* a foundation for modern parallel computing architectures.

---

## Modernization Strategy

Hazar is being developed through several broad stages.

### 1. Structural Modernization

The first stage focuses on modernizing the software architecture while
avoiding unnecessary changes to the underlying science and numerical
methods.

Key activities include:

* migration to free-form modern Fortran;
* use of `implicit none`;
* introduction of modules and explicit interfaces;
* replacement of global state with derived types;
* encapsulation of model state;
* removal of `COMMON` blocks;
* explicit data ownership;
* use of allocatable arrays;
* improved memory management;
* modernization of procedure interfaces;
* support for multiple model instances.

Original variable names and numerical algorithms will generally be
retained where practical. This preserves traceability to POM2K and
facilitates direct comparison between the legacy and modernized
implementations.

### 2. Numerical and Scientific Validation

The modernized implementation will be continuously validated against
the original POM2K implementation.

Validation will include:

* regression testing;
* conservation-property verification;
* established benchmark problems;
* the *Seamount*, *Conservation Box* and *IC from file* test cases;
* numerical stability analysis;
* long-duration integrations;
* field-by-field comparisons;
* tolerance-based numerical comparisons.

The objective is to ensure that structural modernization does not
silently introduce scientific or numerical changes.

### 3. Architectural Refinement

Once the initial modernization has been validated, the architecture can
evolve toward clearer abstractions and stronger separation of concerns.

Potential areas of refinement include:

* separation of physical processes;
* well-defined model APIs;
* grid abstractions;
* state and diagnostic abstractions;
* tracer infrastructure;
* boundary-condition interfaces;
* forcing interfaces;
* I/O abstractions;
* configuration systems;
* model coupling interfaces.

At this stage, architectural improvements can be introduced with
greater freedom because the behavior of the modernization baseline will
already be characterized.

### 4. Scientific and Numerical Evolution

After the modernization has reached sufficient maturity, Hazar may
evolve beyond a direct POM2K modernization.

Potential areas of future development include:

* new numerical schemes;
* additional turbulence closures;
* additional tracer formulations;
* improved boundary treatments;
* new forcing mechanisms;
* enhanced diagnostics;
* expanded coupling capabilities;
* modern parallelization strategies;
* additional physical parameterizations.

These developments will represent deliberate scientific and numerical
evolution rather than merely architectural modernization.

---

## POM2K Heritage

Hazar is derived from the **Princeton Ocean Model (POM)** and
**POM2K**.

The Princeton Ocean Model was developed by **Alan F. Blumberg** and
**George L. Mellor**, with subsequent contributions from
**Leo Oey, Steve Brenner, John Hunter**, and many others.

The model is grounded in the primitive-equation ocean circulation
framework described in the following foundational works:

* Blumberg, A. F. & Mellor, G. L. (1983).
  *Diagnostic and prognostic numerical circulation studies of the South Atlantic Bight*.
  Journal of Geophysical Research, **88**, 4579–4592.
* Blumberg, A. F. & Mellor, G. L. (1987).
  *A description of a three-dimensional coastal ocean circulation model*.
  In N. S. Heaps (Ed.), *Three-Dimensional Coastal Ocean Models*, Coastal and Estuarine Sciences, Vol. 4,
  American Geophysical Union, 1–16.
* Mellor, G. L. & Yamada, T. (1982).
  *Development of a turbulence closure model for geophysical fluid problems*.
  Reviews of Geophysics and Space Physics, **20**(4), 851–875.

The original POM2K source was distributed under the
**GNU General Public License, version 2 or later (GPL-2.0-or-later)**.

Hazar is distributed under the
**GNU General Public License, version 3 or later (GPL-3.0-or-later)**.

See [`COPYING.md`](COPYING.md) and [`NOTICE.md`](NOTICE.md) for
complete licensing, attribution, and provenance information.

---

## Scientific References

The scientific foundations of Hazar are an integral part of the
project's documentation. The following references provide the principal
theoretical and historical foundations of the model:

### Princeton Ocean Model

Blumberg, A. F. & Mellor, G. L. (1983).

> Diagnostic and prognostic numerical circulation studies of the South
> Atlantic Bight.

*Journal of Geophysical Research*, **88**, 4579–4592.

### Three-Dimensional Coastal Ocean Model

Blumberg, A. F. & Mellor, G. L. (1987).

> A description of a three-dimensional coastal ocean circulation model.

In N. S. Heaps (Ed.), *Three-Dimensional Coastal Ocean Models*, Coastal
and Estuarine Sciences, Vol. 4, American Geophysical Union, 1–16.

### Turbulence Closure

Mellor, G. L. & Yamada, T. (1982).

> Development of a turbulence closure model for geophysical fluid
> problems.

*Reviews of Geophysics and Space Physics*, **20**(4), 851–875.

---

## Development Philosophy

Hazar is a **scientific software project first** and a
software-engineering modernization project second. Software engineering
practices are therefore evaluated in the context of scientific validity
and reproducibility.

Correctness has several complementary dimensions:

1. **Scientific correctness** —
   the implementation must faithfully represent the intended physical
   model.
2. **Numerical correctness** —
   discretization, numerical algorithms, and computational procedures
   must exhibit the intended numerical behavior.
3. **Regression correctness** —
   modernization must not unintentionally alter established POM2K
   behavior.
4. **Software correctness** —
   state, memory, interfaces, ownership, and resource lifetimes must be
   well defined.
5. **Reproducibility** —
   simulations, experiments, and validation results should be
   repeatable and sufficiently documented.

A cleaner API, more sophisticated abstraction, or more modern
implementation is not considered an improvement if it silently changes
the scientific behavior of the model.

---

## Contributing

Hazar is currently in an early development phase. During the initial
modernization, contributions should favor controlled, traceable changes
over broad redesigns.

In particular, contributions should emphasize:

* small and reviewable changes;
* preservation of established numerical behavior;
* clear provenance for code derived from POM2K;
* regression tests;
* explicit documentation of numerical changes;
* adherence to modern Fortran practices;
* minimal and well-justified architectural complexity.

Architectural refactoring, numerical modifications, and scientific
changes should be clearly distinguished in commits, pull requests, and
documentation whenever possible.

---

## License

Hazar is free software distributed under the terms of the:

**GNU General Public License, version 3 or later (GPL-3.0-or-later).**

Hazar contains work derived from the Princeton Ocean Model / POM2K,
which was originally distributed under the **GPL-2.0-or-later**.

See [`COPYING.md`](COPYING.md) for the complete license text and
[`NOTICE.md`](NOTICE.md) for attribution and provenance information.
