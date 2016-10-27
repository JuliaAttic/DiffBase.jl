module ResultTests

using DiffBase
using Compat
using Base.Test

using DiffBase: DiffResult, GradientResult, JacobianResult, HessianResult,
                value, value!, derivative, derivative!, gradient, gradient!,
                jacobian, jacobian!, hessian, hessian!

const k = 3
const n0, n1, n2 = rand(), rand(), rand()
const x0, x1, x2 = rand(k), rand(k, k), rand(k, k, k)
const rn, rx = DiffResult(n0, n1, n2), DiffResult(x0, x1, x2)

issimilar(x, y) = typeof(x) == typeof(y) && size(x) == size(y)
issimilar(x::DiffResult, y::DiffResult) = issimilar(value(x), value(y)) && all(issimilar, zip(x.derivs, y.derivs))
issimilar(t::Tuple) = issimilar(t...)

##############
# DiffResult #
##############

@test rn == DiffResult(n0, n1, n2)
@test rx == DiffResult(x0, x1, x2)

@test issimilar(GradientResult(x0), DiffResult(first(x0), x0))
@test issimilar(JacobianResult(x0), DiffResult(x0, similar(x0, k, k)))
@test issimilar(JacobianResult(similar(x0, k + 1), x0), DiffResult(similar(x0, k + 1), similar(x0, k + 1, k)))
@test issimilar(HessianResult(x0), DiffResult(first(x0), x0, similar(x0, k, k)))

@test eltype(rn) === typeof(n0)
@test eltype(rx) === eltype(x0)

rn_copy = copy(rn)
@test rn == rn_copy
@test rn !== rn_copy

rx_copy = copy(rx)
@test rx == rx_copy
@test rx !== rx_copy

# value/value! #
#--------------#

@test value(rn) === n0
@test value(rx) === x0

value!(rn, n1)
@test value(rn) === n1
value!(rn, n0)

x0_new, x0_copy = rand(k), copy(x0)
value!(rx, x0_new)
@test value(rx) === x0 == x0_new
value!(rx, x0_copy)

value!(exp, rn, n1)
@test value(rn) === exp(n1)
value!(rn, n0)

x0_new, x0_copy = rand(k), copy(x0)
value!(exp, rx, x0_new)
@test value(rx) === x0 == @compat(exp.(x0_new))
value!(rx, x0_copy)

# derivative/derivative! #
#------------------------#

@test derivative(rn) === n1
@test derivative(rn, Val{2}) === n2

@test derivative(rx) === x1
@test derivative(rx, Val{2}) === x2

derivative!(rn, n0)
@test derivative(rn) === n0
derivative!(rn, n1)

x1_new, x1_copy = rand(k, k), copy(x1)
derivative!(rx, x1_new)
@test derivative(rx) === x1 == x1_new
derivative!(rx, x1_copy)

derivative!(rn, n1, Val{2})
@test derivative(rn, Val{2}) === n1
derivative!(rn, n2, Val{2})

x2_new, x2_copy = rand(k, k, k), copy(x2)
derivative!(rx, x2_new, Val{2})
@test derivative(rx, Val{2}) === x2 == x2_new
derivative!(rx, x2_copy, Val{2})

derivative!(exp, rn, n0)
@test derivative(rn) === exp(n0)
derivative!(rn, n1)

x1_new, x1_copy = rand(k, k), copy(x1)
derivative!(exp, rx, x1_new)
@test derivative(rx) === x1 == @compat(exp.(x1_new))
derivative!(exp, rx, x1_copy)

derivative!(exp, rn, n1, Val{2})
@test derivative(rn, Val{2}) === exp(n1)
derivative!(rn, n2, Val{2})

x2_new, x2_copy = rand(k, k, k), copy(x2)
derivative!(exp, rx, x2_new, Val{2})
@test derivative(rx, Val{2}) === x2 == @compat(exp.(x2_new))
derivative!(exp, rx, x2_copy, Val{2})

# gradient/gradient! #
#--------------------#

x1_new, x1_copy = rand(k, k), copy(x1)
gradient!(rx, x1_new)
@test gradient(rx) === x1 == x1_new
gradient!(rx, x1_copy)

x1_new, x1_copy = rand(k, k), copy(x1)
gradient!(exp, rx, x1_new)
@test gradient(rx) === x1 == @compat(exp.(x1_new))
gradient!(exp, rx, x1_copy)

# jacobian/jacobian! #
#--------------------#

x1_new, x1_copy = rand(k, k), copy(x1)
jacobian!(rx, x1_new)
@test jacobian(rx) === x1 == x1_new
jacobian!(rx, x1_copy)

x1_new, x1_copy = rand(k, k), copy(x1)
jacobian!(exp, rx, x1_new)
@test jacobian(rx) === x1 == @compat(exp.(x1_new))
jacobian!(exp, rx, x1_copy)

# hessian/hessian! #
#------------------#

x2_new, x2_copy = rand(k, k, k), copy(x2)
hessian!(rx, x2_new)
@test hessian(rx) === x2 == x2_new
hessian!(rx, x2_copy)

x2_new, x2_copy = rand(k, k, k), copy(x2)
hessian!(exp, rx, x2_new)
@test hessian(rx) === x2 == @compat(exp.(x2_new))
hessian!(exp, rx, x2_copy)

end # module
