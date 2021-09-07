# ~/.julia/config/startup.jl

atreplinit() do repl
	@eval using Revise
	push!(LOAD_PATH, pwd())
end
