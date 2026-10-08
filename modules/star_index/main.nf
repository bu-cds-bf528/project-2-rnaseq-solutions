#!/usr/bin/env nextflow

nextflow.enable.types = true


record IdxRecord {
    fa: Path
    gtf: Path
}

process INDEX {
    label 'process_high'
    container 'ghcr.io/bu-cds-bf528/star:latest'

    input:
    references: IdxRecord

    output:
    idx: Path = file("star_index/")

    script:
    """
    mkdir star_index
    STAR --runThreadN $task.cpus --runMode genomeGenerate --genomeDir star_index --genomeFastaFiles $references.fa --sjdbGTFfile $references.gtf
    """

    stub:
    """
    mkdir star_index
    """

}