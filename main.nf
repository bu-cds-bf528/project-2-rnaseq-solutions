#!/usr/bin/env nextflow

nextflow.enable.types = true

include {FASTQC} from './modules/fastqc'
include {INDEX} from './modules/star_index'
include {ALIGN} from './modules/star_align'
include {SUBSET} from './modules/subset_genome'
include {VERSE} from './modules/verse'
include {CONCAT} from './modules/concat'
include {PARSE_GTF} from './modules/parse_gtf'
include {MULTIQC} from './modules/multiqc'

workflow {
    
    read_ch = channel.fromPath(params.subset_reads).splitCsv(header: true).map { it -> record(name: , r1:, r2: )}

    fastqc_ch = read_ch.flatMap { it -> [record(name:, fastq:), record(name:, fastq:)]}

    gene_map = PARSE_GTF(params.gtf)
    fastqc_out = FASTQC(fastqc_ch)
    
    star_index_ch = INDEX(params.genome, params.gtf)

    bam_ch = ALIGN(read_ch, star_index_ch)

    multiqc_ch = bam_ch.log.mix(fastqc_out.zip).collect(sort: true)
    multiqc_out = MULTIQC(multiqc_ch)
    
    verse_ch = VERSE(bam_ch, params.gtf)

    concat_ch = verse_ch.collect()

    mat = CONCAT(concat_ch)


}
