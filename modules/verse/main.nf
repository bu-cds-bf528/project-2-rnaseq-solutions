#!/usr/bin/env nextflow

nextflow.enable.types = true

record StarRecord {
    bam: Path
    log: Path
}

process VERSE {
    label 'process_medium'
    container 'ghcr.io/bu-cds-bf528/verse:latest'


    input:
    star: StarRecord
    gtf: Path

    output:
    verse_cts: Path = file("*.exon.txt")

    shell:
    """
    verse -S -a $gtf -o ${star.bam.simpleName} $star.bam
    """

    stub:
    """
    touch ${star.bam.simpleName}.exon.txt
    """
}