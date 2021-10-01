# ~/.julia/config/startup.jl

push!(LOAD_PATH, pwd())

atreplinit() do repl
	@eval using Revise
end
