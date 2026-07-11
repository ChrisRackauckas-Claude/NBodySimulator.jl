using SciMLTesting, NBodySimulator, JET, Test

run_qa(
    NBodySimulator;
    explicit_imports = true,
    api_docs_kwargs = (;
        rendered = true,
        # These are dependency reexports that lack source docstrings upstream.
        ignore = (
            :DEFAULT_PLOT_FUNC, :DefaultODEAlgorithm, :add_labels!, :plot_indices,
            :plottable_indices, :recursive_bottom_eltype, :recursive_mean,
            :solplot_vecs_and_labels, :tuples, :vecarr_to_vectors, :vecvec_to_mat,
        ),
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
