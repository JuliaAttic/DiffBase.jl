##############
# DiffResult #
##############

@compat type DiffResult{O,V,D<:Tuple}
    value::V
    derivs::D # ith element = ith-order derivative
    function (::Type{DiffResult{O,V,D}}){O,V,D}(value::V, derivs::NTuple{O,Any})
        return new{O,V,D}(value, derivs)
    end
end

"""
    DiffResult(value, derivs::Tuple)

Return a `DiffResult` instance where values will be stored in the provided `value` storage
and derivatives will be stored in the provided `derivs` storage.

Note that the arguments can be `Number`s or `AbstractArray`s, depending on the dimensionality
of your target function.
"""
DiffResult{V,O}(value::V, derivs::NTuple{O,Any}) = DiffResult{O,V,typeof(derivs)}(value, derivs)

"""
    DiffResult(value, derivs...)

Equivalent to `DiffResult(value, derivs::Tuple)`, where `derivs...` is the splatted form of `derivs::Tuple`.
"""
DiffResult(value, derivs...) = DiffResult(value, derivs)

"""
    GradientResult(x::AbstractArray)

Construct a `DiffResult` that can be used for gradient calculations where `x` is the
input to the target function.

Note that `GradientResult` allocates its own storage; `x` is only used for type and
shape information. If you want to allocate storage yourself, use the `DiffResult`
constructor instead.
"""
GradientResult(x::AbstractArray) = DiffResult(first(x), similar(x))

"""
    JacobianResult(x::AbstractArray)

Construct a `DiffResult` that can be used for Jacobian calculations where `x` is the
input to the target function. This method assumes that the target function's output
dimension equals its input dimension.

Note that `JacobianResult` allocates its own storage; `x` is only used for type and
shape information. If you want to allocate storage yourself, use the `DiffResult`
constructor instead.
"""
JacobianResult(x::AbstractArray) = DiffResult(similar(x), similar(x, length(x), length(x)))

"""
    JacobianResult(y::AbstractArray, x::AbstractArray)

Construct a `DiffResult` that can be used for Jacobian calculations where `x` is the
input to the target function, and `y` is the output (e.g. when taking the Jacobian
of `f!(y, x)`).

Like the single argument version, `y` and `x` are only used for type and
shape information and are not stored in the returned `DiffResult`.
"""
JacobianResult(y::AbstractArray, x::AbstractArray) = DiffResult(similar(y), similar(y, length(y), length(x)))

"""
    HessianResult(x::AbstractArray)

Construct a `DiffResult` that can be used for Hessian calculations where `x` is the
input to the target function.

Note that `HessianResult` allocates its own storage; `x` is only used for type and
shape information. If you want to allocate storage yourself, use the `DiffResult`
constructor instead.
"""
HessianResult(x::AbstractArray) = DiffResult(first(x), similar(x), similar(x, length(x), length(x)))

Base.eltype(r::DiffResult) = eltype(typeof(r))
Base.eltype{O,V,D}(::Type{DiffResult{O,V,D}}) = eltype(V)

@compat Base.:(==)(a::DiffResult, b::DiffResult) = a.value == b.value && a.derivs == b.derivs

Base.copy(r::DiffResult) = DiffResult(copy(r.value), map(copy, r.derivs))

# value/value! #
#--------------#

"""
    value(r::DiffResult)

Return the primal value stored in `r`.

Note that this method returns a reference, not a copy. Thus, if `value(r)` is mutable,
mutating `value(r)` will mutate `r`.
"""
value(r::DiffResult) = r.value

"""
    value!(r::DiffResult, x)

Copy `x` into `r`'s value storage, such that `value(r) == x`.
"""
value!(r::DiffResult, x::Number) = (r.value = x; return r)
value!(r::DiffResult, x::AbstractArray) = (copy!(value(r), x); return r)

"""
    value!(f, r::DiffResult, x)

Like `value!(r::DiffResult, x)`, but with `f` applied to each element, such that `value(r) == map(f, x)`.
"""
value!(f, r::DiffResult, x::Number) = (r.value = f(x); return r)
value!(f, r::DiffResult, x::AbstractArray) = (map!(f, value(r), x); return r)

# derivative/derivative! #
#------------------------#

"""
    derivative(r::DiffResult, ::Type{Val{i}} = Val{1})

Return the `ith` derivative stored in `r`, defaulting to the first derivative.

Note that this method returns a reference, not a copy. Thus, if `derivative(r)` is mutable,
mutating `derivative(r)` will mutate `r`.
"""
derivative{i}(r::DiffResult, ::Type{Val{i}} = Val{1}) = r.derivs[i]

"""
    derivative!(r::DiffResult, x, ::Type{Val{i}} = Val{1})

Copy `x` into `r`'s `ith` derivative storage, such that `derivative(r, Val{i}) == x`.
"""
@generated function derivative!{O,i}(r::DiffResult{O}, x::Number, ::Type{Val{i}} = Val{1})
    newderivs = Expr(:tuple, [i == n ? :(x) : :(derivative(r, Val{$n})) for n in 1:O]...)
    return quote
        r.derivs = $newderivs
        return r
    end
end

function derivative!{i}(r::DiffResult, x::AbstractArray, ::Type{Val{i}} = Val{1})
    copy!(derivative(r, Val{i}), x)
    return r
end

"""
    derivative!(f, r::DiffResult, x, ::Type{Val{i}} = Val{1})

Like `derivative!(r::DiffResult, x, Val{i})`, but with `f` applied to each element,
such that `derivative(r, Val{i}) == map(f, x)`.
"""
@generated function derivative!{O,i}(f, r::DiffResult{O}, x::Number, ::Type{Val{i}} = Val{1})
    newderivs = Expr(:tuple, [i == n ? :(f(x)) : :(derivative(r, Val{$n})) for n in 1:O]...)
    return quote
        r.derivs = $newderivs
        return r
    end
end

function derivative!{i}(f, r::DiffResult, x::AbstractArray, ::Type{Val{i}} = Val{1})
    map!(f, derivative(r, Val{i}), x)
    return r
end

# special-cased methods #
#-----------------------#

"""
    gradient(r::DiffResult)

Return the gradient stored in `r` (equivalent to `derivative(r)`).

Note that this method returns a reference, not a copy. Thus, if `gradient(r)` is mutable,
mutating `gradient(r)` will mutate `r`.
"""
gradient(r::DiffResult) = derivative(r)

"""
    gradient!(r::DiffResult, x)

Copy `x` into `r`'s gradient storage, such that `gradient(r) == x`.
"""
gradient!(r::DiffResult, x) = derivative!(r, x)

"""
    gradient!(f, r::DiffResult, x)

Like `gradient!(r::DiffResult, x)`, but with `f` applied to each element,
such that `gradient(r) == map(f, x)`.
"""
gradient!(f, r::DiffResult, x) = derivative!(f, r, x)

"""
    jacobian(r::DiffResult)

Return the Jacobian stored in `r` (equivalent to `derivative(r)`).

Note that this method returns a reference, not a copy. Thus, if `jacobian(r)` is mutable,
mutating `jacobian(r)` will mutate `r`.
"""
jacobian(r::DiffResult) = derivative(r)

"""
    jacobian!(r::DiffResult, x)

Copy `x` into `r`'s Jacobian storage, such that `jacobian(r) == x`.
"""
jacobian!(r::DiffResult, x) = derivative!(r, x)

"""
    jacobian!(f, r::DiffResult, x)

Like `jacobian!(r::DiffResult, x)`, but with `f` applied to each element,
such that `jacobian(r) == map(f, x)`.
"""
jacobian!(f, r::DiffResult, x) = derivative!(f, r, x)

"""
    hessian(r::DiffResult)

Return the Hessian stored in `r` (equivalent to `derivative(r, Val{2})`).

Note that this method returns a reference, not a copy. Thus, if `hessian(r)` is mutable,
mutating `hessian(r)` will mutate `r`.
"""
hessian(r::DiffResult) = derivative(r, Val{2})

"""
    hessian!(r::DiffResult, x)

Copy `x` into `r`'s Hessian storage, such that `hessian(r) == x`.
"""
hessian!(r::DiffResult, x) = derivative!(r, x, Val{2})

"""
    hessian!(f, r::DiffResult, x)

Like `hessian!(r::DiffResult, x)`, but with `f` applied to each element,
such that `hessian(r) == map(f, x)`.
"""
hessian!(f, r::DiffResult, x) = derivative!(f, r, x, Val{2})
