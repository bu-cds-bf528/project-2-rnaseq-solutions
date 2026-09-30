#!/usr/bin/env nextflow

include {FASTQC} from './modules/fastqc'
include {INDEX} from './modules/star_index'
include {ALIGN} from './modules/star_align'
include {SUBSET} from './modules/subset_genome'
include {VERSE} from './modules/verse'
include {CONCAT} from './modules/concat'
include {PARSE_GTF} from './modules/parse_gtf'
include {MULTIQC} from './modules/multiqc'

workflow {
    
    Channel.fromFilePairs(params.reads).transpose().set{ fastqc_ch }
    Channel.fromFilePairs(params.reads).set { align_ch }

    
    PARSE_GTF(params.gtf)
    FASTQC(fastqc_ch)
    INDEX(params.genome, params.gtf)

    ALIGN(align_ch, INDEX.out.index)

    FASTQC.out.zip.map{ it[1] }.collect()
    | set { fastqc_out }

    ALIGN.out.log.map{ it[1] }.collect()
    | set { star_log }

    fastqc_out.mix(star_log).flatten().collect()
    | set { multiqc_ch }


    MULTIQC(multiqc_ch)
    
    VERSE(ALIGN.out.bam, params.gtf)

    VERSE.out.counts.map{ it[1] }.collect().set{ concat_ch } 

    CONCAT(concat_ch)

    multiqc_ch.view()

}
