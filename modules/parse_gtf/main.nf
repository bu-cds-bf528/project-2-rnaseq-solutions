#!/usr/bin/env nextflow

nextflow.enable.types = true

process PARSE_GTF {

    label 'process_single'
    container 'ghcr.io/bu-cds-bf528/biopython:latest'

    input:
    ref: Path
    
    output:
    gene_map: Path = file("id2name.txt")

    script:
    """
    parse_gtf.py -i $ref -o id2name.txt
    """

    stub:
    """
    touch id2name.txt
    """


}