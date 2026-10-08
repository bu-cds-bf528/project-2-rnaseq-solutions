#!/usr/bin/env nextflow

nextflow.enable.types = true

process INDEX {
    label 'process_high'
    container 'ghcr.io/bu-cds-bf528/star:latest'

    input:
    fa: Path
    annot: Path

    output:
    idx: Path = file("star_index/")

    script:
    """
    mkdir star_index
    STAR --runThreadN $task.cpus --runMode genomeGenerate --genomeDir star_index --genomeFastaFiles $fa --sjdbGTFfile $annot
    """

    stub:
    """
    mkdir star_index
    """

}