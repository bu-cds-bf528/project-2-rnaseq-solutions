#!/usr/bin/env nextflow

nextflow.enable.types = true

record SampleRecord {
    name: String
    r1: Path
    r2: Path
}

record StarRecord {
    bam: Path
    log: Path
}

process ALIGN {
    label 'process_high'
    container 'ghcr.io/bu-cds-bf528/star:latest'

    input:
    sample: SampleRecord
    index: Path

    output:
    record(bam: file("*.bam"), log: file("*.Log.final.out"))

    script:
    """
    STAR --runThreadN $task.cpus --genomeDir $index --readFilesIn $sample.r1 $sample.r2 --readFilesCommand zcat --outFileNamePrefix ${sample.name}. --outSAMtype BAM Unsorted
    """

    stub:
    """
    touch ${sample.name}.bam
    touch ${sample.name}.log
    """
}