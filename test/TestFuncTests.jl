module TestFuncTests

using DiffBase
using Base.Test

n = rand()
x, y = rand(5, 5), rand(26)
A, B = rand(5, 5), rand(5, 5)

# f returns Number

for f in DiffBase.NUMBER_TO_NUMBER_FUNCS
    @test isa(f(n), Number)
end

for f in DiffBase.VECTOR_TO_NUMBER_FUNCS
    @test isa(f(y), Number)
end

for f in DiffBase.MATRIX_TO_NUMBER_FUNCS
    @test isa(f(x), Number)
end

for f in DiffBase.TERNARY_MATRIX_TO_NUMBER_FUNCS
    @test isa(f(A, B, x), Number)
end

# f returns Array

for f in DiffBase.NUMBER_TO_ARRAY_FUNCS
    @test isa(f(n), Array)
end

for f in DiffBase.ARRAY_TO_ARRAY_FUNCS
    @test isa(f(A), Array)
    @test isa(f(y), Array)
end

for f in DiffBase.MATRIX_TO_MATRIX_FUNCS
    @test isa(f(A), Array)
end

for f in DiffBase.BINARY_MATRIX_TO_MATRIX_FUNCS
    @test isa(f(A, B), Array)
end

# f! returns Void

for f! in DiffBase.INPLACE_ARRAY_TO_ARRAY_FUNCS
    @test isa(f!(y, x), Void)
end

for f! in DiffBase.INPLACE_NUMBER_TO_ARRAY_FUNCS
    @test isa(f!(y, n), Void)
end

end # module
