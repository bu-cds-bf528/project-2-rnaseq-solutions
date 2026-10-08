#!/usr/bin/env nextflow

nextflow.enable.types = true


record FastqRec {
    name: String
    fastq: Path

}

record FastQC {
    zip: Path
    html: Path

}

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bu-cds-bf528/fastqc:latest'

    input:
    reads: FastqRec

    output:
    record(zip: file("*.zip"), html: file("*.html"))

    script:
    """
    fastqc -t $task.cpus $reads.fastq
    """

    stub:
    """
    touch ${reads.fastq.simpleName}.html
    touch ${reads.fastq.simpleName}.zip
    """
}