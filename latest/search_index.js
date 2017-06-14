var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#DiffBase-1",
    "page": "Introduction",
    "title": "DiffBase",
    "category": "section",
    "text": "DiffBase provides common utilities employed by various JuliaDiff packages, including:The DiffResult API for extracting multiple orders of derivatives simultaneously\nThe diffrule API for defining reusable derivative definitions\nA suite of test functions for stressing the robustness of differentiation tools"
},

{
    "location": "diffresult_api.html#",
    "page": "DiffResult API",
    "title": "DiffResult API",
    "category": "page",
    "text": ""
},

{
    "location": "diffresult_api.html#DiffResult-API-1",
    "page": "DiffResult API",
    "title": "DiffResult API",
    "category": "section",
    "text": "CurrentModule = DiffBaseSupported By:ForwardDiff\nReverseDiffMany differentiation techniques can calculate primal values and multiple orders of derivatives simultaneously. In other words, there are techniques for computing f(x), ∇f(x) and H(f(x)) in one fell swoop!For this purpose, DiffBase provides the DiffResult type, which can be passed to in-place differentiation methods instead of an output buffer. The method then loads all computed results into the given DiffResult, which the user can query afterwards using DiffBase's API.Here's an example of the DiffResult in action using ForwardDiff:julia> using ForwardDiff, DiffBase\n\njulia> f(x) = sum(sin, x) + prod(tan, x) * sum(sqrt, x);\n\njulia> x = rand(4);\n\n# construct a `DiffResult` with storage for a Hessian, gradient,\n# and primal value based on the type and shape of `x`.\njulia> result = DiffBase.HessianResult(x)\n\n# instead of passing an output buffer to `hessian!`, we pass `result`\njulia> ForwardDiff.hessian!(result, f, x);\n\n# ...and now we can get all the computed data from `result`\njulia> DiffBase.value(result) == f(x)\ntrue\n\njulia> DiffBase.gradient(result) == ForwardDiff.gradient(f, x)\ntrue\n\njulia> DiffBase.hessian(result) == ForwardDiff.hessian(f, x)\ntrueThe rest of this document describes the API for constructing, accessing, and mutating DiffResult instances. For details on how to use a DiffResult with a specific package's methods, please consult that package's documentation."
},

{
    "location": "diffresult_api.html#DiffBase.DiffResult",
    "page": "DiffResult API",
    "title": "DiffBase.DiffResult",
    "category": "Type",
    "text": "DiffResult(value::Union{Number,AbstractArray}, derivs::Tuple{Vararg{Number}})\nDiffResult(value::Union{Number,AbstractArray}, derivs::Tuple{Vararg{AbstractArray}})\n\nReturn r::DiffResult, with output value storage provided by value and output derivative storage provided by derivs.\n\nIn reality, DiffResult is an abstract supertype of two concrete types, MutableDiffResult and ImmutableDiffResult. If all value/derivs are all Numbers or SArrays, then r will be immutable (i.e. r::ImmutableDiffResult). Otherwise, r will be mutable (i.e. r::MutableDiffResult).\n\nNote that derivs can be provide in splatted form, i.e. DiffResult(value, derivs...).\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.JacobianResult",
    "page": "DiffResult API",
    "title": "DiffBase.JacobianResult",
    "category": "Function",
    "text": "JacobianResult(x::AbstractArray)\n\nConstruct a DiffResult that can be used for Jacobian calculations where x is the input to the target function. This method assumes that the target function's output dimension equals its input dimension.\n\nNote that JacobianResult allocates its own storage; x is only used for type and shape information. If you want to allocate storage yourself, use the DiffResult constructor instead.\n\n\n\nJacobianResult(y::AbstractArray, x::AbstractArray)\n\nConstruct a DiffResult that can be used for Jacobian calculations where x is the input to the target function, and y is the output (e.g. when taking the Jacobian of f!(y, x)).\n\nLike the single argument version, y and x are only used for type and shape information and are not stored in the returned DiffResult.\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.GradientResult",
    "page": "DiffResult API",
    "title": "DiffBase.GradientResult",
    "category": "Function",
    "text": "GradientResult(x::AbstractArray)\n\nConstruct a DiffResult that can be used for gradient calculations where x is the input to the target function.\n\nNote that GradientResult allocates its own storage; x is only used for type and shape information. If you want to allocate storage yourself, use the DiffResult constructor instead.\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.HessianResult",
    "page": "DiffResult API",
    "title": "DiffBase.HessianResult",
    "category": "Function",
    "text": "HessianResult(x::AbstractArray)\n\nConstruct a DiffResult that can be used for Hessian calculations where x is the input to the target function.\n\nNote that HessianResult allocates its own storage; x is only used for type and shape information. If you want to allocate storage yourself, use the DiffResult constructor instead.\n\n\n\n"
},

{
    "location": "diffresult_api.html#Constructing-DiffResults-1",
    "page": "DiffResult API",
    "title": "Constructing DiffResults",
    "category": "section",
    "text": "DiffBase.DiffResult\nDiffBase.JacobianResult\nDiffBase.GradientResult\nDiffBase.HessianResult"
},

{
    "location": "diffresult_api.html#DiffBase.value",
    "page": "DiffResult API",
    "title": "DiffBase.value",
    "category": "Function",
    "text": "value(r::DiffResult)\n\nReturn the primal value stored in r.\n\nNote that this method returns a reference, not a copy.\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.derivative",
    "page": "DiffResult API",
    "title": "DiffBase.derivative",
    "category": "Function",
    "text": "derivative(r::DiffResult, ::Type{Val{i}} = Val{1})\n\nReturn the ith derivative stored in r, defaulting to the first derivative.\n\nNote that this method returns a reference, not a copy.\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.gradient",
    "page": "DiffResult API",
    "title": "DiffBase.gradient",
    "category": "Function",
    "text": "gradient(r::DiffResult)\n\nReturn the gradient stored in r.\n\nEquivalent to derivative(r, Val{1}).\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.jacobian",
    "page": "DiffResult API",
    "title": "DiffBase.jacobian",
    "category": "Function",
    "text": "jacobian(r::DiffResult)\n\nReturn the Jacobian stored in r.\n\nEquivalent to derivative(r, Val{1}).\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.hessian",
    "page": "DiffResult API",
    "title": "DiffBase.hessian",
    "category": "Function",
    "text": "hessian(r::DiffResult)\n\nReturn the Hessian stored in r.\n\nEquivalent to derivative(r, Val{2}).\n\n\n\n"
},

{
    "location": "diffresult_api.html#Accessing-data-from-DiffResults-1",
    "page": "DiffResult API",
    "title": "Accessing data from DiffResults",
    "category": "section",
    "text": "DiffBase.value\nDiffBase.derivative\nDiffBase.gradient\nDiffBase.jacobian\nDiffBase.hessian"
},

{
    "location": "diffresult_api.html#DiffBase.value!",
    "page": "DiffResult API",
    "title": "DiffBase.value!",
    "category": "Function",
    "text": "value!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except for value(s) == x.\n\nThis function may or may not mutate r. If r::ImmutableDiffResult, a totally new instance will be created and returned, whereas if r::MutableDiffResult, then r will be mutated in-place and returned. Thus, this function should be called as r = value!(r, x).\n\n\n\nvalue!(f, r::DiffResult, x)\n\nEquivalent to value!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.derivative!",
    "page": "DiffResult API",
    "title": "DiffBase.derivative!",
    "category": "Function",
    "text": "derivative!(r::DiffResult, x, ::Type{Val{i}} = Val{1})\n\nReturn s::DiffResult with the same data as r, except derivative(s, Val{i}) == x.\n\nThis function may or may not mutate r. If r::ImmutableDiffResult, a totally new instance will be created and returned, whereas if r::MutableDiffResult, then r will be mutated in-place and returned. Thus, this function should be called as r = derivative!(r, x, Val{i}).\n\n\n\nderivative!(f, r::DiffResult, x, ::Type{Val{i}} = Val{1})\n\nEquivalent to derivative!(r::DiffResult, map(f, x), Val{i}), but without the implied temporary allocation (when possible).\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.gradient!",
    "page": "DiffResult API",
    "title": "DiffBase.gradient!",
    "category": "Function",
    "text": "gradient!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except gradient(s) == x.\n\nEquivalent to derivative!(r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\ngradient!(f, r::DiffResult, x)\n\nEquivalent to gradient!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\nEquivalent to derivative!(f, r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.jacobian!",
    "page": "DiffResult API",
    "title": "DiffBase.jacobian!",
    "category": "Function",
    "text": "jacobian!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except jacobian(s) == x.\n\nEquivalent to derivative!(r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\njacobian!(f, r::DiffResult, x)\n\nEquivalent to jacobian!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\nEquivalent to derivative!(f, r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult_api.html#DiffBase.hessian!",
    "page": "DiffResult API",
    "title": "DiffBase.hessian!",
    "category": "Function",
    "text": "hessian!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except hessian(s) == x.\n\nEquivalent to derivative!(r, x, Val{2}); see derivative! docs for aliasing behavior.\n\n\n\nhessian!(f, r::DiffResult, x)\n\nEquivalent to hessian!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\nEquivalent to derivative!(f, r, x, Val{2}); see derivative! docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult_api.html#Mutating-DiffResults-1",
    "page": "DiffResult API",
    "title": "Mutating DiffResults",
    "category": "section",
    "text": "DiffBase.value!\nDiffBase.derivative!\nDiffBase.gradient!\nDiffBase.jacobian!\nDiffBase.hessian!"
},

{
    "location": "diffrule_api.html#",
    "page": "diffrule API",
    "title": "diffrule API",
    "category": "page",
    "text": ""
},

{
    "location": "diffrule_api.html#DiffBase.@define_diffrule",
    "page": "diffrule API",
    "title": "DiffBase.@define_diffrule",
    "category": "Macro",
    "text": "@define_diffrule f(x) = :(df_dx($x))\n@define_diffrule f(x, y) = :(df_dx($x, $y)), :(df_dy($x, $y))\n⋮\n\nDefine a new differentiation rule for the function f and the given arguments, which should be treated as bindings to Julia expressions.\n\nThe RHS should be a function call with a non-splatted argument list, and the LHS should be the derivative expression, or in the n-ary case, and n-tuple of expressions where the ith expression is the derivative of f w.r.t the ith argument. Arguments should interpolated wherever they are used on the RHS.\n\nThis rule is purely symbolic - no type annotations should be used.\n\nExamples:\n\n@define_diffrule cos(x)          = :(-sin($x))\n@define_diffrule /(x, y)         = :(inv($y)), :(-$x / ($y^2))\n@define_diffrule polygamma(m, x) = :NaN,       :(polygamma($m + 1, $x))\n\n\n\n"
},

{
    "location": "diffrule_api.html#DiffBase.diffrule",
    "page": "diffrule API",
    "title": "DiffBase.diffrule",
    "category": "Function",
    "text": "diffrule(f::Symbol, args...)\n\nReturn the derivative expression for f at the given argument(s), with the argument(s) interpolated into the returned expression.\n\nIn the n-ary case, an n-tuple of expressions will be returned where the ith expression is the derivative of f w.r.t the ith argument.\n\nExamples:\n\njulia> DiffBase.diffrule(:sin, 1)\n:(cos(1))\n\njulia> DiffBase.diffrule(:sin, :x)\n:(cos(x))\n\njulia> DiffBase.diffrule(:sin, :(x * y^2))\n:(cos(x * y ^ 2))\n\njulia> DiffBase.diffrule(:^, :(x + 2), :c)\n(:(c * (x + 2) ^ (c - 1)), :((x + 2) ^ c * log(x + 2)))\n\n\n\n"
},

{
    "location": "diffrule_api.html#DiffBase.hasdiffrule",
    "page": "diffrule API",
    "title": "DiffBase.hasdiffrule",
    "category": "Function",
    "text": "hasdiffrule(f::Symbol, arity::Int)\n\nReturn true if a differentiation rule is defined for f and arity, or returns false otherwise.\n\nHere, arity refers to the number of arguments accepted by f.\n\nExamples:\n\njulia> DiffBase.hasdiffrule(:sin, 1)\ntrue\n\njulia> DiffBase.hasdiffrule(:sin, 2)\nfalse\n\njulia> DiffBase.hasdiffrule(:-, 1)\ntrue\n\njulia> DiffBase.hasdiffrule(:-, 2)\ntrue\n\njulia> DiffBase.hasdiffrule(:-, 3)\nfalse\n\n\n\n"
},

{
    "location": "diffrule_api.html#diffrule-API-1",
    "page": "diffrule API",
    "title": "diffrule API",
    "category": "section",
    "text": "CurrentModule = DiffBaseMany differentiation methods rely on the notion of \"primitive\" definitions that comprise \"building blocks\" that can be composed via various formulations of the chain rule.To facilitate the definition and use of such rules, DiffBase provides the diffrule API. These methods  allows you to define derivative rules, query which rules exist, and symbolically apply the rules to function call expressions.The complete list of differentiation rules defined by DiffBase can be found in DiffBase/src/rules.jl.DiffBase.@define_diffrule\nDiffBase.diffrule\nDiffBase.hasdiffrule"
},

]}
