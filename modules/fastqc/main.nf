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
    container 'ghcr.io/bf528/fastqc:latest'

    input:
    reads: FastqRec

    output:
    record(zip: "*.zip", html: "*.zip")

    script:
    """
    fastqc -t $task.cpus $reads.fastq
    """
}