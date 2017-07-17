# `DiffResult` API

```@meta
CurrentModule = DiffBase
```

*Supported By:*

- [ForwardDiff](https://github.com/JuliaDiff/ForwardDiff.jl)
- [ReverseDiff](https://github.com/JuliaDiff/ReverseDiff.jl)

Many differentiation techniques can calculate primal values and multiple orders of
derivatives simultaneously. In other words, there are techniques for computing `f(x)`,
`∇f(x)` and `H(f(x))` in one fell swoop!

For this purpose, DiffBase provides the `DiffResult` type, which can be passed
to in-place differentiation methods instead of an output buffer. The method
then loads all computed results into the given `DiffResult`, which the user
can query afterwards using DiffBase's API.

Here's an example of the `DiffResult` in action using ForwardDiff:

```julia
julia> using ForwardDiff, DiffBase

julia> f(x) = sum(sin, x) + prod(tan, x) * sum(sqrt, x);

julia> x = rand(4);

# construct a `DiffResult` with storage for a Hessian, gradient,
# and primal value based on the type and shape of `x`.
julia> result = DiffBase.HessianResult(x)

# Instead of passing an output buffer to `hessian!`, we pass `result`.
# Note that we re-alias to `result` - this is important! See `hessian!`
# docs for why we do this.
julia> result = ForwardDiff.hessian!(result, f, x);

# ...and now we can get all the computed data from `result`
julia> DiffBase.value(result) == f(x)
true

julia> DiffBase.gradient(result) == ForwardDiff.gradient(f, x)
true

julia> DiffBase.hessian(result) == ForwardDiff.hessian(f, x)
true
```

The rest of this document describes the API for constructing, accessing, and mutating
`DiffResult` instances. For details on how to use a `DiffResult` with a specific
package's methods, please consult that package's documentation.

## Constructing DiffResults

```@docs
DiffBase.DiffResult
DiffBase.JacobianResult
DiffBase.GradientResult
DiffBase.HessianResult
```

## Accessing data from DiffResults

```@docs
DiffBase.value
DiffBase.derivative
DiffBase.gradient
DiffBase.jacobian
DiffBase.hessian
```

## Mutating DiffResults

```@docs
DiffBase.value!
DiffBase.derivative!
DiffBase.gradient!
DiffBase.jacobian!
DiffBase.hessian!
```
