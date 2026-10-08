#!/usr/bin/env nextflow

nextflow.enable.types = true

process MULTIQC {
    label 'process_single'
    container 'ghcr.io/bu-cds-bf528/multiqc:latest'

    input:
    logs: List<Path>

    output:
    report: Path = file("multiqc_report.html")

    script:
    """
    multiqc .
    """

    stub:
    """
    touch multiqc_report.html
    """
}