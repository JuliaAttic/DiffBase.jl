# DiffBase

**THIS PACKAGE IS NO LONGER MAINTAINED. It has been replaced by DiffRules.jl, DiffResults.jl, and DiffTests.jl.**

[![Build Status](https://travis-ci.org/JuliaDiff/DiffBase.jl.svg?branch=master)](https://travis-ci.org/JuliaDiff/DiffBase.jl)
[![Coverage Status](https://coveralls.io/repos/github/JuliaDiff/DiffBase.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaDiff/DiffBase.jl?branch=master)

[![](https://img.shields.io/badge/docs-stable-blue.svg)](http://www.juliadiff.org/DiffBase.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](http://www.juliadiff.org/DiffBase.jl/latest)

DiffBase provides common utilities employed by various JuliaDiff packages, including:

- The `DiffResult` API for extracting multiple orders of derivatives simultaneously
- The `diffrule` API for defining reusable derivative definitions
- A suite of test functions for stressing the robustness of differentiation tools
