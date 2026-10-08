#!/usr/bin/env nextflow

nextflow.enable.types = true

include {FASTQC} from './modules/fastqc'
include {INDEX} from './modules/star_index'
include {ALIGN} from './modules/star_align'
include {VERSE} from './modules/verse'
include {CONCAT} from './modules/concat'
include {PARSE_GTF} from './modules/parse_gtf'
include {MULTIQC} from './modules/multiqc'

workflow {

    main:
    
    read_ch = channel.fromPath(params.full_reads).splitCsv(header: true).map { row -> record(name: row.name, r1: file(row.r1), r2: file(row.r2))}

    fastqc_ch = read_ch.flatMap { it -> [record(name: it.name, fastq:it.r1), record(name:it.name, fastq:it.r2)]}

    gene_map = PARSE_GTF(file(params.gtf))
    fastqc_out = FASTQC(fastqc_ch)
    
    idx_ch = channel.of(record(fa: file(params.genome), gtf: file(params.gtf)))

    star_index_ch = INDEX(idx_ch)

    bam_ch = ALIGN(read_ch, star_index_ch)

    multiqc_ch = bam_ch.map { it.log }.mix(fastqc_out.map { it.zip }).collect(sort: true)
    
    multiqc_out = MULTIQC(multiqc_ch)
    
    verse_ch = VERSE(bam_ch, file(params.gtf))

    concat_ch = verse_ch.collect()

    mat = CONCAT(concat_ch)

    publish:

    multiqc_results = multiqc_out
    counts_mat = mat
    gene_ids = gene_map
    
}

output {
    multiqc_results {}
    counts_mat {}
    gene_ids {}


}