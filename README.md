# kallistogrch38encode44

This is kallisto v.0.52 with transcript reference Gencode 44 baked in.
This is meant to align DMD samples.

Note that kallisto v0.52 has a difference index structure than kallisto v0.4x and cannot be used interchangeably.

## index generation

To build grch38 gencode v44 kallisto reference

- download these files

https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/
Transcript sequences: gencode.v44.transcripts.fa.gz
Comprehensive gene annotation: gencode.v44.annotation.gtf.gz


- build the reference using kallisto v0.52


```
~/bin/kallisto-v0.52/kallisto index -i gencode_v44.idx gencode.v44.transcripts.fa.gz
```

The index is `gencode_v44.idx`.


## Docker

Build a docker with the reference built in.

## How to run

The default number of threads is 6, but the last option can specify the number of threads.

```

# Run using docker
kallisto4dmdtransgene=b81740effeea


docker run --rm -it -v `pwd`:/scratch $kallisto4dmdtransgene \
	/scratch/CDMD8305_muscle_S4_R1_001.fastq.gz \
	/scratch/CDMD8305_muscle_S4_R2_001.fastq.gz \
	/scratch/CDMD8305_kallisto \
    12

```