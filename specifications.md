# Objective


# Inputs

Describe the starting data including:

1. How many samples?
2. Where and how the samples are recorded? (i.e. a samplesheet with columns named X, Y, Z, etc.)

# Outputs

Per Sample:




Per pipeline run:




# Pipeline Steps

Fill in one row per process in the pipeline. Derive the step list from the Objective and Outputs
sections above. "Depends on" should name the upstream step(s) whose output this step consumes
(used for wiring channels).

The rows below are a simple worked example (not from this pipeline) showing the expected format:
a process that downloads a genome, followed by a process that runs a script on it. Delete this
example table before you submit.

| Step | Input type | Depends on *(sample)* |
|---|---|---|
| Download genome *(sample)* | Accession ID | - |
| Run script on genome *(sample)* | Genome FASTA | Download genome |

| Step | Input type | Depends on |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |

# Development Workflow

Every process defines a `stub:` run that produces placeholder output files. All of
the stub runs should use the name from the CSV to identify outputs by their species
of origin.

# Environment and Reproducibility
Conda environments are defined per-tool in the envs/ directory.

For each tool used in the pipeline, confirm the conda env pins an exact version (not just a
channel), and note any tool where exact pinning isn't possible (e.g., no conda-forge/bioconda
package) and how you're mitigating that.

| Tool | Env file | Version pinned? |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |


# Resource Requirements

Every process has been assigned a label found in `nextflow.config` that requisitions
an appropriate amount of resources. The most resource intensive steps include Bowtie2 
index creation, alignment of the short reads, draft assembly by Flye, and assembly polishing
by pilon.


# Success Criteria

The stub-run correctly produces named placeholder outputs for each row in the original CSV.

# Out of Scope


# Validation Table


| Step | Parameter justification *(sample)* | Confidence *(sample)* | Validation *(sample)* |
|---|---|---|---|
| Sequencing quality control | Default FastQC parameters; adapter trimming skipped since STAR soft-clips at alignment | High | Per-base quality >Q30 across all cycles, all 3 samples |
| Alignment | Default STAR parameters, appropriate for 100bp paired-end reads | Medium | 88-92% uniquely-mapped across samples |
| Post-alignment QC | Default RSeQC settings; no strandedness flag since library prep is unstranded | Medium | >80% of reads in CDS exons + UTRs, consistent with poly-A selection |
| QC aggregation & reporting | Default MultiQC settings; no custom config needed | High | All 3 samples present in every module of the report |

