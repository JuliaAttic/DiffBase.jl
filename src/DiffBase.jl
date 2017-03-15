isdefined(Base, :__precompile__) && __precompile__()

module DiffBase

using Compat

include("results.jl")
include("testfuncs.jl")

######################
# Test Function Sets #
######################
#=
These functions are organized in sets based on input/output type. They are unary and not
in-place unless otherwised specified. These functions have been written with the following
assumptions:

- Array input is of length >= 5
- Matrix input is square
- Matrix inputs for n-ary functions are of equal shape
=#

const NUMBER_TO_NUMBER_FUNCS = (num2num_1, num2num_2, num2num_3,
                                num2num_4, num2num_5, num2num_6)

const NUMBER_TO_ARRAY_FUNCS = (num2arr_1,)

const VECTOR_TO_NUMBER_FUNCS = (vec2num_1, vec2num_2,  vec2num_3, vec2num_4, vec2num_5,
                                rosenbrock_1, rosenbrock_2, rosenbrock_3, rosenbrock_4,
                                ackley, self_weighted_logit, first)

const MATRIX_TO_NUMBER_FUNCS = (det, mat2num_1, mat2num_2, mat2num_3, mat2num_4, softmax)

const INPLACE_ARRAY_TO_ARRAY_FUNCS = (chebyquad!, brown_almost_linear!, trigonometric!,
                                      mutation_test_1!, mutation_test_2!)

const ARRAY_TO_ARRAY_FUNCS = (-, chebyquad, brown_almost_linear, trigonometric, arr2arr_1,
                              arr2arr_2, mutation_test_1, mutation_test_2, identity)

const MATRIX_TO_MATRIX_FUNCS = (inv,)

if VERSION >= v"0.6.0-dev.1614"
    const BINARY_BROADCAST_OPS = ((a, b) -> broadcast(+, a, b),
                                  (a, b) -> broadcast(-, a, b),
                                  (a, b) -> broadcast(*, a, b),
                                  (a, b) -> broadcast(/, a, b),
                                  (a, b) -> broadcast(\, a, b),
                                  (a, b) -> broadcast(^, a, b))
else
    const BINARY_BROADCAST_OPS = (.+, .-, .*, ./, .\, .^)
end

const BINARY_MATRIX_TO_MATRIX_FUNCS = (+, -, *, /, \,
                                       BINARY_BROADCAST_OPS...,
                                       A_mul_Bt, At_mul_B, At_mul_Bt,
                                       A_mul_Bc, Ac_mul_B, Ac_mul_Bc)

const TERNARY_MATRIX_TO_NUMBER_FUNCS = (neural_step,)

end # module
