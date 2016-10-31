
<a id='DiffResult-API-Documentation-1'></a>

# DiffResult API Documentation




*Supported By:*


  * [ForwardDiff](https://github.com/JuliaDiff/ForwardDiff.jl)
  * [ReverseDiff](https://github.com/JuliaDiff/ReverseDiff.jl)


Many differentiation techniques can calculate primal values and multiple orders of derivatives simultaneously. In other words, there are techniques for computing `f(x)`, `∇f(x)` and `H(f(x))` in one fell swoop!


For this purpose, DiffBase provides the `DiffResult` type, which can be passed to in-place differentiation methods instead of an output buffer. The method then loads all computed results into the given `DiffResult`, which the user can query afterwards using DiffBase's API.


Here's an example of the `DiffResult` in action using ForwardDiff:


```julia
julia> using ForwardDiff, DiffBase

julia> f(x) = sum(sin, x) + prod(tan, x) * sum(sqrt, x);

julia> x = rand(4);

# construct a `DiffResult` with storage for a Hessian, gradient,
# and primal value based on the type and shape of `x`.
julia> result = DiffBase.HessianResult(x)

# instead of passing an output buffer to `hessian!`, we pass `result`
julia> ForwardDiff.hessian!(result, f, x);

# ...and now we can get all the computed data from `result`
julia> DiffBase.value(result) == f(x)
true

julia> DiffBase.gradient(result) == ForwardDiff.gradient(f, x)
true

julia> DiffBase.hessian(result) == ForwardDiff.hessian(f, x)
true
```


The rest of this document describes the API for constructing, accessing, and mutating `DiffResult` instances. For details on how to use a `DiffResult` with a specific package's methods, please consult that package's documentation.


<a id='Constructing-DiffResults-1'></a>

## Constructing DiffResults

<a id='DiffBase.DiffResult' href='#DiffBase.DiffResult'>#</a>
**`DiffBase.DiffResult`** &mdash; *Type*.



```
DiffResult(value, derivs::Tuple)
```

Return a `DiffResult` instance where values will be stored in the provided `value` storage and derivatives will be stored in the provided `derivs` storage.

Note that the arguments can be `Number`s or `AbstractArray`s, depending on the dimensionality of your target function.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L11-L19' class='documenter-source'>source</a><br>


```
DiffResult(value, derivs...)
```

Equivalent to `DiffResult(value, derivs::Tuple)`, where `derivs...` is the splatted form of `derivs::Tuple`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L22-L26' class='documenter-source'>source</a><br>

<a id='DiffBase.JacobianResult' href='#DiffBase.JacobianResult'>#</a>
**`DiffBase.JacobianResult`** &mdash; *Function*.



```
JacobianResult(x::AbstractArray)
```

Construct a `DiffResult` that can be used for Jacobian calculations where `x` is the input to the target function. This method assumes that the target function's output dimension equals its input dimension.

Note that `JacobianResult` allocates its own storage; `x` is only used for type and shape information. If you want to allocate storage yourself, use the `DiffResult` constructor instead.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L41-L51' class='documenter-source'>source</a><br>


```
JacobianResult(y::AbstractArray, x::AbstractArray)
```

Construct a `DiffResult` that can be used for Jacobian calculations where `x` is the input to the target function, and `y` is the output (e.g. when taking the Jacobian of `f!(y, x)`).

Like the single argument version, `y` and `x` are only used for type and shape information and are not stored in the returned `DiffResult`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L54-L63' class='documenter-source'>source</a><br>

<a id='DiffBase.GradientResult' href='#DiffBase.GradientResult'>#</a>
**`DiffBase.GradientResult`** &mdash; *Function*.



```
GradientResult(x::AbstractArray)
```

Construct a `DiffResult` that can be used for gradient calculations where `x` is the input to the target function.

Note that `GradientResult` allocates its own storage; `x` is only used for type and shape information. If you want to allocate storage yourself, use the `DiffResult` constructor instead.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L29-L38' class='documenter-source'>source</a><br>

<a id='DiffBase.HessianResult' href='#DiffBase.HessianResult'>#</a>
**`DiffBase.HessianResult`** &mdash; *Function*.



```
HessianResult(x::AbstractArray)
```

Construct a `DiffResult` that can be used for Hessian calculations where `x` is the input to the target function.

Note that `HessianResult` allocates its own storage; `x` is only used for type and shape information. If you want to allocate storage yourself, use the `DiffResult` constructor instead.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L66-L75' class='documenter-source'>source</a><br>


<a id='Accessing-data-from-DiffResults-1'></a>

## Accessing data from DiffResults

<a id='DiffBase.value' href='#DiffBase.value'>#</a>
**`DiffBase.value`** &mdash; *Function*.



```
value(r::DiffResult)
```

Return the primal value stored in `r`.

Note that this method returns a reference, not a copy. Thus, if `value(r)` is mutable, mutating `value(r)` will mutate `r`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L88-L95' class='documenter-source'>source</a><br>

<a id='DiffBase.derivative' href='#DiffBase.derivative'>#</a>
**`DiffBase.derivative`** &mdash; *Function*.



```
derivative(r::DiffResult, ::Type{Val{i}} = Val{1})
```

Return the `ith` derivative stored in `r`, defaulting to the first derivative.

Note that this method returns a reference, not a copy. Thus, if `derivative(r)` is mutable, mutating `derivative(r)` will mutate `r`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L117-L124' class='documenter-source'>source</a><br>

<a id='DiffBase.gradient' href='#DiffBase.gradient'>#</a>
**`DiffBase.gradient`** &mdash; *Function*.



```
gradient(r::DiffResult)
```

Return the gradient stored in `r` (equivalent to `derivative(r)`).

Note that this method returns a reference, not a copy. Thus, if `gradient(r)` is mutable, mutating `gradient(r)` will mutate `r`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L167-L174' class='documenter-source'>source</a><br>

<a id='DiffBase.jacobian' href='#DiffBase.jacobian'>#</a>
**`DiffBase.jacobian`** &mdash; *Function*.



```
jacobian(r::DiffResult)
```

Return the Jacobian stored in `r` (equivalent to `derivative(r)`).

Note that this method returns a reference, not a copy. Thus, if `jacobian(r)` is mutable, mutating `jacobian(r)` will mutate `r`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L192-L199' class='documenter-source'>source</a><br>

<a id='DiffBase.hessian' href='#DiffBase.hessian'>#</a>
**`DiffBase.hessian`** &mdash; *Function*.



```
hessian(r::DiffResult)
```

Return the Hessian stored in `r` (equivalent to `derivative(r, Val{2})`).

Note that this method returns a reference, not a copy. Thus, if `hessian(r)` is mutable, mutating `hessian(r)` will mutate `r`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L217-L224' class='documenter-source'>source</a><br>


<a id='Mutating-DiffResults-1'></a>

## Mutating DiffResults

<a id='DiffBase.value!' href='#DiffBase.value!'>#</a>
**`DiffBase.value!`** &mdash; *Function*.



```
value!(r::DiffResult, x)
```

Copy `x` into `r`'s value storage, such that `value(r) == x`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L98-L102' class='documenter-source'>source</a><br>


```
value!(f, r::DiffResult, x)
```

Like `value!(r::DiffResult, x)`, but with `f` applied to each element, such that `value(r) == map(f, x)`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L106-L110' class='documenter-source'>source</a><br>

<a id='DiffBase.derivative!' href='#DiffBase.derivative!'>#</a>
**`DiffBase.derivative!`** &mdash; *Function*.



```
derivative!(r::DiffResult, x, ::Type{Val{i}} = Val{1})
```

Copy `x` into `r`'s `ith` derivative storage, such that `derivative(r, Val{i}) == x`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L127-L131' class='documenter-source'>source</a><br>


```
derivative!(f, r::DiffResult, x, ::Type{Val{i}} = Val{1})
```

Like `derivative!(r::DiffResult, x, Val{i})`, but with `f` applied to each element, such that `derivative(r, Val{i}) == map(f, x)`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L145-L150' class='documenter-source'>source</a><br>

<a id='DiffBase.gradient!' href='#DiffBase.gradient!'>#</a>
**`DiffBase.gradient!`** &mdash; *Function*.



```
gradient!(r::DiffResult, x)
```

Copy `x` into `r`'s gradient storage, such that `gradient(r) == x`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L177-L181' class='documenter-source'>source</a><br>


```
gradient!(f, r::DiffResult, x)
```

Like `gradient!(r::DiffResult, x)`, but with `f` applied to each element, such that `gradient(r) == map(f, x)`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L184-L189' class='documenter-source'>source</a><br>

<a id='DiffBase.jacobian!' href='#DiffBase.jacobian!'>#</a>
**`DiffBase.jacobian!`** &mdash; *Function*.



```
jacobian!(r::DiffResult, x)
```

Copy `x` into `r`'s Jacobian storage, such that `jacobian(r) == x`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L202-L206' class='documenter-source'>source</a><br>


```
jacobian!(f, r::DiffResult, x)
```

Like `jacobian!(r::DiffResult, x)`, but with `f` applied to each element, such that `jacobian(r) == map(f, x)`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L209-L214' class='documenter-source'>source</a><br>

<a id='DiffBase.hessian!' href='#DiffBase.hessian!'>#</a>
**`DiffBase.hessian!`** &mdash; *Function*.



```
hessian!(r::DiffResult, x)
```

Copy `x` into `r`'s Hessian storage, such that `hessian(r) == x`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L227-L231' class='documenter-source'>source</a><br>


```
hessian!(f, r::DiffResult, x)
```

Like `hessian!(r::DiffResult, x)`, but with `f` applied to each element, such that `hessian(r) == map(f, x)`.


<a target='_blank' href='https://github.com/JuliaDiff/DiffBase.jl/tree/3297662a8cb07542267f43331671746ff4bc0adc/src/results.jl#L234-L239' class='documenter-source'>source</a><br>

