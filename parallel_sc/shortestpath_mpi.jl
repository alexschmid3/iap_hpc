
using CSV, DataFrames, MPI

include("scripts/spfunction.jl")

#Initialize MPI 
MPI.init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
nproc = MPI.Comm_size(MPI.comm)

runs = 1:50
outputfile = "outputs/paralleloutput.csv"

#Select the runs for this particular rank (cycling, like dealing cards)
myrunlist = runs[rank+1:nproc:length(runs)]

#Initialize time 
inittime = time()

#Run the runids that were dealt to this rank!
mynumnodes_list, myspcost_list, myelapsedtime_list = [], [], []
for runid in myrunlist

	#Get the input file for the runid
	networkfile = string("data/network", runid, ".csv")

	#Read data
	data = CSV.read(networkfile, DataFrame)

	#Format data
	nodes = []
	for i in 1:size(data)[1]
		push!(nodes, data[i,2])
		push!(nodes, data[i,3])
	end
	nodes = unique!(nodes)
	numnodes = length(nodes)

	arcs, arcstartnode, arcendnode = [], [], []
	arccost = []
	A_plus = Dict()
	for n in nodes
		A_plus[n] = []
	end
	for i in 1:size(data)[1]
		push!(arcs, data[i,1])
		push!(arcstartnode, data[i,2])
		push!(arcendnode, data[i,3])
		push!(arccost, data[i,4])
		push!(A_plus[data[i,2]], data[i,1])
	end
	numarcs = length(arcs)

	orig = 1
	dest = numnodes

	#Solve shortest path
	begintime = time()
	spcost, spnodes= findshortestpath(orig, dest)
	endtime = time()
	elapsedtime = endtime - begintime

	#Save the relevant runid data
	push!(mynumnodes_list, numnodes)
	push!(myspcost_list, spcost)
	push!(myelapsedtime_list, elapsedtime)

end

#---------------------------------------------------------------------------------------#

#Merge the outputs of the ranks together
runid_list = merge(+, myrunid_list)
numnodes_list = merge(+, mynumnodes_list)
spcost_list = merge(+, myspcost_list)
elapsedtime_list = merge(+, myelapsedtime_list)

#---------------------------------------------------------------------------------------#

#Write a single file with all data
df = (runid = [runid_list], 
	numnodes = [numnodes_list],
	cost = [spcost_list],
	solvetime = [elapsedtime_list]
	)

CSV.write(outputfile, df)
