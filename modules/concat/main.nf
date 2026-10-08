#!/usr/bin/env nextflow

nextflow.enable.types = true

process CONCAT {
    container 'ghcr.io/bu-cds-bf528/pandas:latest'
    label 'process_single'

    input:
    cts: List<Path>

    output:
    concat: Path = file("verse_concat.csv")

    script:
    """
    concat_df.py -i ${cts.join(' ')} -o verse_concat.csv
    """

    stub:
    """
    touch verse_concat.csv
    """

}