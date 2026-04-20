nextflow.enable.dsl = 2

if (!params.containsKey('samplesheet')) params.samplesheet = 'samplesheet.csv'
if (!params.containsKey('outdir')) params.outdir = 'results'
if (!params.containsKey('container')) params.container = 'beigebox/kallistogrch38encode44:tagname'
if (!params.containsKey('s3_bucket')) params.s3_bucket = 'ucla-humangenetics-raredisease-sequencing-transferdata1-juno'
def defaultThreads = params.containsKey('default_threads') ? params.default_threads as Integer : 6

def resolveReadPath = { String p ->
    if (!p) return p
    if (p.startsWith('s3://')) return p
    if (p ==~ /^[a-zA-Z][a-zA-Z0-9+.-]*:\/\/.*/) return p
    if (p.startsWith('/') || p.startsWith('./') || p.startsWith('../')) return p
    if (new File(p).exists()) return p

    def key = p.replaceFirst('^/+', '')
    return "s3://${params.s3_bucket}/${key}"
}

workflow {
    Channel
        .fromPath(params.samplesheet, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            def sample = (row.sample ?: row.sample_id ?: '').toString().trim()
            if (!sample) {
                error "Missing sample/sample_id in samplesheet row: ${row}"
            }

            def read1Value = (row.read1 ?: '').toString().trim()
            def read2Value = (row.read2 ?: '').toString().trim()
            if (!read1Value || !read2Value) {
                error "Missing read1/read2 for sample '${sample}'"
            }

            def threads = (row.threads ?: defaultThreads) as Integer
            def read1Path = resolveReadPath(read1Value)
            def read2Path = resolveReadPath(read2Value)
            tuple(sample, file(read1Path, checkIfExists: true), file(read2Path, checkIfExists: true), threads)
        }
        | KALLISTO_QUANT
}

process KALLISTO_QUANT {
    tag "$sample"

    publishDir "${params.outdir}/${sample}", mode: 'copy'

    container params.container
    containerOptions '--entrypoint ""'
    cpus { threads }

    input:
    tuple val(sample), path(read1), path(read2), val(threads)

    output:
    path "${sample}_abundance.tsv"
    path "${sample}_abundance.h5"
    path "${sample}_run_info.json"

    script:
    """
    outdir=kallisto_${sample}

    /opt/run_kallisto.sh \\
      ${read1} \\
      ${read2} \\
      \$outdir \\
      ${task.cpus}

    mv \$outdir/abundance.tsv ${sample}_abundance.tsv
    mv \$outdir/abundance.h5 ${sample}_abundance.h5
    mv \$outdir/run_info.json ${sample}_run_info.json
    """

    stub:
    """
    touch ${sample}_abundance.tsv ${sample}_abundance.h5 ${sample}_run_info.json
    """
}
