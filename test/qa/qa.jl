using SciMLTesting, NBodySimulator, JET, Test

const OWNED_PUBLIC_API = (
    :AndersenThermostat,
    :BerendsenThermostat,
    :ChargedParticle,
    :ChargedParticles,
    :CubicPeriodicBoundaryConditions,
    :ElectrostaticParameters,
    :GravitationalParameters,
    :GravitationalSystem,
    :InfiniteBox,
    :LangevinThermostat,
    :LennardJonesParameters,
    :MagneticParticle,
    :MagnetostaticParameters,
    :MassBody,
    :NBodySimulation,
    :NoseHooverThermostat,
    :PeriodicBoundaryConditions,
    :PotentialNBodySystem,
    :PotentialParameters,
    :SPCFwParameters,
    :WaterSPCFw,
    :generate_bodies_in_cell_nodes,
    :get_accelerating_function,
    :get_masses,
    :get_position,
    :get_velocity,
    :initial_energy,
    :kinetic_energy,
    :load_water_molecules_from_pdb,
    :msd,
    :potential_energy,
    :rdf,
    :run_simulation,
    :save_to_pdb,
    :temperature,
    :total_energy,
)

const DEPENDENCY_REEXPORTS = Tuple(
    setdiff(names(NBodySimulator), (:NBodySimulator, OWNED_PUBLIC_API...))
)

run_qa(
    NBodySimulator;
    explicit_imports = true,
    api_docs_kwargs = (;
        rendered = true,
        # NBodySimulator reexports solver APIs for convenience; their API docs live
        # in the packages that define them.
        ignore = DEPENDENCY_REEXPORTS,
        rendered_ignore = DEPENDENCY_REEXPORTS,
    ),
    # Aqua sub-checks tracked-broken in https://github.com/SciML/NBodySimulator.jl/issues/117:
    #   stale_deps:   JLArrays declared in [deps] but unused in src/
    #   deps_compat:  Printf, Random (used in src/) lack [compat] bounds
    aqua_broken = (:stale_deps, :deps_compat),
    # `@def`, `AbstractTimeseriesSolution`, `DECallback` are SciMLBase names accessed
    # via DiffEqBase (which re-exports them); ExplicitImports attributes them to their
    # SciMLBase owner. They go public/owner-clean as those base libs release.
    ei_kwargs = (;
        all_qualified_accesses_via_owners = (;
            ignore = (Symbol("@def"), :AbstractTimeseriesSolution, :DECallback),
        ),
        all_qualified_accesses_are_public = (;
            ignore = (Symbol("@def"), :AbstractTimeseriesSolution, :DECallback),
        ),
    ),
    # 39 implicit imports via heavy `@reexport using DiffEqBase, OrdinaryDiffEq, ...`;
    # a mass `using X: a, b` refactor is risky alongside @reexport — tracked in
    # https://github.com/SciML/NBodySimulator.jl/issues/121
    ei_broken = (:no_implicit_imports,),
)
