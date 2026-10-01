#!/usr/bin/env nextflow

nextflow.enable.types = true

record StarRecord {
    bam: Path
    log: Path
}

process VERSE {
    label 'process_single'
    container 'ghcr.io/bf528/verse:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    star: StarRecord
    gtf: Path

    output:
    verse_cts: Path = file("*.exon.txt")

    shell:
    """
    verse -S -a $gtf -o ${star.bam.simpleName} $star.bam
    """
}