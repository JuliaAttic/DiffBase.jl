##############
# DiffResult #
##############

type DiffResult{O,V,D<:Tuple}
    value::V
    derivs::D # ith element = ith-order derivative
    DiffResult{O}(value::V, derivs::NTuple{O}) = new(value, derivs)
end

DiffResult{V,O}(value::V, derivs::NTuple{O}) = DiffResult{O,V,typeof(derivs)}(value, derivs)
DiffResult(value, derivs...) = DiffResult(value, derivs)
DiffResult(value) = DiffResult(copy(value), copy(value))

# can't define both these typealiases and the constructors on v0.4 or lower
if VERSION >= v"0.5-"
typealias GradientResult{V<:Number,G} DiffResult{1,V,Tuple{G}}
typealias JacobianResult{V<:AbstractArray,J} DiffResult{1,V,Tuple{J}}
typealias HessianResult{V,G,H} DiffResult{2,V,Tuple{G,H}}
end

GradientResult(x::AbstractArray) = DiffResult(first(x), similar(x))
JacobianResult(x::AbstractArray) = DiffResult(similar(x), similar(x, length(x), length(x)))
JacobianResult(y::AbstractArray, x::AbstractArray) = DiffResult(similar(y), similar(y, length(y), length(x)))
HessianResult(x::AbstractArray) = DiffResult(first(x), similar(x), similar(x, length(x), length(x)))

Base.eltype(r::DiffResult) = eltype(typeof(r))
Base.eltype{O,V,D}(::Type{DiffResult{O,V,D}}) = eltype(V)

Base.:(==)(a::DiffResult, b::DiffResult) = a.value == b.value && a.derivs == b.derivs

# value/value! #
#--------------#

value(r::DiffResult) = r.value

value!(r::DiffResult, x::Number) = (r.value = x; return r)
value!(r::DiffResult, x::AbstractArray) = (copy!(value(r), x); return r)

value!(f, r::DiffResult, x::Number) = (r.value = f(x); return r)
value!(f, r::DiffResult, x::AbstractArray) = (map!(f, value(r), x); return r)

# derivative/derivative! #
#------------------------#

derivative{i}(r::DiffResult, ::Type{Val{i}} = Val{1}) = r.derivs[i]

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

gradient(r::DiffResult) = derivative(r)
gradient!(r::DiffResult, x) = derivative!(r, x)
gradient!(f, r::DiffResult, x) = derivative!(f, r, x)

jacobian(r::DiffResult) = derivative(r)
jacobian!(r::DiffResult, x) = derivative!(r, x)
jacobian!(f, r::DiffResult, x) = derivative!(f, r, x)

hessian(r::DiffResult) = derivative(r, Val{2})
hessian!(r::DiffResult, x) = derivative!(r, x, Val{2})
hessian!(f, r::DiffResult, x) = derivative!(f, r, x, Val{2})
